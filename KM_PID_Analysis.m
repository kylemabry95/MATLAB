%% Setup - Last edit made by KJM 12/19/2019

function KM_PID_Analysis()

close all;
clear all;
clc;

global odorName;

cd('/Users/kmabry/Documents/MATLAB/Kyle2019/Pid_Pei'); %Update this to your current directory where odor information is stored. 
% cd('/Users/kmabry/Desktop')
% cd('/Users/kmabry/Google Drive/Matlab_Scripts/Naz/Kyle/LabChart Data');
odorName = input('Which odor are we analyzing?     ','s');
odorFile = input('please input the file name of the odorant:    ','s');
load([odorFile '.mat']);


odor_channel = 2;  %PID recording Should be red. 
trigger_channel = 1; % Trigger Channel should be blue on figure(2)

Signal_duration = 2500;   % The length of the recording in ms. 
skip_figs = 1;  %Will skip the debugging figures: 1,2 and 4. 
SEMSkip = 0; %Will skip plotting the SEM on the last figure if set to one. 

%% set data ranges 
%The trigger datastart numbers refer to the Channel numbers on the PID/LabChart software
Column = 1;  %Set to 1 usually, but if we changed something while recording with LabChart there might be more than 1 start/end times and we'll need to look into the next column over for our actual data.
odor = data(datastart(odor_channel,Column):dataend(odor_channel,Column));
trigger = data(datastart(trigger_channel,Column):dataend(trigger_channel,Column));

%% Plot the raw odor and trigger data. 
if skip_figs ~=1
 figure(1);
 plot(odor,'r');
 hold on;
 title({'odor before filtering (raw data)' num2str(odorName)});
 plot(trigger,'b');
 hold off;
end


%% Find the start time of each of the triggers. 
Trigger_Counter = 1;
 for TriggerStartTimes = 2:length(trigger)
     if trigger(TriggerStartTimes) > .2 && trigger(TriggerStartTimes -1) < .2
         trigger_time(Trigger_Counter) = TriggerStartTimes;
         Trigger_Counter = Trigger_Counter + 1; 
     end
 end
 

%% Filter the pid signal to reduce noise. 
FilterOrder = 3; % Increase this to decrease noise in the filtered signal. 
odorFiltered = medfilt1(odor,FilterOrder);   

if skip_figs ~= 1
figure(2)
plot(trigger, 'b');
hold on 
plot(odorFiltered, 'r');
title({'pid and trigger filtered' num2str(odorName)})
for w=(1:(length(trigger_time)))
    plot([trigger_time(w),trigger_time(w)],[-0.1,1.25],'m')
    hold on
end
hold off
end

%% This code generates the length of each individual PID duration. (it will be necessary later on)
counterPID = 1;
for PIDStart_i = 1:(length(trigger_time) -1)
    OdorStartTime_i(counterPID) = trigger_time(counterPID);
    OdorStopTime_i(counterPID) = trigger_time(counterPID + 1);
    counterPID = counterPID+1;
end
OdorDurations = OdorStopTime_i-OdorStartTime_i;


 %% Block off each PID by using the start of each trigger - 8/19/19 KJM
 x = round(length(trigger_time)/sqrt(length(trigger_time)),0); %Number of rows in the subplot 
 y = round(length(trigger_time)/sqrt(length(trigger_time)) +1,0); %Number of columns in the subplot. 

counterSubplot = 1;
counterPID = 1;

for PIDStart = 1:(length(trigger_time) -1)
    OdorStartTime = trigger_time(counterPID);
    OdorStopTime = trigger_time(counterPID + 1);
    
 % Section off the PID signal that we're currently looking at. 
 odorFiltered1 = odorFiltered(OdorStartTime:OdorStopTime);
 trigger1 = trigger(OdorStartTime:OdorStopTime);
 
 %normalize the specific PID signal we're looking at
triggerN = ((trigger1 - min(trigger1))/(max(trigger1)-min(trigger1)));
odorN = ((odorFiltered1 - min(odorFiltered1))/(max(odorFiltered1)-min(odorFiltered1)));

%Makes sure our index doesn't exced the number of array elements for our
%future plots. 
   if Signal_duration > length(odorN)
       o = length(odorN);
   else 
       o = Signal_duration;
   end
   
 %
  figure(3)
  hold on;
  subplot(x,y,counterSubplot);
  xx = counterSubplot + 1;  %We need a seperate counter to get the next trigger start time, which defines the end of the current pid. 
   n = 1;
  plot(odorN(n:(o)));
   title({[ 'PID Signal #', sprintf('%d',counterSubplot)] num2str(odorName)});  %Updates the title of each subplot. 
