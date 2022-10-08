 function addEvent(eventPhase,eventIndexVec,eventStatus)
 global indextrainDataA
 global indextrainDataB
 global rawdata
 
    if isequal (eventPhase,'A') 
        rawdata.trainDataA{indextrainDataA,1}= rawdata.tempPA(eventIndexVec);
        rawdata.trainLabelA(indextrainDataA,1)   = eventStatus;
        indextrainDataA=indextrainDataA+1;
    else 
        rawdata.trainDataB{indextrainDataB,1}= rawdata.tempPB(eventIndexVec);
        rawdata.trainLabelB(indextrainDataB,1)   = eventStatus;
        indextrainDataB=indextrainDataB+1;

   end
 
 
 end