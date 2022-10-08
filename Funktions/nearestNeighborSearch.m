function val = nearestNeighborSearch(query,data,obj_id)
global order
global Q
global min_len
    [i,j,ex,ex2,mean,std,loc,dist]=deal(0);
     m = length(query);
     M = size(data,1);
     bsf = Inf;

     if obj_id == 0 
         for i=1:m
             d  = query(i);
             ex = ex + d;
             ex2= ex2 + (d*d);
             Q(i) = d;
         end
         mean = ex / m ; 
         std  = ex2 /m ;
         std = sqrt(std - (mean * mean));
         for i=1:m
             Q(i)=(Q(i)- mean) /std ; 
         end
         Q_temp = Index;
         for i=1:m
             Q_temp(i).value = Q(i);
             Q_temp(i).index = i;
         end



%               for k=1:size(Q_temp,2)  
%                  for i=1:size(Q_temp,2)-1
% 
%                      if sortArray(Q_temp(i),Q_temp(i+1)) < 0
% 
%                          temp = Q_temp(i+1);                          
%                          Q_temp(i+1)= Q_temp(i);
%                          Q_temp(i)= temp;
%                         
%                      end
%                  end
%                end


         %%sorting
          i=1;
        while i < min_len
             if sortArray(Q_temp(i),Q_temp(i+1)) > 0
                 temp =Q_temp(i+1);
                 Q_temp(i+1)=Q_temp(i);
                 Q_temp(i)=temp;
                 i=1;
             else
                 i=i+1;
             end
        end
            
      
              for i=1:m
                 Q(i)=Q_temp(i).value;
                 order(i)=Q_temp(i).index;
              end
    
      end
             [ex,ex2]=deal(0);
             [j,i] = deal(1);
             T = zeros(2 * m,1);
             while (i <= M )
                 d = data(i);
                 ex = ex + d;
                 ex2 = ex2 + d * d;
                 T(i)= d ;
                 T(i+ m)= d;
                 if i >= m 
                     mean = ex /m ;
                     std  = ex2 / m;
                     std = sqrt(std - mean * mean);
                     j   = i - m+1 ;
                     dist= distance(Q ,order, T,j,m,mean,std,bsf);
                     if dist < bsf
                         bsf = dist ;
                         loc =i - m + 1 ;
                     end
                     ex = ex - T(j);
                     ex2 =ex2- T(j)* T(j);
                 end
                 i= i+1;
             end
             val= bsf;        
                      

end 
 


