% ************************************************************************
% Loop_MBARIfloats_toArgoB_fullfloatREFRESH.m
% ************************************************************************
%
% Script to generate Argo netcdf B-files from MBARI-produced mat files
% for all cycles of a single float.  Program reads float-refresh-list
% generated from Loop_MBARIfloats_toArgoB for that day.  Any floats listed
% (who's latest cycle# is a multiple of threshold value "cycleN_refresh", which is defined in MBARImat_to_ARGOb.m.)
% will get reprocessed in full, thus picking up up-to-date QC and pushing
% updated files to GDAC.  
%
%
% USE AS:
%
% INPUTS:
%
% OUTPUTS:  
%    BR files are regenerated.
%    proc_status = status of job; 1 = success, 0 = failure
%
% SUPPORTING FUNCTIONS:
%     loadSOCCOMlist_for_ArgoBtransfer
%     MBARImat_to_ARGOb
%     get_argo_ncFILES
%
%
% AUTHOR: 
%   Tanya Maurer
%   MBARI
%   tmaurer@mbari.org
%
% DATE: 11/15/17
% UPDATES: 3/8/21; merged soccom/non-soccom into single refresh routine.
% NOTES: 
% ************************************************************************
%
% ************************************************************************
% DEFINE DIRS STRUCTURE____________________________________________________
user_dir = getenv('USERPROFILE'); %returns user path,i.e. 'C:\Users\tmaurer'
user_dir = [user_dir, '\Documents\MATLAB\'];
dirs.logs = [user_dir,'\ARGO_MBARI2AOML\LOG_FILES\'];
filelists_dir = [user_dir,'\ARGO_MBARI2AOML\REFRESH_FILES\'];

dd = dir([filelists_dir,'*.txt']);
thedates = char(dd.date);
thefiles = char(dd.name);
x = find(datenum(thedates)>now-0.75 & datenum(thedates)<now); %find refresh files that were created from yesterday afternoon and this morning.  Searching back in time a 3/4 a day will do this.
disp('GRABBING REFRESH FILE LIST...')
if ~isempty(x)
    loopthisfile = thefiles(x,:);
    disp('FILE(S) FOUND.')
else
    disp('***********************************************************************************')
    disp('NO REFRESH FILE LIST WAS GENERATED TODAY.  NO FLOATS ARE IN NEED OF REFRESH.')
    disp('ENDING REFRESH SCRIPT NOW.')
    disp('SEE YOU TOMORROW.')
    disp('***********************************************************************************')
    return
end

for fl = 1:length(x) %there may be 2 lists (1 for SOCCOM, 1 for NON-SOCCOM).  3/8/21; should only be one list per day now due to merging of soccom/non-soccom; but keep this check in for now.
    Fname = loopthisfile(fl,:);
        fid = fopen([filelists_dir,Fname]);
        t=textscan(fid,'%s');
        refreshfloats = str2num(char(t{:}));
        fclose(fid);
        disp('THE FOLLOWING FLOATS ARE IN NEED OF REFRESH:')
        refreshfloats
        disp('LOOPING THROUGH REFRESH-FLOATS NOW...')

        for i = 1:length(refreshfloats)
            WMOnum = refreshfloats(i);
            if strcmp(num2str(WMOnum),'5905000') == 1
                %     if strcmp(num2str(WMOnum),'5905075') == 1 || strcmp(num2str(WMOnum),'5904860')  == 1 || strcmp(num2str(WMOnum),'5905100') == 1 || strcmp(num2str(WMOnum),'5904472') == 1 || strcmp(num2str(WMOnum),'5904683') == 1
%                 disp('Skipping 5904684, 5905075, 5904683, 5905100, 5904860 and 5904472 refresh, stuck in queue.')
            else
                disp(['REPROCESSING BR FILES FOR FLOAT ',num2str(WMOnum)])
                proc_status = Loop_MBARIfloats_toArgoB(WMOnum,'all',[]);
            end
        end

        pause(60)
        disp('NOW TRANSFERRING REFRESHED MBARI-processed BR FILES TO GDACS FOR ALL FLOATS ON TODAYS LIST...')
        TRANSFER_BRzips_toGDAC('MBARIall',[])
        disp('MBARI BR-File REFRESH PROCESS COMPLETE.')       
end

disp('DONE WITH ALL REFRESH PROCESSES. SEE YOU TOMORROW.')
pause(60)
MATLABfinish
% end