%

plotCounter = 1;
runCounter = 1;
for w = odorN(n:(o)) 
    if w >= 0.8 
          subplot(x,y,counterSubplot);
          hold on 
          plot_var = odorN(runCounter);
    plot([runCounter runCounter], [-0.1,1.25],'red')
    plotCounter = plotCounter + 1;
    end 
    if plotCounter > 1 
        text((plotCounter-5),1.25,[num2str(runCounter) 'ms to 80%'],'FontSize',12,'Color','red'); % Odor Travel Time. 
        break
    end
    runCounter = runCounter + 1;
end

plotCounter = 1;
runCounter = 1;
for w = odorN(n:(o)) 
    if w >= 0.9 
          subplot(x,y,counterSubplot);
          hold on 
          plot_var = odorN(runCounter);
    plot([runCounter runCounter],[-0.1,1.25],'green')
    plotCounter = plotCounter + 1;
    end 
    if plotCounter > 1 
        text((plotCounter-5),1.1,[num2str(runCounter) 'ms to 90%'],'FontSize',12,'Color','green'); % Odor Travel Time. 
        break 
    end
    runCounter = runCounter + 1;
end

if skip_figs ~= 1
figure(4)
title({'PID signals plotted individually' num2str(odorName)}) %PID signal vs valve.
hold on
xlabel('Time in milliseconds')
plot (odorN(n:(o)) ,'color',rand(1,3));
end 

odorStructure_nan{counterPID} = NaN(1,max(OdorDurations)); %Pre-forms each odorStructure array with NaN's so that the dimensions are equal and we can concatonate later on. 
odorStructure{counterPID} = odorN(n:o);
triggerStructure{counterPID} = triggerN(n:o);

  counterSubplot = counterSubplot + 1; 
  counterPID = counterPID + 1;
  hold off
end



%% Mean of the PID signals with average travel times for 80 and 90% onset. 
figure(5)
title({'Mean of PID signals with SEM' num2str(odorName)})
hold on
xlabel('Time in milliseconds')
dim = ndims(odorStructure{1});
Matrix = cat(dim+1,odorStructure{:});  %The dimensions of the arrays being concatenated must be consistent for this step to work.

Matrix(:,:,counterPID-1);
MeanPID = mean(Matrix,3);
plot(MeanPID,'red');  % The mean of all of the PID signals. 




% Figuring out SEM. 
StdDev = std(Matrix,1,3);  % Takes the standard deviation along the 3 dimensions of this "Matrix". 
SEM = (StdDev / sqrt (counterPID));
if SEMSkip~=1
plot((MeanPID+SEM),'black');
plot((MeanPID - SEM),'black');
end

% 90 percent line. 
plotCounter = 1;
runCounter = 1;
for w = MeanPID(1:length(MeanPID))
    if w >= 0.9 
          plot_var = odorN(runCounter);
    plot([runCounter runCounter],[-0.1,1.25],'blue')
    plotCounter = plotCounter + 1;
    end 
    if plotCounter > 1 
        text((plotCounter-5),1.25,[num2str(runCounter) 'ms to 90%'],'FontSize',12,'Color','blue'); % Odor Travel Time. 
        break 
    end
    runCounter = runCounter + 1;
end

% 80 percent line. 
plotCounter = 1;
runCounter = 1;
for w = MeanPID(1:length(MeanPID))
    if w >= 0.8
          plot_var = odorN(runCounter);
    plot([runCounter runCounter],[-0.1,1.25],'green')
    plotCounter = plotCounter + 1;
    end 
    if plotCounter > 1 
        text((plotCounter-5),1.1,[num2str(runCounter) 'ms to 80%'],'FontSize',12,'Color','green'); % Odor Travel Time. 
        break 
    end
    runCounter = runCounter + 1;
end

hold off;
legend('Mean of all PIDs','SEM');


%% How do people define the steady state of a odor signal? Look this up in the literature. 
figure(9)
hold on 
title('derivative of MeanPID Signal');
FilterOrder3 = 8; % Increase this to decrease noise in the filtered signal. 

yy = diff(MeanPID);
yyFiltered = medfilt1(yy,FilterOrder3);   
plot(yyFiltered) 
hold off;

end
