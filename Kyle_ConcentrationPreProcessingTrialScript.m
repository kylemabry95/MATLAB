%% This is a script that plays around with the data saved by the OdorConcentrationExpt script. -KJM 11/21/19
clear all; clc; close all; 

load('/Users/kmabry/Downloads/OdorConcentrationExp_583.mat')


for NumExperiments = 1:length(expStructure)
TrialNumber{NumExperiments,1} = NumExperiments;
   ValveNumber{NumExperiments,1} = expStructure{NumExperiments,1}.valve;
   OdorName{NumExperiments,1} = expStructure{NumExperiments,1}.odorName;
   ConditionID{NumExperiments,1} = expStructure{NumExperiments,1}.condID;
   Question1Resp{NumExperiments,1} = expStructure{NumExperiments,1}.q1.resp
   Question1RespTime{NumExperiments,1} = expStructure{NumExperiments,1}.q1.rt
   Question1RespCorrect{NumExperiments,1} = expStructure{NumExperiments,1}.q1.correct
   Question2Resp{NumExperiments,1} = expStructure{NumExperiments,1}.q2.resp
   Question2RespTime{NumExperiments,1} = expStructure{NumExperiments,1}.q2.rt
   if length(expStructure{NumExperiments,1}.q2) == 3 %Since some questions don't assign a correct/not correct value. 
   Question2RespCorrect{NumExperiments,1} = expStructure{NumExperiments,1}.q2.correct
   end
end

 %Title Names
Valve = {'Valve Number'};
Odor = {'Odor Name'};
Trial = {'Trial Number'};
Condition = {'Condition ID'};
Question1Response = {'Q1Resp'};
Question1ResponseTime = {'Q1RespTime'};
Question1ResponseCorrect = {'Q1Correct?'};
Question2Response = {'Q2Resp'};
Question2ResponseTime = {'Q2RespTime'};
Question2ResponseCorrect = {'Q2Correct?'};

filename = 'testdata.xlsx';
%Titles 
writecell(Trial,filename,'Sheet',1,'Range','A1')
writecell(Odor,filename,'Sheet',1,'Range','B1')
writecell(Valve,filename,'Sheet',1,'Range','C1')
writecell(Condition,filename,'Sheet',1,'Range','D1')
writecell(Question1Response,filename,'Sheet',1,'Range','E1')
writecell(Question1ResponseTime,filename,'Sheet',1,'Range','F1')
writecell(Question1ResponseCorrect,filename,'Sheet',1,'Range','G1')
writecell(Question2Response,filename,'Sheet',1,'Range','H1')
writecell(Question2ResponseTime,filename,'Sheet',1,'Range','I1')
writecell(Question2ResponseCorrect,filename,'Sheet',1,'Range','J1')
%Data 
writecell(TrialNumber,filename,'Sheet',1,'Range','A2')
writecell(OdorName,filename,'Sheet',1,'Range','B2')
writecell(ValveNumber,filename,'Sheet',1,'Range','C2')
writecell(ConditionID,filename,'Sheet',1,'Range','D2')
writecell(Question1Resp,filename,'Sheet',1,'Range','E2')
writecell(Question1RespTime,filename,'Sheet',1,'Range','F2')
writecell(Question1RespCorrect,filename,'Sheet',1,'Range','G2')
writecell(Question2Resp,filename,'Sheet',1,'Range','H2')
writecell(Question2RespTime,filename,'Sheet',1,'Range','I2')
 if length(expStructure{NumExperiments,1}.q2) == 3 %Since some questions don't assign a correct/not correct value. 
writecell(Question2RespCorrect,filename,'Sheet',1,'Range','J2')
 end


