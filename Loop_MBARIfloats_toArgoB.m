function proc_status = Loop_MBARIfloats_toArgoB(WMOnum,cycles_to_process,exclude_floats)
% ************************************************************************
% Loop_MBARIfloats_toArgoB.m
% ************************************************************************
%
% Function to generate Argo netcdf B-files from MBARI-produced mat files.
% This is the driver for generating the daily automatic creation of BR
% files for new incoming cycles.  This function can also be used for ad-hoc
% maintenance (regeneration of specific cycles, or all cycles.  See call
% options below).
%
% GENERAL FUNCTION PROCEDURE:
%   - Load directory structure
%   - Load MBARI float list
%   - Loop through each float in list, calling  MBARImat_to_ARGOb.m
%
%
% USE AS: (1) For auto-creation of BR files for new incoming cycles, use as:
%           proc_status = Loop_MBARIfloats_toArgoB('all','new',[5904843])
%         (2) For regeneration of BR files for all cycles, use as:
%           proc_status = Loop_MBARIfloats_toArgoB('all','all',[])
%         (3) For regeneration of BR files for specific floats and cycles:
%           proc_status = Loop_MBARIfloats_toArgoB(5904672,[4,5,6],[]) (ie)
%
% INPUTS:
%    WMOnum            = WMO number to process, or 'all', to process all MBARI floats
%    cycles_to_process = 'new', 'all', or array of cycle numbers to process. 
%    exclude_floats    = WMO number(s) to exclude from loop, otherwise leave empty 
%
% OUTPUTS:  
%    BR files are generated.
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
% DATE: 4/19/2017
%
% UPDATES: 
% 5/23/2017, turned into a function to allow for ad-hoc 
%	user-defined reprocessing of specific floats and cycle numbers
% 6/21/2017, added functionality for excluding specific floats from WMOnum
%   list.
% 07/05/2017, TM: Merged BR-file email and ZIP-file email notifications
%   into a single email notification in TRANSFER_BRzips_toGDAC.m (removed 
%   from this function).
% 01/03/20, JP: Added code to remove floats from list not yet assigned a
%   WMO #
% 12/7/20 TM, Add capability to add listing of DMQC operator.  This will be
% Josh for non-soccom; tanya will be listed for SOCCOM floats (for now).
% NOTES: 
% ************************************************************************
%
% ************************************************************************

tic

