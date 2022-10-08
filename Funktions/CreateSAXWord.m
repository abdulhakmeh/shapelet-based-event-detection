function word = CreateSAXWord( sum_segment, elm_segment, mean, std, sax_len )
%REDUCETOSAX Reduce a time series to its Symbolic Aggregate approXimation
%representation.
%   SAX allows a time series of arbitrary length n to be reduced to a
%   string of arbitrary length w, (w < n, typically w << n). The alphabet
[word,val, d] =deal( 0);
for i=1:sax_len
     d = (sum_segment(i) / elm_segment(i) - mean) / std;
     if d < 0 
        if d < -0.67
            val = 0;
        else val = 1; 
        end
     elseif d < 0.67
             val= 2;
     else val = 3;
     end
     word = bitor(bitshift(word,2),val);
end


end