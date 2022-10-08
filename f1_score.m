function F1_score= f1_score(number) 
% this is extra function to calc. F1-score \ Matthews correlation coefficient  \ recall \ 

fileName = strcat('result faktor',num2str(number),'.txt');
temp=textread(fileName,'%s','delimiter','\n');
indxp1=find(~cellfun(@isempty,strfind(temp,'p  2')));
indxp2=find(~cellfun(@isempty,strfind(temp,'p  1')));
tmep = regexp(temp(indxp1,1),'\d+\.?\d*','match');
TN = str2double (tmep{1,1}(1,2));
FN = str2double (tmep{1,1}(1,3));
tmep = regexp(temp(indxp2,1),'\d+\.?\d*','match');

FP = str2double(tmep{1,1}(1,2));
TP = str2double(tmep{1,1}(1,3));
TruePositiverate = TP / (TP +FN);
fasepositiverate = FP / (FP +TN);
precision = TP /(TP + FP);
recall =  TP / (TP + FN); 
MCC = ((TP *TN) -(FP *FN)) / sqrt((TP+FP)*(TP-FN)*(TN+FP)*(TN+FN));
F1_score = 2 * ((precision * recall) / (precision + recall)) ;
 







end

