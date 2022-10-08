%%  Development in Project: "Evaluating the Impact of Data Sampling Rates on Event Detection Accuracy in Load Signatures Using a Shapelet based Approach"
%   Informatik Institute, TU-Clausthal
%   Abdul Hakmeh
%   Email: ahak15@tu-clausthal.de
%   E. K. Thanawin Rakthanmanon code [Source code].http://alumni.cs.ucr.edu/~rakthant/FastShapelet/
%%

addpath('TraningData');
addpath('Funktions');
% clear workspace 
clear all;  
clearvars ;
clc;
close all;
%% import java library 


javaaddpath('\javaDependency\weka-3.7.0.jar');
javaaddpath('\javaDependency\utilities-50.jar');
javaaddpath('\javaDependency\utilities-30p.jar');

import weka.classifiers.Classifier;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Random;
import weka.core.Capabilities;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.DenseInstance;
import utilities.InstanceTools;
import tsc_algorithms.FastShapelets;
import  tsc_algorithms.PairT;
% javaaddpath  % Add entries to dynamic Java class path.
% javarmpath  % Remove entries from dynamic Java class path
% clear java  % Removes all variables, functions, MEX-files, and dynamic Java class definitions from memory, leaving the workspace empty.




global Data
global EventWinow
global datafrequancy
global downsampling_faktor
global Call_optimization
global EventWinowSeconds
global samplingNumber
global balance
%% main prameter 

Call_optimization = 0;
downsampling_faktor= 1 ;
datafrequancy = 60;% frequancy in Hz (downsampling rate)
EventWinowSeconds = 4 ; % event window in second (inc. 1 Sec befor the event)
EventWinow = EventWinowSeconds * datafrequancy;
% samplingNumber = 800 ; 
balance = 2 ; % ratio of event:non_event

%%  declaration of some veriabels
rawData.trainDataB=[];
rawData.trainLabelB=[];
rawData.trainDataA=[];
rawData.trainLabelA=[];
rawData.validationDataA=[];
rawData.validationLabelA=[];
rawData.validationDataB=[];
rawData.validationLabelB=[];

if exist('rawData.mat','file') % load the data for one time
       load('rawData.mat');
else

%   loading the data every 1 day is 4 files
    tempData = loadRawDataTrain(1,40);    
    
    rawData.trainDataA = vertcat (rawData.trainDataA,tempData.trainDataA) ;
    rawData.trainLabelA= vertcat(rawData.trainLabelA,tempData.trainLabelA); 
    rawData.trainDataB= vertcat ( rawData.trainDataB,tempData.trainDataB) ;
    rawData.trainLabelB=vertcat( rawData.trainLabelB,tempData.trainLabelB);
   

 %  loading the data (validation data) every 1 day is 4 files
    tempData = loadTestRawData(40,65); 

    rawData.validationDataA = vertcat (rawData.validationDataA,tempData.trainDataA) ;
    rawData.validationLabelA= vertcat(rawData.validationLabelA,tempData.trainLabelA);
    rawData.validationDataB= vertcat ( rawData.validationDataB,tempData.trainDataB) ;
    rawData.validationLabelB=vertcat( rawData.validationLabelB,tempData.trainLabelB);
%     
    save('rawData.mat','rawData'); %save the data locally
end 
%% main function 

shapeletsearch(rawData);



function shapeletsearch(rawData)
global Data

global TRAIN;
global TEST;
global Node_Obj_List
global TRAIN_class_labels
global TEST_class_labels
global Label
global num_Class
global Org_Class_Freq_new
global SH_MIN_LEN
global USAX_Map
global Score_List
global nn
global Classify_list
global Final_Sh
global MIN_PERCENT_OBJ_SPLIT 
global MAX_PURITY_SPLIT
global EXTRA_TREE_DEPTH
global step
global iterations_nr
global candidates_nr
global Call_optimization
global downsampling_faktor
global acc_vec

acc_vec = [];

    tmepTrain=  rawData.trainDataB;  % importdata
    for i=1:length(tmepTrain)
         TRAIN(i,:)=tmepTrain{i};
    end
    
    tempTest= rawData.validationDataB; %importdata(['daten/',name,'/',name,'_TEST'])
    for i=1:length(tempTest)
         TEST(i,:)=tempTest{i};
    end

TRAIN_class_labels = rawData.trainLabelB +1 ;     % Pull out the class labels.                
TEST_class_labels = rawData.validationLabelB +1;      


% Shapelet parameters

iterations_nr = 10 ;
candidates_nr = 10;
step = 10;
EXTRA_TREE_DEPTH = 2;
MIN_PERCENT_OBJ_SPLIT = 0.1;
MAX_PURITY_SPLIT = 0.90;
SH_MIN_LEN = 5; % minimal lengthe of shapelet 
Classify_list = java.util.ArrayList;
Data = java.util.ArrayList;
Label = java.util.ArrayList;
Score_List = java.util.ArrayList;
Final_Sh = {};
nn = NN_ED;
USAX_Map   = containers.Map('KeyType','int32','ValueType','any');

