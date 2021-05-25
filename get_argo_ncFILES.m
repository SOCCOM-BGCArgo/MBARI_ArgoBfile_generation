function TF = get_argo_ncFILES(WMO, cycles_to_process, site_flag, dirs, servertry)
% This function tries to copy an ARGO  'D' or 'R' NetCDF file  to your
% local computer from either IFREMER or USGODAE
%
% INPUTS:
%   WMO                   - WMO ID as a number or char array
%   cycles_to_process     - 'new': only process new msg files
%                           'all': process all msg files 
%                           (ie)[105,106]: single cycle number or array of cycle numbers to process 
%   site_flag             - 1 = USGODAE, 0 = IFREMER
%   dirs                  - a structure of directory paths, if empty, [], see defaults
%                            below
%   serverty              - Number of attempts that have been made to server connect
%
% OUTPUTS:
%   TF.status     - 1 = success, 0 = file was not copied
%   TF.path       - path to file
%   TF.ftptarget  - ftp site used to connect (ifremer, usgodae)
%   TF.name       - file name
%   TF.filestatus - message file status (success, copyfail, nofiles)
%   TF.servertry  - Number of attempts to connect to server 
%                  0 = 1st attempt (0 have been made previously)
%                  1 = 2nd attempt (1 has already been made previously)
%                  2 = 2 have been made (usgodae and ifremer); error
%   TF.cycles     - cycles to process
%   TF.cycletime  - time of matfile creation for particular cycle
%
% UPDATES:  8/3/2017: Minor mod related to an update in MBARImat_to_ARGOb (see A.Wong email dated 7/25/2017)

% ************************************************************************
% CHECK INPUTS AND BUILD FILE NAME
if isnumeric(WMO)
    WMO = num2str(WMO);
end

TF.status = {0};
TF.filestatus = '';
TF.servertry = 0;
TF.path   = '';
TF.name   = '';
TF.cycletime = '';

