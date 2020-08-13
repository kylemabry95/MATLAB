%% Friedman test Analysis through conversion of an Excel .xlxs document. KJM 10.18.19 

clc;
clear all;
close all; 

%Code below tells matlab where our file is. - you'll need to change this
%directory to where you saved the Excel file. 
cd('/Users/kmabry/Desktop');


% Format =  "Data = xlsread('myExample.xls', 'MySheet')"
% you'll need to update the Book111 most likely to whatever you named the
% excel file. 
DataInf = xlsread('Book111', 'inf');
DataSup = xlsread('Book111','sup');


figure(3) 
hold on 
boxplot(DataInf) 
title('CES1 CES2 and CES3 Friedman Inferrior Turbinate') 
hold off

figure(4)
hold on 
boxplot(DataSup) 
title('CES1 CES2 and CES3 Friedman Superior Turbinate') 
hold off

InfFriedman = friedman(DataInf,3,'on')

SupFriedman = friedman(DataSup,3,'on')

%optional and gives us a table in the command line instead of in a figure. 
% [P,TABLE,STATS] = friedman(DataInf,3,'on')

