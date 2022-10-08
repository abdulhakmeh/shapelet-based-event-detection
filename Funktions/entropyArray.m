function val = entropyArray(A,total)
% function still in doubt  in Mueen's paper

global num_Class;


[en,a] = deal(0);
for i=1:num_Class
    a =double( A(i) / total) ; 
    if a > 0 
        en =  en - (a * log(a)) ;
    end
end
val  =en;






end

