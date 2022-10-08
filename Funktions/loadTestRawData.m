function tempData = loadTestRawData(idx_start ,idx_end)

 global EventWinow 
 global datafrequancy
 global rawdata
 global indextrainDataA
 global indextrainDataB
 global EventWinowSeconds
 global balance
 [indextrainDataA,indextrainDataB] =deal (1,1); 
 rawdata=[];
 format longG;
 rowDataPhaseA=[];
 rowDataPhaseB=[];
 rowDataTimeVec =[];
 names=[];
 [indexA,indexB]=deal(1,1);
 for idxRawData = idx_start:idx_end
      names=[];
     fileName = strcat('TraningData\location_001_matlab_',num2str(idxRawData),'.mat');
         if exist(fileName,'file')
       load(fileName);
    else
       error('Ohne Trainingsdatensaetze...'); 
    end
    
     rowDataPhaseA = vertcat(rowDataPhaseA ,data.Pa');
     rowDataPhaseB = vertcat(rowDataPhaseB ,data.Pb');
     rowDataTimeVec= vertcat (rowDataTimeVec, data.t_power);
         % collect the events array in the uploaded dataset file 
    if isfield(data.events,'Plugs')  == 1;  names =[names,{'Plugs'}];    end
    if isfield(data.events,'CLGT')   == 1;  names =[names,{'CLGT'}];     end      
    if isfield(data.events,'Env')    == 1;  names =[names,{'Env'}];      end
    if isfield(data.events,'Unknown')== 1;  names =[names,{'Unknown'}];  end
    for i=1:length(names)
      eventsTimeVec = eval(['data.events.',names{i},'.t'])';
      eventsphaseVec   = eval(['data.events.',names{i},'.phase'])';
      for k=1:size(eventsphaseVec,1)
         if   eventsphaseVec{k} == 'A'             
         eventsTimeVecPhaseA(indexA,1)= eventsTimeVec(k);
         indexA=indexA+1;

         
         else 
         eventsTimeVecPhaseB(indexB,1)= eventsTimeVec(k);
         indexB=indexB+1;

         end
      
      end
  end
    
 end
  rawdata.timeSriesA = timeseries(rowDataPhaseA,rowDataTimeVec);
  rawdata.timeSriesB = timeseries(rowDataPhaseB,rowDataTimeVec);
flag_event_A = 0;
flag_event_B = 0;
start_Time = datenum('24-Oct-2011 21:01:00.000');
end_Time = datenum('27-Oct-2011 14:00:00.000');
startIndex=find(abs(rowDataTimeVec(:,1 ) - start_Time) < 10^-7);
endIndex = find(abs(rowDataTimeVec(:,1 ) - end_Time) < 10^-7);
for k=startIndex(1) :60*60*datafrequancy:endIndex(1)% minute * second * frequancy * to skeep an Hour
endTime = rowDataTimeVec(k);
 for i=1:900
     startTime = endTime  ;
     endTime = addtodate(startTime,EventWinowSeconds,'second');
%       datestr(endTime)

     
     flag_left  =rowDataTimeVec >=startTime ;
     flag_right = rowDataTimeVec <endTime ;
     flag_temp = flag_right & flag_left;
     idxTime = find(flag_temp == 1)';
     if not(size(idxTime,2) == EventWinow )
         continue;
     end
     sequanceTime  =rowDataTimeVec(idxTime);
     if ~isempty (intersect(sequanceTime,eventsTimeVecPhaseA))
       addSequance('A',idxTime,0); % zero for event one for non event
       flag_event_A = 0;
     elseif isempty (intersect(sequanceTime,eventsTimeVecPhaseA)) && flag_event_A < balance
          addSequance('A',idxTime,1);
          flag_event_A = flag_event_A +1 ;
     end
     if ~isempty (intersect(sequanceTime,eventsTimeVecPhaseB))
        addSequance('B',idxTime,0);       
        flag_event_B = 0;
     elseif isempty (intersect(sequanceTime,eventsTimeVecPhaseB)) && flag_event_B < balance
          addSequance('B',idxTime,1);
          flag_event_B =flag_event_B+ 1;
    end
 end
 
end
% flag_event_A = 0;
% flag_event_B = 0;
 % simi-cross validation
% for k=60*60*datafrequancy*2:60*60*datafrequancy*3:size(rowDataTimeVec,1)% minute * second * frequancy * to skeep an Hour
% endTime = rowDataTimeVec(k);
%  for i=1:450
%      startTime = endTime  ;
%      endTime = addtodate(startTime,EventWinowSeconds,'second');
% %      datestr(endTime)
% 
%      
%      flag_left  =rowDataTimeVec >=startTime ;
%      flag_right = rowDataTimeVec <endTime ;
%      flag_temp = flag_right & flag_left;
%      idxTime = find(flag_temp == 1)';
%      if not(size(idxTime,2) == EventWinow )
%          continue;
%      end
%      
%      sequanceTime  =rowDataTimeVec(idxTime);
%      if ~isempty (intersect(sequanceTime,eventsTimeVecPhaseA))
%        addSequance('A',idxTime,0); % zero for event one for non event
%        flag_event_A = 0;
%      elseif isempty (intersect(sequanceTime,eventsTimeVecPhaseA)) && flag_event_A < 4
%           addSequance('A',idxTime,1);
%           flag_event_A = flag_event_A +1 ;
%      end
%      if ~isempty (intersect(sequanceTime,eventsTimeVecPhaseB))
%         addSequance('B',idxTime,0);       
%         flag_event_B = 0;
%      elseif isempty (intersect(sequanceTime,eventsTimeVecPhaseB)) && flag_event_B < 4
%           addSequance('B',idxTime,1);
%           flag_event_B =flag_event_B +1 ;
%     end
%      end
%  
% end


         
% mix the Events and the non-event with euch other
%         rawData.trainDataA (:,2)=num2cell (rawData.trainLabelA);
%         rawData.trainDataA= rawData.trainDataA(randperm(size(rawData.trainDataA,1)),:);
%         rawData.trainLabelA =cell2mat (rawData.trainDataA(:,2));
%         rawData.trainDataA(:,2)= []; 
        tempData.trainDataA = rawdata.trainDataA ;
        tempData.trainLabelA =rawdata.trainLabelA;


%         rawData.trainDataB (:,2)=num2cell (rawData.trainLabelB);
%         rawData.trainDataB= rawData.trainDataB(randperm(size(rawData.trainDataB,1)),:);
%         rawData.trainLabelB =cell2mat (rawData.trainDataB(:,2));
%         rawData.trainDataB(:,2)= []; 
        tempData.trainDataB = rawdata.trainDataB ;
        tempData.trainLabelB =rawdata.trainLabelB;
%      fprintf('number of overlapped events : %f\n', NummOfOverlapEvents);
    
 end



