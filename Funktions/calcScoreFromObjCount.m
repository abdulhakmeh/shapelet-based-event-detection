function val = calcScoreFromObjCount(c_in,c_out)
%Score each sax in the matrix
global num_Class
[diff,sum]=deal(0);
max_val   = -inf;
min_val   = +inf;
for i=1:num_Class
    diff = (c_in(i)- c_out(i));
    if diff > max_val 
        max_val = diff ;
    end
    if diff < min_val
       min_val  = diff;
    end
    sum = sum + abs(diff);
    
end

val  = sum - abs(max_val) - abs(min_val) + abs(max_val - min_val);



end

