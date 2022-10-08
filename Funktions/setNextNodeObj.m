function setNextNodeObj(node_id, sh)
%SETNEXTNODEOBJ Summary of this function goes here
%   Detailed explanation goes here
global Node_Obj_List;
global Classify_list ;
global Final_Sh ;
global num_obj
global nn
global num_Class
global MIN_PERCENT_OBJ_SPLIT
global MAX_PURITY_SPLIT
global EXTRA_TREE_DEPTH
global Final_Sh_index
global Data
global order
global Q

q_obj   = sh.obj;
q_pos   = sh.pos;
q_len   = sh.len;
dist_th = sh.dist_th ;
query   = zeros (q_len,1);
left_node_id = node_id * 2;
right_node_id = (node_id * 2 )+ 1;
[real_obj,left_num_obj, right_num_obj] = deal(0);
while Node_Obj_List.size <=  right_node_id
    temp = java.util.ArrayList;
    Node_Obj_List.add(temp);
    Classify_list.add(-2);
    temp =Shapelet; 
    Final_Sh {Final_Sh_index,1}= temp;
    Final_Sh_index = Final_Sh_index+1;
    if Node_Obj_List.size == 2  % node_obj_ list at 0 is not used 
        for i=1:num_obj
         Node_Obj_List.get(1).add(i-1) ; 
        end
        
    end
end
Final_Sh{node_id +1,1} =sh ;

% Use the shapelet on previous Data
 for i = 1:q_len
     temp = Data.get(q_obj);
    query(i) = temp(q_pos + i);
 end
 dist = 0;
 m = size(query,1);
 Q = zeros(m,1);
 order = zeros(m,1);
 for obj=0:num_obj-1
     dist = nearestNeighborSearch (query , Data.get(obj), obj);
     if dist <= dist_th
         left_num_obj = left_num_obj +1;
         next_level(obj+1)=1;
         temp = Node_Obj_List.get(node_id);
         real_obj = temp.get(obj);
         Node_Obj_List.get(left_node_id).add(real_obj);
     else
         right_num_obj = right_num_obj +1 ;
         next_level(obj+1) = 2 ;
         temp = Node_Obj_List.get(node_id);
         real_obj = temp.get(obj);
         Node_Obj_List.get(right_node_id).add(real_obj);
     end
    
%      real_obj = Node_Obj_List.get(node_id).get(obj);
%      if dist <= dist_th; node =left_node_id; else, node = right_node_id; end 
%      Node_Obj_List.get(node).add(real_obj);
 end
 Q = zeros(m,1);
 order = zeros(m,1);
%  if left/right is pure, or so small, stop spliting
 [max_c_in, max_c_out, max_ind_c_in ,max_ind_c_out] = deal(-1);
 [sum_c_in,sum_c_out]  = deal(0);
 for i=1:size(sh.c_in,1)
     

     sum_c_in = sum_c_in + sh.c_in(i); 
     if max_c_in < sh.c_in(i)
         
         max_c_in = sh.c_in(i);
         max_ind_c_in  = i-1 ;
     end
     
     sum_c_out = sum_c_out + sh.c_out(i);
     if max_c_out < sh.c_out(i) 
         max_c_out =  sh.c_out(i);
         max_ind_c_out = i-1 ;         
     end
 end
     
     left_is_leaf = false; 
     right_is_leaf = false;
     MIN_OBJ_SPLIT = ceil(double(MIN_PERCENT_OBJ_SPLIT * num_obj) / double(num_Class));
     
     if sum_c_in <= MIN_OBJ_SPLIT || double(max_c_in / sum_c_in) >= MAX_PURITY_SPLIT
        left_is_leaf = true;
     end
     if sum_c_out <= MIN_OBJ_SPLIT || double(max_c_out / sum_c_out) >= MAX_PURITY_SPLIT
         right_is_leaf = true ;
     end
     
     max_tree_dept = floor (EXTRA_TREE_DEPTH + ceil(log(num_Class) / log(2)));
     if node_id >= power(2,max_tree_dept)
            left_is_leaf = true;
            right_is_leaf = true; 
     end
        Classify_list.set( node_id ,-1 );
        
        if left_is_leaf; val = max_ind_c_in ;   else, val = -1 ;end
        Classify_list.set(left_node_id,val);
        
        if right_is_leaf; val = max_ind_c_out ; else, val = -1 ;end
        Classify_list.set (right_node_id,val);
        

 end
 
    
    


