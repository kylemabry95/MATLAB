%% This code reads HDF files into matlab. 
% h5disp('example.h5','/g4/world');

NameFile= input('What is the name of the HDF5 file(include .h5?):  ','s');
Data =  h5read(NameFile,'/Trials'); 


% All_Variables = structvars(Data);
% All_Vars = convertCharsToStrings(All_Variables')
structvars(Data)
disp('copy and paste the printed variables into the command line and hit enter:  '); 

save('HDF_5DataV1') % Save the raw data. 
% Make a for loop for this so that it saves each variable. 

Variables2Save = [air_flow, block_size, final_valve_duration, final_valve_duration2, final_valve_onset, ...
    first_lick, initial_free_water_trials, inter_trial_interval, left_free_water, lick_grace_period, licking_training,...
    mouse, nitrogen_flow, odorant, odorant_trigger_phase, odorvalve, parameters_received_time, ...
    percent_correct, percent_left_correct, percent_right_correct, response, response_window, rewards, ...
    rewards_left, rewards_right, rig, right_free_water, session, tr, trial_category, trial_end, trial_start, ...
    trial_type_id, trialNumber, water_duration1, water_duration2] 

csvwrite('MyFile.csv', Variables2Save) 


% return;
% %% Stage 2 - starts to clean up the data that was imported
% load('HDF_5DataV1');
% odorant = odorant'; % Flips the odorant data so that it's readable 
% trial_category = trial_category';
% rig = rig';
% mouse = mouse';
% 
% clear NameFile All_Vars All_Variables Data 
% 
% % clc
% % clear All_Variables Data All_Vars mouse rig Vars trial_category odorant nitrogen_flow NameFile
% % save('HDF_5DataV2')
% % 
% % 
% % Data = cell2struct(input('please copy and paste all variables that are in the workspace','s'))
% % xlswrite('HDF_5Data',Data)
% % 
% % rmfield()
% 
% % A = fieldnames(Data)
% % Counter = 1;
% % for 1:size{A}
% % B = A{Counter}
% % Counter = Counter + 1;
% % xlswrite('HDF_5Data',B,1,Counter)
% % end
% 
% 
% xlswrite('HDF_5Data',[air_flow                 
%     block_size               
%     final_valve_duration     
%     final_valve_onset        
%     first_lick               
%     initial_free_water_trials
%     inter_trial_interval     
%     left_free_water          
%     lick_grace_period        
%     licking_training         
%     mouse                    
%     nitrogen_flow            
%     odorant                  
%     odorant_trigger_phase    
%     odorvalve                
%     parameters_received_time 
%     percent_correct          
%     percent_left_correct     
%     percent_right_correct    
%     response                 
%     response_window          
%     rewards                  
%     rewards_left             
%     rewards_right            
%     rig                      
%     right_free_water        
%     session                  
%     tr                       
%     trialNumber              
%     trial_category           
%     trial_end                
%     trial_start              
%     trial_type_id            
%     water_duration1          
%     water_duration2])
% 



% B = char (fieldnames(Data'))
% C = char(B)



