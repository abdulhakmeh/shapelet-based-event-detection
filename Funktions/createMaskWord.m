function val = createMaskWord(num_mask,word_len)

%   Detailed explanation goes here
a=0;
for i=1:num_mask
    b = bitshift(1,randi([0 word_len]));
    a = bitor(a,b);
    val = a;


end

