function SetCurData(node_id)
%Set variables for next node. They are Data, Label, Class_Freq, num_obj
global Org_Class_Freq_new
global Data
global Org_Data

global Class_Freq
global Node_Obj_List
global  num_Class
global class_entropy
global Label
global num_obj
global Org_Label

%% create Data array without Label

if node_id == 1
    for i=0:Org_Label.size -1
        Label.add(Org_Label.get(i));
        Data.add(Org_Data.get(i));
    end
    Class_Freq = Org_Class_Freq_new;

else
    Data.clear;
    Label.clear;

    it = Node_Obj_List.get(node_id);
    num_obj = it.size;

    for i=1:num_Class
        Class_Freq(i,1)=0;

    end

    % build  data structures based on the node and the labels 
   temp = toArray( Node_Obj_List.get( node_id));
  
    for in=1:size(temp,1)
        cur_class = Org_Label.get(temp(in));
        Data.add(Org_Data.get(temp(in)));
        Label.add(cur_class);
        Class_Freq(cur_class,1)  = Class_Freq(cur_class,1)+1;
    end
            
 end
       class_entropy = entropyArray(Class_Freq, num_obj);


fprintf('\n== Node  %5d == \n', node_id);

end

