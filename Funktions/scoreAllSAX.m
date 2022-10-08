function scoreAllSAX(R)
global USAX_Map
global Score_List
global USAX_Map_Index

% Score each SAX
[word, score]=deal (0);
usax =  USAX_elm_type;
temp = tsc_algorithms.PairT;

for i=1:size(USAX_Map_Index,1)
    
    word  = USAX_Map_Index(i);
    
%     if word == 787195
%         p=0;
%     end
    usax  = USAX_Map(word);
    score = calcScore(usax,R);
    temp = tsc_algorithms.PairT;
    temp.first = word;
    temp.second = score;
    Score_List.add(temp);
end









end