REFRESH_floatlist = [];
NOW = datevec(now);
DMQCoperator.PRIMARY = 'PRIMARY | https://orcid.org/0000-0001-5766-1668 | Tanya Maurer, MBARI';
%--------------------------------------------------------------------------
% DEFINE DIRS STRUCTURE____________________________________________________
% user_dir = getenv('USERPROFILE'); %returns user path,i.e. 'C:\Users\tmaurer'
user_dir = getenv('USERPROFILE');
dirs.mat       = ['\\atlas\Chem\ARGO_PROCESSING\DATA\FLOATS\']; % Changed to \\atlas\Chem for orko
dirs.temp      = 'C:\temp_argob\';
dirs.BRdir = [user_dir,'\Documents\MATLAB\ARGO_MBARI2AOML\BRFILES_TEMP\'];
dirs.logs = [user_dir,'\Documents\MATLAB\ARGO_MBARI2AOML\LOG_FILES\'];
dirs.refresh = [user_dir,'\Documents\MATLAB\ARGO_MBARI2AOML\REFRESH_FILES\'];
dirs.bat = [user_dir,'\Documents\MATLAB\batchfiles\'];

%--------------------------------------------------------------------------
% CREATE DIARY LOG FILE
DD = datevec(datetime);
Mon = sprintf('%02.0f',DD(2));
Day = sprintf('%02.0f',DD(3));
Hr = sprintf('%02.0f',DD(4));
Mn = sprintf('%02.0f',DD(5));
diary_fn = ['Loop_MBARIfloats_toArgob_LOGFILE_',num2str(DD(1)),Mon,Day,Hr,Mn,'.txt'];
diary([dirs.logs,diary_fn]);
diary on

%--------------------------------------------------------------------------
% CONFIGURE EMAIL FOR ERROR NOTIFICATIONS
setpref('Internet','SMTP_Server','mbarimail.mbari.org'); % define server
setpref('Internet','E_mail','tmaurer@mbari.org'); % define sender
% email_list = {'jplant@mbari.org';'johnson@mbari.org';'tmaurer@mbari.org'};
email_list = {'tmaurer@mbari.org';'sbartoloni@mbari.org'};

%--------------------------------------------------------------------------
% DECIDE WHICH FTP SERVER TO USE
CT = now;
[~,~,~,hh,~,~] = datevec(CT);
if hh>=19 && hh < 7
    site_flag = 1; %Use USgodae as first attempt during off hours
else
    site_flag = 0; %Otherwise use France site as first attempt 
end

%--------------------------------------------------------------------------
% ORGANIZE FLOATS NUMBERS TO PROCESS
% and get list indices
load(['\\atlas\Chem\ARGO_PROCESSING\DATA\CAL\MBARI_float_list.mat']);
iMSG =find(strcmp('msg dir', d.hdr)  == 1);
iWMO = find(strcmp('WMO',d.hdr) == 1);
iMB  = find(strcmp('MBARI ID',d.hdr) == 1);
iINST = find(strcmp('INST ID',d.hdr) == 1);
iFLT = find(strcmp('float type',d.hdr) == 1);
iNC = find(strcmp('NC template',d.hdr) == 1);
iBF = find(strcmp('tf Bfile',d.hdr) == 1);
iPRG = find(strcmp('Program',d.hdr) == 1);
LIST = d.list;

% REMOVE FLOATS FROM LIST THAT DO NOT GET PUSHED TO GDAC (NO WMO)
%theLIST = LIST(logical(cell2mat(LIST(:,iBF))),:); % only floats with WMO's assigned
theLIST = LIST(cell2mat(LIST(:,iBF))==1,:); %only floats with WMO's assigned.  This column can have -1, which logical doesn't exclude...

MBARI_ids   = theLIST(:,iMB);
W_ids       = theLIST(:,iWMO);
WMO_ids     = str2num(char(W_ids));
fltTYPE     = theLIST(:,iFLT);
NCtype      = theLIST(:,iNC);
Prog        = theLIST(:,iPRG);
type_tag    = [];
for i = 1:length(fltTYPE)
    aorn = lower(fltTYPE{i});
    nm = num2str(NCtype{i});
    type_tag{i} = [aorn,'type',nm];
end
if isnumeric(WMOnum) == 1 || ~isempty(str2num(WMOnum))
    % only process select user-defined floats. Otherwise, process all.
    if ~isnumeric(WMOnum)
        WMOnum=str2num(WMOnum);
    end
     [C,IB,IA] = intersect(WMO_ids,WMOnum);
     type_tag = type_tag(IB);
     fltTYPE = fltTYPE(IB);
     WMO_ids = WMOnum;
     MBARI_ids = MBARI_ids(IB);
end 

%Deal with float exclusions
if ~isempty(exclude_floats)
    if isnumeric(exclude_floats)~=1
        exclude_floats = str2num(exclude_floats);
    end
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('EXCLUDING THE FOLLOWING FLOATS FROM Loop_MBARIfloats_toArgoB:')
    disp(num2str(exclude_floats))
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
else
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('RUNNING Loop_MBARIfloats_toArgoB WITHOUT ANY FLOAT EXCLUSIONS.')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
end

%--------------------------------------------------------------------------
% LOOP THROUGH FLOAT LIST, CALLING MBARImat_to_ARGOb
proc_status = nan(1,length(WMO_ids));
for im = 1:length(WMO_ids)
    % first check DMQC operator assignment; Josh Plant for older
    % non-SOCCOM/non-GOBGC floats.
    tmpProg = Prog{im,:};
    if strcmp(tmpProg,'UW/MBARI BGC-Argo') == 1
        DMQCoperator.PRIMARY =  'PRIMARY | https://orcid.org/0000-0003-1967-7639 | Josh Plant, MBARI'; %add Josh as operator.
    end
    WMO = WMO_ids(im);
	
% 	if strcmp(num2str(WMO),'2903886')==1 
% 		continue
% 	end
% 	
	
    C = intersect(WMO,exclude_floats);
    if ~isempty(exclude_floats) && ~isempty(C)
        continue
    else    
        Ftype = type_tag(im);
        AorN = fltTYPE(im);
        disp(['Running MBARImat_to_ARGOb.m for MBARI float ',MBARI_ids{im},...
            ', WMO # ',num2str(WMO),'.'])
        disp(['This is a ',char(fltTYPE{im}),' float of type "',char(Ftype),'".',char(10)])
        try
            [REFRESHflag, errorwmo] = MBARImat_to_ARGOb(WMO,MBARI_ids{im},cycles_to_process,site_flag,Ftype,dirs,AorN,DMQCoperator);
        catch mFAIL
            if im+1>length(WMO_ids) %if last float in list to process
                merr = ['Processing for WMO FLOAT ',num2str(WMO),' incomplete.',...
                char(10),'ERROR in: ',char(10),mFAIL.stack(1).file,', line ',num2str(mFAIL.stack(1).line),...
                char(10),mFAIL.stack(2).file,', line ',num2str(mFAIL.stack(2).line),char(10),...
                '** ',mFAIL.message,' **',char(10),'Last float in user-specified list.  Ending process now.'];
            else
                merr = ['Processing for WMO FLOAT ',num2str(WMO),' incomplete.',...
                char(10),'ERROR in: ',char(10),mFAIL.stack(1).file,', line ',num2str(mFAIL.stack(1).line),...
                char(10),mFAIL.stack(2).file,', line ',num2str(mFAIL.stack(2).line),char(10),...
                '** ',mFAIL.message,' **',char(10),'Continuing process with float ',num2str(WMO_ids(im+1)),'.'];
            end
            disp(merr)
            if strcmp(num2str(WMO),'5904670')==1 % We know this float results in error; don't send email each day!
                proc_status(im)=0;
                continue
            elseif weekday(now) >0 % == 1 && NOW(4)<12 %only email errors out on sunday morning (once per week).  Switched to sending all errors of this type regardless of runtime.
                % sendmail(email_list,'ERROR in MBARImat_to_ARGOb',merr) 
                proc_status(im) = 0;
                continue
            else
                proc_status(im) = 0; %dont send error emails every day!
            end
        end
        proc_status(im) = 1;
    end
    if REFRESHflag>0 && errorwmo==0 %this float should be refreshed.  Add to list.
        REFRESH_floatlist = [REFRESH_floatlist;WMO];
    end
end

% SEND EMAIL LISTING ALL BR FILES GENERATED % 7/5/17.  This notification
% was moved to TRANSFER_BRzips_toGDAC.m
X = dir([dirs.BRdir,'\*.nc']);
thefiles = char(X.name);
thesize = 10^(-3).*cell2mat({X.bytes}); %Kb
theSIZE = thesize';
ncfileinfo = [thefiles repmat(char(10),length(theSIZE),10) num2str(theSIZE)];
ncinfo={};
for j = 1:size(ncfileinfo,1)
    tmp = {ncfileinfo(j,:)};
    ncinfo = [ncinfo;tmp];
end
ncinfo
% if ischar(WMOnum)==1 && ischar(cycles_to_process)==1 && strcmp(WMOnum,'all')==1 && strcmp(cycles_to_process,'new')==1
%     sendmail(email_list,'NEW ARGO-BR FILES GENERATED',ncinfo)
% 	disp('mail sent')
% end
dirs.temp
delete([dirs.temp,'*.nc']) % Clear temp dir

%%%
% NOW WRITE REFRESH FILE: SIMPLE TXT FILE LISTING FLOATS READY FOR
% BR FILE 'REFRESH' (ALL CYCLES REGENERATED, PICKING UP CURRENT QC)
% THIS GETS PICKED UP BY Loop_MBARIfloats_toArgoB_fullfloatREFRESH.m WHICH IS
% RUN BY A SEPARATE PROCESS.
if ~isempty(REFRESH_floatlist)
    dateV = datevec(date);
    refresh_fname = ['MBARI_RefreshList_',char(sprintfc('%02d',dateV(2))),char(sprintfc('%02d',dateV(3))),num2str(dateV(1)),'.txt'];
    if exist([dirs.refresh,refresh_fname])>0 %file already exists (was created in earlier auto process)
       dlmwrite([dirs.refresh,refresh_fname],REFRESH_floatlist,'precision',8,'-append') %append to pre-existing file
       disp(['FLOAT REFRESH LIST HAS BEEN WRITTEN TO ',refresh_fname])
    else
        dlmwrite([dirs.refresh,refresh_fname],REFRESH_floatlist,'precision',8)
        disp(['FLOAT REFRESH LIST HAS BEEN WRITTEN TO ',refresh_fname])
    end
else
    if (ischar(cycles_to_process)==1 && strcmp(cycles_to_process,'all')==1) || (ischar(cycles_to_process)==0)
        disp('TRANSFER PROCESS COMPLETED IN "ALL" MODE.')
    else
        disp('NO FLOATS ARE READY FOR REFRESH ---> NO FLOAT REFRESH LIST WAS GENERATED.')
    end
end

% ************************************************************************
%  COPY FILES TO CHEM
% ************************************************************************
disp(' ');
disp('COPYING FILES TO THE NETWORK........');
str = [ dirs.bat,'copyMBARI2ARGObr.bat'];
status = system(str); % Comment this line out if you don't want to copy to Chem!

disp(str)

toc

diary off

 
%--------------------------------------------------------------------------
% END