% ************************************************************************
% SET DEFAULT DIR STRUCTURE
if isempty(dirs)
    user_d = getenv('USERPROFILE'); %returns user path,i.e. 'C:\Users\jplant'
    user_d = [user_d, '\Documents\MATLAB\'];
    dirs.mat       = [user_d,'ARGO_PROCESSING\DATA\FLOATS\'];
    dirs.temp      = 'C:\temp_argob\';
elseif ~isstruct(dirs)
    disp('Check "dirs" input. Must be an empty variable or a structure')
    return
end
    
% ************************************************************************
% OFTEN MATLAB FTP OBJECT NEEDS TO BE PUT IN PASIVE MODE
% Good hacks: 
%    http://blogs.mathworks.com/pick/2015/09/04/passive-mode-ftp/
%    http://undocumentedmatlab.com/blog/solving-an-mput-ftp-hang-problem
% ************************************************************************

% *************************************************************************
% CHOOSE DATA SITE
TF.site_flag = site_flag;
if site_flag == 1 % United states
    ftp_target = 'usgodae.org';
    TF.ftptarget = 'usgodae.org';
    ftp_dir  = '/pub/outgoing/argo/dac/aoml/';
elseif site_flag == 0 % France
    ftp_target = 'ftp.ifremer.fr';
    TF.ftptarget =  'ftp.ifremer.fr';
    ftp_dir  = '/ifremer/argo/dac/aoml/';
else
    disp('Unknown data site flag')
    return
end

% *************************************************************************
% TRY CONNECTING TO FTP SERVER
count = 1;
err_count = 1;
disp('')
disp(['Attempting to connect to ',ftp_target,'...',char(10),char(10)])

while count == err_count  
    try
        f = ftp(ftp_target,'anonymous','tmaurer@mbari.org','LocalDataConnectionMethod','passive'); % Connect to FTP server
        binary(f)
    catch
        if err_count >= 5
            ftperr = [' Connection to: ',ftp_target,' failed after 5 attempts.',char(10),...
            'No Argo Core files were obtained.'];
            disp(ftperr)
            TF.status = 0;
            if servertry == 0
                disp('Trying alternate GDAC...')
            end
            TF.servertry = servertry+1;
            return
        else
            disp(['Could not connect to ftp server at: ',ftp_target])
            disp('No files were obtained')
            disp('Trying again in 5 min')
            pause(3) %pause for 5 min then try again
            err_count = err_count+1;
        end
    end
    count = count+1;
end

% ************************************************************************
% ENTER PASSIVE MODE
% Enter passive mode by accessing the java object - this is the tricky part
%TM 12/16/2020; this is no longer needed in MATLAB2020.
% cd(f);
% sf = struct(f);
% sf.jobject.enterLocalPassiveMode();

% ************************************************************************
% DEFINE LIST OF BR FILES TO PROCESS (DEPENDS ON "cycle" USER INPUT)
% CASE 1: ONLY PROCESS NEW MSG FILES
%get list of BR files on GDAC
% % % ftp_path_meta = [ftp_dir,WMO];
% % % cd(f,ftp_path_meta);
% % % metadir = dir(f);
% % % metafiles = {metadir.name}';
% % % fname = [WMO,'_meta.nc'];
% % % str = mget(f, fname, dirs.temp);
ftp_path = [ftp_dir, WMO, '/profiles/'];
cd(f, ftp_path);       
argo_dir   = dir(f);   % SOCCOM FLOAT DIR
argo_files = {argo_dir.name}'; % Cell array of ARGO netcdf files
if strcmp(cycles_to_process,'new') == 1 %only new msg files are processed
    %compare gdac files to mat dir 
    ftp_path = [ftp_dir, WMO, '/profiles/'];
    cd(f, ftp_path);       
    argo_dir   = dir(f);   % SOCCOM FLOAT DIR
    argo_files = {argo_dir.name}'; % Cell array of ARGO netcdf files
    % get array of cycle numbers for which BR files already exist
    BRcycles = str2num(cell2mat(regexp(argo_files,'(?<=^BR\w+)\d+(?=\.nc)','once','match'))); %lookahead, lookbehind.  Find numbers between "_" and ".nc", only in BR files.
    BDcycles = str2num(cell2mat(regexp(argo_files,'(?<=^BD\w+)\d+(?=\.nc)','once','match'))); %lookahead, lookbehind.  Find numbers between "_" and ".nc", only in BD files.
    ArgoBcycles = unique([BRcycles;BDcycles]);
    mat_dir = dir([dirs.mat, WMO,'\',WMO,'*.mat']);
    filestime = datenum(char(mat_dir.date));
    mat_files = {mat_dir.name}';
    MATcycles = str2num(cell2mat(regexp(mat_files,'\d+(?=\.mat)','once','match'))); %lookahead, lookbehind.  Find numbers between "." and ".mat"
    [~,IA] = setdiff(MATcycles,ArgoBcycles); 
    if isempty(IA)
        disp(['No new MBARI mat files to process for WMO float ',WMO,'.'])
		disp(['Checking to ensure a matching number of BGC and CORE files for WMO float ',WMO,'.'])
		Rcycles = str2num(cell2mat(regexp(argo_files,'(?<=^R\w+)\d+(?=\.nc)','once','match'))); %lookahead, lookbehind.  Find numbers between "_" and ".nc", only in R files.
		Dcycles = str2num(cell2mat(regexp(argo_files,'(?<=^D\w+)\d+(?=\.nc)','once','match'))); %lookahead, lookbehind.  Find numbers between "_" and ".nc", only in D files.
		if length(Rcycles)+length(Dcycles) == length(BRcycles)+length(BDcycles)
			TF.status = 1;
			TF.filestatus = {'notapplicable'};
            disp('Core and BFile numbers match.  Moving to next float.')
			return
        else
            tmpcores = [Rcycles;Dcycles];
            disp('Bfiles')
            tmpBs = [BRcycles;BDcycles];
            [~,ia] = setdiff(tmpcores,tmpBs);
			TF.status = 1;
			TF.filestatus = {'missingBfile'};
            TF.missingBs = {tmpcores(ia)};
            disp('Core and BFile numbers do not match.  Sending email alert to data manager.')
			return
		end
    end
    mat2process = mat_files(IA);
% CASE 2: PROCESS ALL MSG FILES
elseif strcmp(cycles_to_process,'all') == 1 %reprocess all cycles
    mat_dir = dir([dirs.mat, WMO,'\',WMO,'*.mat']);
    filestime = datenum(char(mat_dir.date));
    mat_files = {mat_dir.name}';
    MATcycles = str2num(cell2mat(regexp(mat_files,'\d+(?=\.mat)','once','match'))); %lookahead, lookbehind.  Find numbers between "." and ".mat"
    IA = 1:length(MATcycles);
    mat2process = mat_files;
% CASE 3: ONLY PROCESS SPECIFIED CYCLE NUMBERS   
elseif isnumeric(cycles_to_process) == 1 %is array of cycle numbers to process
    mat_dir = dir([dirs.mat, WMO,'\',WMO,'*.mat']);
    filestime = datenum(char(mat_dir.date));
    mat_files = {mat_dir.name}';
    MATcycles = str2num(cell2mat(regexp(mat_files,'\d+(?=\.mat)','once','match'))); %lookahead, lookbehind.  Find numbers between "." and ".mat"
    [~,IA,~] = intersect(MATcycles,cycles_to_process);
    if isempty(IA)
        disp(['MBARI mat files for cycles',cycles_to_process,' specified by user do not exist for WMO float ',WMO,'.'])
        TF.status = 1;
        TF.filestatus = {'notapplicable'};
        return
    end
    mat2process = mat_files(IA);
end

disp(['Connection to ',ftp_target,' successful.'])
disp('MBARI mat files to process: ')
disp(mat2process)
disp('Searching for associated D or R .nc files on the GDAC...')
disp('')

% ************************************************************************
% CHECK FOR D or R FILES
for i = 1:length(IA)
    cycle = MATcycles(IA(i));
    TF.cycles{i} = cycle;
    TF.cycletime{i} = filestime(IA(i)); %keep cycle time for error referencing later in MBARImat_toARGOb.
    if isnumeric(cycle)
        cycle = sprintf('%03.0f',cycle);
    end
    argo_fname = ['D', WMO, '_', cycle, '.nc'];
    TF.filestatus{i} = 'success';
    TF.status{i} = 1;
    t1    = strcmp(argo_files, argo_fname);
    if sum(t1) == 1 % D file exists
        TF.is_there_AOnameD{i} = 3; %this variable is referenced in MBARImat_to_ARGOb (in response to an update by Annie Wong, July 2017)
        fname = argo_files{t1}; %D file
        TF.name{i} = fname;
    elseif sum(t1) == 0 % No D file, look for for R file
        TF.is_there_AOnameD{i} = 0;
        argo_fname = regexprep(argo_fname, 'D', 'R');
        t1         = strcmp(argo_files,argo_fname);
        if sum(t1) == 1
            fname = argo_files{t1}; % R file
            TF.name{i} = fname;
        else
            disp(['No NetCDF file found for ', WMO,' cycle # ', cycle]);
            TF.filestatus{i} = 'nofiles';
            TF.status{i} = 0;
            TF.name{i} = '';
            TF.path{i} = 'File missing from GDAC';
            continue
        end
    end
    
% ************************************************************************
% TRY AND FTP COPY
    try
        str = mget(f, fname, dirs.temp);
        str = cell2mat(str);
        TF.path{i} = str;
        disp([fname, ' found on GDAC and copied to ',dirs.temp])
    catch
        disp(['File found but ftp copy failed for ',WMO, ...
            ' cycle # ', cycle]);
        TF.filestatus = 'copyfail';
        TF.path{i} = 'Copy to local failed.';
        TF.status = 0;
        TF.name = '';
    end
end

TF.status = 1;
TF.servertry = servertry+1;
close(f);
% delete(f);
clearvars -except TF 
disp('')

%--------------------------------------------------------------------------
% END




