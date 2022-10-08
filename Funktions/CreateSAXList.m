function CreateSAXList(subseq_len,sax_len,w)
%CREATESAXLIST Summary of this function goes here
%   Detailed explanation goes here
global USAX_Map
global Data
global USAX_Map_Index
USAX_Map_Index = [];
% global USAX_Map_index
% USAX_Map_index = java.util.HashMap ; 
[ex,ex2, mean,std, series, j, j_st, k, slot,d] =deal( 0);
word =0;

sum_segment= zeros(sax_len,1);
elm_segment= zeros (sax_len,1);


for k=1:sax_len
    elm_segment(k) = w;    
end
 elm_segment(sax_len - 1) = subseq_len - (sax_len - 1) * w;

for series=0:Data.size -1
    prev_word =-1;
    [ex,ex2]=deal(0);
    sum_segment=zeros(sax_len,1); 

    
%      Case 1: Initial
    j = 0;
    while  j < size(Data.get(series),1) && j < subseq_len
        temp  = Data.get(series);
        d = temp(j+1);
        ex= ex+d;
        ex2= ex2 +d * d ;
        slot = floor(j/w );
        sum_segment(slot+1)=sum_segment(slot+1)+d;
        j =j+1;
    end
%     Case 2: Slightly Update
    for j=subseq_len : size(Data.get(series),1)
        j_st = j- subseq_len;
        mean = ex / subseq_len;
        std = sqrt(ex2 / subseq_len - mean * mean);
%         Create SAX from sum_segment
        word = CreateSAXWord(sum_segment, elm_segment, mean, std, sax_len);
        


        if ~isequal(word,prev_word)
            prev_word=word;
%              updating the reference
           if USAX_Map.isKey(word)
               ptr = USAX_Map(word);
               remove(USAX_Map,word);
           else
               ptr = USAX_elm_type;
           end
           
           ptr.obj_set.add(series); % word location in orginal data
           temp = tsc_algorithms.PairT;
           temp.first=series;
           temp.second = j_st;
           ptr.sax_id.add(temp);
           USAX_Map(word)=ptr;
           if ~ismember(word,USAX_Map_Index)
                USAX_Map_Index = vertcat(USAX_Map_Index,word);
           end
%            USAX_Map_index.put(word,word);
        end
        
        %for next update 
        if j < size(Data.get(series),1)
           temp= Data.get(series); 
           temp = temp(j_st+1);
            ex   = ex - temp;
            ex2  = ex2 - temp * temp;
            
            for k=1: sax_len -1
                temp =Data.get(series);    
                if w > 1
                    sum_segment(k) = sum_segment(k)- temp(j_st+1 + (k-1) * w);
                    sum_segment(k) = sum_segment(k)+ temp(j_st+1 + (k) * w);
                else
                sum_segment(k) = sum_segment(k)- temp(j_st + (k) * w);
                sum_segment(k) = sum_segment(k)+ temp(j_st + (k+1) * w);
                end
            end
%             temp =Data.get(series);
            sum_segment(k+1) = sum_segment(k+1) - temp(j_st + 1 + (k) * w ); 
            sum_segment(k+1) =sum_segment(k+1) + temp(j_st+1 + min((k+1) * w,subseq_len) ); 
            d   = temp(j+1);
            ex  = ex + d ;
            ex2 = ex2 + ( d  * d );    
        end
    end
end
        


end
        


