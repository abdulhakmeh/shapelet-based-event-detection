function val = distance(Q, order, T,j,m,mean, std,best_so_far  )
%SA Summary of this function goes here
%   Detailed explanation goes here
 if exist('best_so_far','var'); best_so_far = realmax;end
[i,sum] = deal(1);
sum= 0;
bsf2= best_so_far * best_so_far;

while i <= m && sum < bsf2
    
    x    =(T(order(i)+j-1)- mean) / std ;
    sum  = sum + (x- Q(i)) * (x- Q(i));
  
    i = i + 1 ;
end

    val = sqrt(sum);



end

