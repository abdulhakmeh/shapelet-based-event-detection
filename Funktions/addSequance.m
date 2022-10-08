function addSequance(eventPhase,eventIndexVec,eventStatus)
 global indextrainDataA
 global indextrainDataB
 global rawdata

 
    if isequal (eventPhase,'A') 
        rawdata.trainDataA{indextrainDataA,1}= rawdata.timeSriesA.getdatasamples(eventIndexVec)';
        rawdata.trainLabelA(indextrainDataA,1)   = eventStatus;
        indextrainDataA=indextrainDataA+1;
    else 
        rawdata.trainDataB{indextrainDataB,1}= rawdata.timeSriesB.getdatasamples(eventIndexVec)';
        rawdata.trainLabelB(indextrainDataB,1)   = eventStatus;
        indextrainDataB=indextrainDataB+1;

   end
 
 
 end