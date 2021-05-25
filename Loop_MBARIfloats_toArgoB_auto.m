% Loop_MBARIfloats_toArgoB_auto.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT TO RUN Loop_MBARIfloats_toArgoB.m IN AUTOMATIC MODE ("new files only").  
% THIS SCRIPT GETS CALLED BY THE BAT FILE USED IN WINDOWS TASK SCHEDULER.
%
% TANYA MAURER
% MBARI
% 06/07/2017
% 03/08/2021 -- TM; removed separate calls to "Loop_SOCCOM_toArgoB" and
% "NON_SOCCOM_toArgoB"; these two functions have been merged.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
proc_status = Loop_MBARIfloats_toArgoB('all','new',[]) % 6/21/2017; exclude float 9659 per Annie (problem with DOXY bad values; auto-reject occurring at GDAC)
pause(180) %pause for 3 minutes before running transfer code
TRANSFER_BRzips_toGDAC('MBARIall',[])
pause(300) %pause for 5 minutes before running NON-SOCCOM floats
clear all
close all
Copy_MBARI2AOML_tonetwork

pause(60)
MATLABfinish
%END