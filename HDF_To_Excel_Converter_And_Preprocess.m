%% Last edit made by Kyle Mabry on 8/4/2020
% This is a script that takes HDF formatted experimental data and converts
% it into a data type that's understandable by MATLAB. This code also does some preliminary pre-processing of the data
% by totaling the number of trials, correct vs. incorrect responces etc...
% for each behavorial testing session of the given mouse. 
% To run this code place all of the individual HDF training files for one mouse into the same
% folder. The code will ask you to confirm that you're in the correct directory. 
% Each individual training session will be saved, and a "Master" spreadsheet
% will be produced at the end, including totals for each training session.
% Additionally, the date of the origional behavorial testing session is
% indicated under each session's summary for convenience. 
% Runtime should be approx 30-45 seconds, depending on the number of files
% you're processing. 

%% Setting up the outer for loop. 
clear all;
clc;

myDir = uigetdir; % Allows the user to get their directory of choice.
Mouse_Number = input("What is this mouse's number?: ",'s');
myFiles = dir(fullfile(myDir,'*.h5'));  %gets all .h5 files in a struct. 
Counter = 1; % Initialize a counter to use later on. 
% For each HDF file in the directory. 
for current_file = 1:length(myFiles) 
    baseFileName = myFiles(current_file).name;
    fullFileName = fullfile(baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);  % Print to the console which file we're currently looking at. 
    Data =  h5read(fullFileName,'/Trials');  % This is what actually converts HDF to MATLAB. 
    %Determine the number of trials in this experiment in order to get the sniff data later on.
    NumTrials = length(Data.trialNumber);
    
    %%  Take the behavorial data for this session and output it to it's own .csv file.
    % Get the animal's response time in miliseconds by subtracting their first lick by the odor valve onset.
    % for each tiral in the experiment.
    
    behavorialResponseArray(1:15, 1:NumTrials) = "Empty";     % Initialize behavorial respone array.
    
    for Trials = 1:NumTrials
        % response time is equal to the time of the first lick minus the time
        % of the odor valve onset.
        responseTime = (Data.first_lick(Trials) - Data.final_valve_onset(Trials));
        % if the response time is negative then just set it equal to zero.
        if responseTime < 0
            responseTime = 0;
        end
        % save the response time into a string array.
        behavorialResponseArray(1,Trials) = "Trial number:  " + Trials;
        behavorialResponseArray(2,Trials) = "Response Time (ms)";
        behavorialResponseArray(3,Trials) = responseTime;
    end
    
    % Initialize behavorial response arrays that tally the total number of
    % responses of each type to be output into the final excel sheet later on.
    LeftHitCounter = 0;
    RightHitCounter = 0;
    LeftMissCounter = 0;
    RightMissCounter = 0;
    LeftNoResponseCounter = 0;
    RightNoResponseCounter = 0;
    % Label the response types. 
    behavorialResponseArray(8, 2) = "Left hit";
    behavorialResponseArray(9, 2) = "Right hit";
    behavorialResponseArray(10, 2) = "Left miss";
    behavorialResponseArray(11, 2) = "Right miss";
    behavorialResponseArray(12, 2) = "Left no response";
    behavorialResponseArray(13, 2) = "Right no response";
    % Determine whether behavior of mouse was correct for the given trial.
    % 1 = left hit -- 2 = right hit -- 3 = left miss -- 4 = right miss
    % 5 = Left no response -- 6 = Right no response
    for Trials = 1:NumTrials
        % Get the animal's response for this trial.
        mouseResponse = Data.response(Trials);
        % Label which trial this is.
        behavorialResponseArray(4, Trials) = "Mouse's behavior";
        % Save the numerical result of this mouses' behavorial for the trial.
        behavorialResponseArray(5, Trials) = mouseResponse;
        % Translate the animals response for the trial.
        if mouseResponse == 1
            behavorialResponseArray(6, Trials) = "Left hit";
            LeftHitCounter = LeftHitCounter + 1;
            behavorialResponseArray(8, 1) = LeftHitCounter;
        elseif mouseResponse == 2
            behavorialResponseArray(6, Trials) = "Right hit";
            RightHitCounter = RightHitCounter + 1;
            behavorialResponseArray(9, 1) = RightHitCounter;
        elseif mouseResponse == 3
            behavorialResponseArray(6, Trials) = "Left miss";
            LeftMissCounter = LeftMissCounter + 1;
            behavorialResponseArray(10, 1) = LeftMissCounter;
        elseif mouseResponse == 4
            behavorialResponseArray(6, Trials) = "Right miss";
            RightMissCounter = RightMissCounter + 1;
            behavorialResponseArray(11, 1) = RightMissCounter;
        elseif mouseResponse == 5
            behavorialResponseArray(6, Trials) = "Left no response";
            LeftNoResponseCounter = LeftNoResponseCounter + 1;
            behavorialResponseArray(12, 1) = LeftNoResponseCounter;
        elseif mouseResponse == 6
            behavorialResponseArray(6, Trials) = "Right no response";
            RightNoResponseCounter = RightNoResponseCounter + 1;
            behavorialResponseArray(13, 1) = RightNoResponseCounter;
        end
    end
    
    % Also indicate the total number of trials and date for this training session.
    behavorialResponseArray(15, 1) = NumTrials;
    behavorialResponseArray(15, 2) = 'Total number of trials';
    
    % save the response time data and the behavorial response data for this specific behavorial training session to it's own excel file.
    File_Without_h5 = split(fullFileName, ".");
    File_Without_h5 = File_Without_h5(1);
    writematrix(behavorialResponseArray, ("Interpreted_Data_" + convertCharsToStrings(File_Without_h5)), 'FileType', 'spreadsheet');
    
    % If data in the preprocessed section doesn't exist, set it equal to
    % zero. This will help us when saving to the master.csv later. 
    Counter2 = 8;
    for finalData = behavorialResponseArray(8:15)
        if finalData == "Empty"
            behavorialResponseArray(Counter2) = 0;
        end
        Counter2 = Counter2 + 1;
    end
    
    % Get the date of the training session from the file name, and put it into position (10, Counter + 1) 
    Training_Date = split(File_Without_h5, "D");
    Training_Date_Final = Training_Date(2); 
    Master_Data(10, Counter + 1) = cellstr(Training_Date_Final);
    
    % Create the master data for this iteration
    Master_Data(1:8, Counter + 1) = num2cell(behavorialResponseArray(8:15, 1));
    % Place the behavorial response types + total and date, in the excel sheet for convenience.
    Master_Data(1, 1) = cellstr("Left_hit"); 
    Master_Data(2,1) = cellstr("Right_hit");
    Master_Data(3,1) = cellstr("Left_miss");
    Master_Data(4,1) = cellstr("Right_miss");
    Master_Data(5,1) = cellstr("Left_no_response");
    Master_Data(6,1) = cellstr("Right_no_response");
    Master_Data(7,1) = cellstr("_");
    Master_Data(8,1) = cellstr("Total_number_of_trials");
    Master_Data(9,1) = cellstr("_");
    Master_Data(10,1) = cellstr("Behavorial_Training_Date_and_Time");
    
    % Update the master spreadsheet for all of the data files.
    if Counter == 1  % If this is the first iteration, create the excel file.
        writematrix(behavorialResponseArray(1:10, 1), "Master_Sheet_Mouse_" + convertCharsToStrings(Mouse_Number), 'FileType', 'spreadsheet');
    else  % Otherwise, write to the excel file that we've already created.
        writecell(Master_Data(1:10, 1:Counter), "Master_Sheet_Mouse_" + convertCharsToStrings(Mouse_Number), 'FileType', 'spreadsheet');
    end
    
    
    % Increment the counter.
    Counter = Counter + 1;
    % Clear out the behavorialResponseArray for the next iteration.
    behavorialResponseArray(1:15, 1:NumTrials) = 0;
end

% Print some instructions to the consule after running everything. 
disp(" "); 
disp("Check the 'Master_Sheet_Mouse_(mouse's number you're looking at)' excel");
disp("file for the aggregated results accross all of the testing sessions.");
disp(" ");