%% Hypo parameter optimization
  if Call_optimization==1 
      parameterOptimVars = [
                       
                    optimizableVariable('downsampling_faktor',[5 8],'Type', 'integer')];
                        
  
                       bayesopt(@CallShapeletSearch,parameterOptimVars,...
                                    'MaxTime',10*60*60,...
                                    'AcquisitionFunctionName','expected-improvement-per-second-plus',...
                                    'ExplorationRatio',0.2,...
                                    'IsObjectiveDeterministic',false,...
                                    'Verbose',1,...
                                    'NumSeedPoints',10,...
                                    'PlotFcn',@plotMinObjective,...                               
                                    'UseParallel',false); 



  
  else
      for i = 2:32
      CallShapeletSearch (i);
      end
  end
end
                                  
 


function Classify_ac = CallShapeletSearch(inputs)
global iterations_nr
global candidates_nr
global TRAIN
global TEST
global Classify_list
global Final_Sh
global Node_Obj_List
global TEST_class_labels
global num_Class
global Call_optimization
global acc_vec
global TRAIN_class_labels

% if exist(fileName,'file')
%        load(fileName,'TEST.mat');
%       
% end
    %downsampling 
 if Call_optimization == 1
     downsampling_faktor  = inputs.downsampling_faktor;
 else 
     downsampling_faktor = inputs;
 end
 if inputs > 1
     load('rawData.mat');
   for i=1:size(TRAIN,1)
       downsampled_TRAIN(i,:)=nanmean(reshape([rawData.trainDataB{i,:}(:); nan(mod(-numel(rawData.trainDataB{i,:}),downsampling_faktor),1)],downsampling_faktor,[]));
   end


   for i=1:size(TEST,1)
      downsampled_TEST(i,:)=nanmean(reshape([rawData.validationDataB{i,:}(:); nan(mod(-numel(rawData.validationDataB{i,:}),downsampling_faktor),1)],downsampling_faktor,[]));
   end    
 else 
     downsampled_TRAIN = TRAIN;
     downsampled_TEST = TEST;
 end
tStart = tic; % traning time calcu.
train(downsampled_TRAIN,iterations_nr,candidates_nr);
tTrainLocal = toc(tStart);

fileName = 'result.txt';  % create txt file locally to save results
if exist(fileName,'file')
       delete(fileName);
end


fileID = fopen(fileName,'w');
fprintf(fileID,';NodeID   class    obj   pos   len   dist_th\n');
fprintf(fileID,'TreeSize: %5d \n',Node_Obj_List.size);
% CDT parameters
for i=1:Node_Obj_List.size -1
    sh = Final_Sh{i+1};
    if Node_Obj_List.get(i).size == 0
        continue;
    end
        if Classify_list.get(i) < 0 


         fprintf(fileID,'NonL%5d  %s %5d %5d %5d %8.4f',i,"--",sh.obj,sh.pos,sh.len,sh.dist_th);
         fprintf(fileID,' ==>');
         fprintf(fileID,' %5d%5d/%5d%5d\n' ,sh.c_in(1),sh.c_in(2),sh.c_out(1),sh.c_out(2));
        else
          real_Label = Classify_list.get(i) +1;
          fprintf(fileID,'Leaf%5d%5d\n' , i,real_Label);
        end 
end
fprintf(fileID,'\n\n');
fprintf(fileID,';Shapelet    id    <data>  \n');
for i=1:Node_Obj_List.size-1
    sh = Final_Sh{i+1};
    if Node_Obj_List.get(i).size == 0
        continue;
    end
   if not(sh.gain == -Inf)
        if (Classify_list.get(i)< 0 )

          fprintf(fileID,'Shapelet%5d ' ,i);
          fprintf(fileID,' %9.6f ' ,sh.ts.');         
          fprintf(fileID,'\n');
        end
   end
end


fprintf(fileID,';Downsampling faktor  = %5d \n',downsampling_faktor);
fprintf(fileID,';traning time  = %5d \n',tTrainLocal);
fclose(fileID);
obj_numr = size(downsampled_TEST,1);
 % praper the test data for classification
writetable(array2table([TEST_class_labels downsampled_TEST]),'TEST','Delimiter',' ','WriteVariableNames',false);
movefile('TEST.txt', 'TEST'); % save the test data locally

diary('myTextLog.txt');
Classify(num_Class,obj_numr); % call the callcification func. 
diary('off');
clear Classify; % clear the memo.

% to import the acc. from the txt and print it.
temp=textread('result.txt','%s','delimiter','\n'); 
indx=find(~cellfun(@isempty,strfind(temp,'accuracy=')));
acc = regexp(temp(indx,1),'\d+\.?\d*','match');
acc =  str2double(cell2mat(acc{1,1}(1,1))) /100;
acc_vec =vertcat(acc_vec,[acc downsampling_faktor tTrainLocal]);
filename = strcat ('result faktor' , num2str(downsampling_faktor) ,'.txt');
movefile('result.txt',filename);
Classify_ac =  acc  ; 

end
