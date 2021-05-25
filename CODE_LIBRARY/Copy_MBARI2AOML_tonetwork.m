% Copy_MBARI2AOML_tonetwork.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT TO COPY C:\Users\bgcargo\Documents\MATLAB\ARGO_MBARI2AOML\ TO
% \\ATLAS\CHEM
%
% TANYA MAURER
% MBARI
% 06/14/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


user_dir = getenv('USERPROFILE'); %returns user path,i.e. 'C:\Users\jplant'
user_dir = [user_dir, '\Documents\MATLAB\'];
dirs.bat = [user_dir,'\batchfiles\'];


% ************************************************************************
% COPY FILES TO THE NETWORK
% ************************************************************************
disp(' ');
disp('COPYING FILES TO THE NETWORK........');
str = [ dirs.bat,'copy_MBARItoGDAC_2network.bat'];
disp(str)
status = system(str);

end_copy_time = now;

disp(' ')
disp(['Network copy jobs completed at  ', ...
    datestr(end_copy_time),'.'])
%END