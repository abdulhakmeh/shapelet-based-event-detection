function score = calcScore(usax ,R)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global Label
global num_Class


[c_in,c_out] = deal(zeros(num_Class,1)); %Count object inside, outside hash bucket

for entry = keys(usax.obj_count)
    value = entry{1};
    cid   = Label.get(value);
    count =  usax.obj_count(value);
    c_in(cid)  =  c_in(cid)+ (count);
    c_out(cid) =  c_out(cid) +(R - count);
end
score = calcScoreFromObjCount (c_in, c_out);







end

