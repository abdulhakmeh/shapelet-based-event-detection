function shapelet = findBestSAX(top_k)
%Calculate Real Infomation Gain
%   Detailed explanation goes here
global num_obj;
global Score_List
global USAX_Map
global num_Class
global subseq_len
global  Class_Freq
global Data
global nn
global order
global Q
global Label
global class_entropy
global total_c_out
global USAX_Map_index
Score_list_Dic = [];
[ gain,dist_th,gap ,dist]=deal(0);
[ label, kk, num_diff ,q_obj, q_pos ,word]=deal(int32.empty(0,1));
total_c_in = 0 ;
usax = USAX_elm_type;
Dist = java.util.ArrayList;
    gainArray =[];  
    o=0;
for i=0:num_obj-1
    Dist.add(nan);
end
bsf_sh =Shapelet;
c_in  = zeros(num_Class,1);
c_out = zeros(num_Class,1);
query = zeros(subseq_len,1);
          %% compatr methode to put the big scond first
          if top_k > 0
          for i=0:Score_List.size -1
              Score_list_Dic(i+1,1)= Score_List.get(i).second;
              Score_list_Dic(i+1,2)= i;
              Score_list_Dic(i+1,3)= Score_List.get(i).first;
          end
             Score_list_Dic =  sortrows(Score_list_Dic,'descend');
          
          
          
%               for k=0 : Score_List.size
%                   for i=0:Score_List.size 
%                       if i== Score_List.size - 1
%                           break;
%                       end
%                      if Score_List.get(i+1).second > Score_List.get(i).second
%                         temp =Score_List.get(i);
%                         Score_List.set(i,Score_List.get(i+1));
%                         Score_List.set(i+1,temp);
%                         
%                      end
%                   end
%               end
                   
          end

top_k = abs(top_k);   
for k=0:min(Score_List.size - 1,top_k-1)
    
      temp = Score_List.get(Score_list_Dic(k+1,2));
      word =  temp.first;
      usax = USAX_Map(word);
      for kk=0: min(usax.sax_id.size -1,0)
          

          temp  =  usax.sax_id;
          q_obj = temp.get(kk).first;  % muss hier weiter gearbeitet (indexing issue ) 
          q_pos = temp.get(kk).second;
          
          for i=1:num_Class
              c_in(i)= 0;
              c_out(i) = Class_Freq(i);
          end
          for  i=1:subseq_len
              
              temp = Data.get(q_obj);
              query(i) = temp(q_pos + i);
          end
          Q = zeros (size(query,1),1);
          order = zeros (size(query,1),1);
          for obj=0:num_obj-1
              dist = nearestNeighborSearch(query,Data.get(obj),obj);
              temp = tsc_algorithms.PairT(obj,dist);
              Dist.set(obj,temp);
          end
          Q = zeros (size(query,1),1);
          order = zeros (size(query,1),1);
          
          %% compatr methode to put the big first at the end 

    
          for i=0:Dist.size -1
              Dist_dic(i+1,1)= Dist.get(i).second;
              Dist_dic(i+1,2)= i;
              Dist_dic(i+1,3)= Dist.get(i).first;
          end
             Dist_dic =  sortrows(Dist_dic,'ascend');
          
          
%           Old Algo
%               for indx=0 : Dist.size -1
%                   for i=0:Dist.size -1
%                       if i== Dist.size - 1
%                           break;
%                       end
%                     if Dist.get(i).second > Dist.get(i+1).second
%                         temp =Dist.get(i);
%                         Dist.set(i,Dist.get(i+1));
%                         Dist.set(i+1,temp);
%                         
%                     end
%                   end
%               end

         
          total_c_in = 0;        
          for  i = 1:Dist.size -1
%              pair_i = tsc_algorithms.PairT;
             pair_i = Dist.get(Dist_dic(i,2));
%              pair_ii = tsc_algorithms.PairT ;
             pair_ii = Dist.get(Dist_dic(i+1,2));
             
             dist_th = (pair_i.second + pair_ii.second)/2.0;
             gap = (pair_ii.second - dist_th)/sqrt(subseq_len);
             label =Label.get(pair_i.first);
             c_in(label) = c_in(label)+1;
             c_out(label)= c_out(label)-1;
             total_c_in = total_c_in +1;
             num_diff = abs(num_obj - 2 * total_c_in );
             total_c_out = num_obj - total_c_in;
             gain  = class_entropy - ((total_c_in /num_obj) * entropyArray(c_in, total_c_in) + (total_c_out / num_obj) * entropyArray(c_out, total_c_out));
             sh = Shapelet(gain, gap, dist_th);
            



             
             if lessThan(bsf_sh,sh)
                bsf_sh = Shapelet(gain, gap, dist_th, q_obj, q_pos, subseq_len, num_diff, c_in, c_out);
                
             end
          end
      end
end
fprintf('.');
if mod (subseq_len ,50) == 0
    fprintf('\n');
end
      shapelet=bsf_sh;
end
  