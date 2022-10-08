function val = calcInfoGain2(c_in,c_out,total_c_in, total_c_out)
%CALCINFOGAIN2 Summary of this function goes here
%   Detailed explanation goes here
global class_entropy
global total_c_in
global num_obj



val  = class_entropy - ((total_c_in /num_obj) * entropyArray(c_in, total_c_in) + (total_c_out / num_obj) * entropyArray(c_out, total_c_out));




end

