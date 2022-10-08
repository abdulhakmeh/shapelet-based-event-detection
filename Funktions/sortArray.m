function val=  sortArray(p1,p2)
%SORT Summary of this function goes here
%   Detailed explanation goes here
x =p1.value;
y = p2.value;

val= abs(int32(fix(y))) - abs(int32(fix(x)));
end

