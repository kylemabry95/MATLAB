clc% check airflow in bottles/tubing (aiy)
clear all; clc;

debug = 1;

global deviceIndices 
deviceIndices = test_daqs; mouseInd=deviceIndices(4); KbInd=deviceIndices(5); control_daqs(deviceIndices,'config',[],'config',[]);

control_daqs(deviceIndices,[],[],'config');

% user input ** all valves that you want to test
% curr_valves=[1:5 7:11]; % conc
% curr_valves=[1:5]; % conc
% curr_valves=[1:3 7:9]; % dur
% curr_valves=[2 8]; % dur
% curr_valves=[1 7 1 7]; % val
% curr_valves=[1:3 5 7 9 11]; % Koichiro experiment 
curr_valves=[5 5 5 5 5 5 5 5 5 5 5 5 5 5 5]; % Koichiro experiment 
conditionReps = size(curr_valves,2);
disp(['Number of valves to be tested: ' num2str(conditionReps)])

if debug ~=1
odor_dur=2; %Where you change the odor duration. 
else 
    odor_dur=0;
end
totalFlow=0.2;
airLines=[6 12];
counter = 1;

for valve_ind=curr_valves
    disp(['Rep Number: ' num2str(counter)])
    disp(['valve: ' num2str(valve_ind)])
   
    if valve_ind<=min(airLines)
        flowParam=[totalFlow 0]; linesOpen=[valve_ind,12];
    else
        flowParam=[0 totalFlow]; linesOpen=[6,valve_ind];
    end
    
    control_daqs(deviceIndices,[],[],'open','open'); 
    
    control_daqs(deviceIndices,'open',linesOpen);
    control_daqs(deviceIndices,'flow',flowParam); 
    WaitSecs(odor_dur); 
    control_daqs(deviceIndices,'open',[6 12]);
    disp('air')
    
 if debug ~= 1   
    WaitSecs(2); %Changed 10/18
 end
counter = counter + 1;
end


control_daqs(deviceIndices,'flow',[0, 0]); control_daqs(deviceIndices,'close');