function  train(data,R,top_k)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here
global TRAIN_class_labels
global num_Class
global num_obj
global Node_Obj_List
global Final_Sh
global USAX_Map
global Score_List
global Classify_list
global Org_Class_Freq_new
global Org_Label
global Org_Data
global Class_Freq
global Label
global Data
global class_entropy
global SH_MIN_LEN
global subseq_len
global Final_Sh_index
global min_len
global step
Final_Sh_index = 1 ; 
[ sax_len, w ]=deal (0);
max_len = size(data,2);
min_len = 5 ;
sh = Shapelet ;
Node_Obj_List = java.util.ArrayList;

num_obj = size(data,1);
num_Class = length(unique(TRAIN_class_labels));
Org_Class_Freq_new = zeros(num_Class,1);
sax_max_len = 15;
percent_mask = 0.25;

% readTrainData(data);
Org_Data = java.util.ArrayList;
Real_Class_Label = java.util.ArrayList;
% Org_Data = temp.fromWekaInstancesList(Train) ; 
% temp = utilities.InstanceTools ;
for i=1:size(data,1)
     Org_Data.add(data(i,:));
end


% for i=0:data.size -1
%     temp = data.get(i);
%     Org_Data.add(temp);
% end
%%  
Org_Label =java.util.ArrayList;
for  i=1: size(data,1)

    Org_Label.add(TRAIN_class_labels(i,1));

    Org_Class_Freq_new(TRAIN_class_labels(i,1))=Org_Class_Freq_new(TRAIN_class_labels(i,1))+1;
end
%%

% find the shapelet 
 node_id = 1;
 while node_id < abs(Node_Obj_List.size) || node_id == 1
    bsf_sh = Shapelet;
    if node_id == 3
        node_id = 3;
    end
    if node_id == 1     
        SetCurData(node_id);
    elseif Classify_list.get(node_id)== -1 %non-leaf node (-1:body node, -2:unused node)
        SetCurData(node_id);
    else
         node_id = node_id+1;
        continue ;
    end

    for subseq_len = min_len:step:max_len
        if subseq_len < SH_MIN_LEN
            continue ;
        end
        sax_len = sax_max_len;
         w  = floor (ceil(1.0 * subseq_len / sax_len));
         sax_len = floor(ceil(1.0 * subseq_len / w));
         CreateSAXList(subseq_len,sax_len ,w);
         RandomProjection (R,percent_mask , sax_len);
         scoreAllSAX(R);
         sh = findBestSAX(top_k);
         
         if lessThan(bsf_sh,sh)
             bsf_sh = sh ;
         end
         USAX_Map = containers.Map('KeyType','int32','ValueType','any');
         Score_List.clear;
    end

    if bsf_sh.len > 0
        query = zeros(bsf_sh.len,1);
        for i=1:bsf_sh.len

            temp = Data.get(bsf_sh.obj);
            query(i) = temp(bsf_sh.pos + i);

        end
        bsf_sh = bsf_sh.setTS(query);
        Final_Sh{Final_Sh_index,1} = bsf_sh ;
        Final_Sh_index = Final_Sh_index +1 ;
        % creat tree
        setNextNodeObj(node_id,bsf_sh);

    end
   node_id = node_id + 1;   
end

end

