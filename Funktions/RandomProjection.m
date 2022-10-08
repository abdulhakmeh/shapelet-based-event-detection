function RandomProjection(R, percent_mask, sax_len)
%Count the number of occurrences
global USAX_Map
global USAX_Map_Index
Hash_Mark =containers.Map('KeyType','int32','ValueType','any');
% [word, mask_word, new_word ] = deal (0);
 ptr = java.util.HashSet;
num_mask =  ceil(percent_mask * sax_len); 
for r=1:R
     mask_word = createMaskWord(num_mask, sax_len);
%     random projection and mark non-duplicate object
    for i=1:size(USAX_Map_Index,1)
              
        word    = USAX_Map_Index(i);
        obj_set = USAX_Map(word).obj_set ; 
       %put the new word and set combo in the hash_mark
        new_word = bitor(word,mask_word);
        if ~Hash_Mark.isKey(new_word)
           Hash_Mark(new_word)=obj_set; 
        else
%            update into ptr
           ptr =  Hash_Mark(new_word);
           ptr.addAll(obj_set);
           ptr.addAll(Hash_Mark(new_word));

        end       
     end

% hash again for keep the count
      for i=1:size(USAX_Map_Index,1)
         word    = USAX_Map_Index(i);         
         new_word = bitor(word,mask_word);
         obj_set = Hash_Mark(new_word);
         temp = obj_set.iterator;
         o_itArray=[];
         for k=1:obj_set.size             
             o_itArray(k) = temp.next;
         end
  
         for ii=1:obj_set.size
             o_it = o_itArray(ii);
             if  USAX_Map(word).obj_count.isKey(o_it)
                 count = USAX_Map(word).obj_count(o_it);
                 count = count + 1 ;
                 
             else
                 count = 1 ;
             end
             temp  = USAX_Map(word);

             temp.obj_count(o_it) = count ; 
             
             USAX_Map(word)= temp ;
         
         end
         
     end
      Hash_Mark =containers.Map('KeyType','int32','ValueType','any');
end



end

