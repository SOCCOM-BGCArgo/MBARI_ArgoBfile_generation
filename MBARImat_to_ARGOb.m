function [REFRESHflag, errorwmo] = MBARImat_to_ARGOb(WMO,MBARIid,cycles_to_process, site_flag,Ftype,dirs,AorN,DMQCoperator)
%function [REFRESHflag, errorwmo] = MBARImat_to_ARGOb(WMO,cycles_to_process, site_flag,Ftype,dirs,AorN,DMQCoperator)


%


% ************************************************************************
% MBARImat_to_ARGOb.m
% ************************************************************************
%
% Function to generate Argo netcdf B-files from MBARI-produced mat files.
%
% GENERAL FUNCTION PROCEDURE:
%   - Check inputs and build filename
%   - Copy GDAC files to local (R- or D-).
%   - Download and use D-file if exists, otherwise use the R-file (if
%       neither exists, function does not proceed and email is sent to
%       tmaurer@mbari.org and jplant@mbari.org)
%   - Runs matchtest to assemble P/T/S data from core file and MBARI file.
%       Checks that they match in vertical levels as well as values
%       (within machine error).  If matchtest fails, email is sent.
%   - BR file(s) generated.
%
%
% USE AS: MBARImat_to_ARGOb(WMO,cycle,site_flag,type)
%
% INPUTS:
%    WMO               = Float WMO number
%	 MBARIid		   = MBARI float ID (for loading cal.mat for navistype7 OCR)
%    cycles_to_process = specifies files to process in call to get_argo_ncFILES
%    site_flag         = 1:usgodae, 0:ifremer
%    Ftype             = ie 'apextype1', Refer to
%                        MBARI_SOCCOM_float_type_list_feb2017.xlsx
%    dirs              = directory structure
%    AorN              = 'APEX' or 'NAVIS' float
%    DMQCoperator      = Structure containing string definitions of DMQC
%                       operators for each parameter (if not separated by parameter, only
%                       "PRIMARY" is listed).  ie: DMQCoperator.PRIMARY = 'PRIMARY | https://orcid.org/0000-0001-5766-1668 | Tanya Maurer, MBARI')
%
% OUTPUTS:
%    BR file is generated
%    REFRESHflag = 1 or 0 (flag to indicate whether or not this float
%    should be "refreshed" with all cycles regenerated.  This is done
%    float-by-float every N cycles (N defined below).
%
% SUPPORTING FUNCTIONS:
%     extract_floatTYPE.m
%     get_argo_nc.m
%     matchtest_core_mbari.m
%     investigate_matchtest.m
%     writedate.m
%     skeletonV31_create_apextype1.m
%     skeletonV31_create_apextype2.m
%     skeletonV31_create_apextype3.m
%     skeletonV31_create_apextype4.m
%     skeletonV31_create_apextype5.m
%     write_mbaridata_apextype1.m
%     write_mbaridata_apextype2.m
%     write_mbaridata_apextype3.m
%     write_mbaridata_apextype4.m
%     write_mbaridata_apextype5.m
%     skeletonV31_create_navistype1.m
%     skeletonV31_create_navistype2.m
%     skeletonV31_create_navistype3.m
%     write_mbaridata_navistype1.m
%     write_mbaridata_navistype2.m
%     write_mbaridata_navistype3.m
%     write_bfile_aomlinfopres.m
%     write_bfile_profparamqc_apex.m
%     write_bfile_profparamqc_navis.m
%     write_bfile_qcandhistory_apex.m
%     write_bfile_qcandhistory_navis.m
%
%
%
% AUTHOR:
%   Tanya Maurer
%   MBARI
%   tmaurer@mbari.org
%
% DATE: 4/11/2017
% UPDATES: 8/3/2017: Added variables from D-files that Annie was previously
% entering manually (see her email dated 7/25/2017)
%          11/15/17: Added code for float refresh capabilities
%           02/05/2018 Added capability to write BD (delayed mode) files,
%           depending on <param>_DATA_MODE assignment.
% 05/17/20, TM, update PI-NAME to account for Steve Riser floats that we process.  This is hard-wired for now...if we start processing more non-SOCCOM floats might need to make this smarter!
% 12/7/20 TM, Add capability to add listing of DMQC operator.  This will be
% 				Josh for non-soccom; tanya will be listed for SOCCOM floats (for now).
% 07/19/22 TM, modified portions of code in support of dynamic pressure axis modifications on SOLOII floats.
% 11/2/2023 to account for case where LR CTD pressure axis is empty!  5906765.102

% NOTES:
% ************************************************************************
%
% ************************************************************************

REFRESHflag = 0;
errorwmo = 0;
NOW=datevec(now);

%--------------------------------------------------------------------------
% CHECK INPUTS AND BUILD FILE NAME_________________________________________
if isnumeric(WMO)
    WMO = num2str(WMO);
end

%--------------------------------------------------------------------------
% CONFIGURE EMAIL FOR ERROR MSGS___________________________________________
setpref('Internet','SMTP_Server','mbarimail.mbari.org'); % define server
setpref('Internet','E_mail','tmaurer@mbari.org'); % define sender
% email_list = {'tmaurer@mbari.org';'jplant@mbari.org';'johnson@mbari.org'};
email_list = {'tmaurer@mbari.org';'sbartoloni@mbari.org'};
email_list_2 = {'tmaurer@mbari.org';'sbartoloni@mbari.org'};
%email_list = {'tmaurer@mbari.org'};
% mfile_errormsg = ['ERROR: ',MBname,' does not exist.',char(10),...
%     'Ending process "MBARImat_to_ARGOb.m" for WMO# ',...
%     WMO,', cycle ',cycle,'.'];
ftp_errormsg = ['ERROR: ftp connection failed after 5 attempts to both ',...
    'usgodae.org and ftp.ifremer.fr.  Ending process "MBARImat_to_ARGOb.m" for WMO# ',...
    WMO,'.'];
NA_errormsg = ['No new mat files exist.  Processing up to date for WMO# ',...
    WMO,'.'];
nofiles_errormsg = 'ERROR: No D or R files exist on GDAC server for WMO float ';
copyfail_errormsg = ['ERROR: ftp connection succeeded but failed to copy R or D files to local.',char(10),...
    'Ending process "MBARImat_to_ARGOb.m" for WMO# ',WMO,'.'];

%--------------------------------------------------------------------------
% CONNECT TO GDAC
% Logic in code below:  Try to get core files using specified ftp
% server.  In get_argo_nc, 5 attempts are made to connect.  If 5 attempts
% have failed (tf.status == 0), move on to second try.

count = 0;
err_count = 0;
TF = get_argo_ncFILES(WMO, cycles_to_process, site_flag, dirs,0);  %first try, using specified server
while count == err_count
    if (TF.status == 0) && (TF.servertry == 2) % 5 attempts have been made at both servers
        disp(ftp_errormsg)
        sendmail(email_list,'ERROR in MBARImat_to_ARGOb',ftp_errormsg) % SB too many error emails
        return
    elseif (TF.status == 0) && (TF.servertry == 1) % 5 attempts have been made at one server; try the other
        if TF.site_flag == 0 %if ifremer
            site_flag = 1; %try usgodae
        else %else if usgodae
            site_flag = 0; %try ifremer
        end
        TF = get_argo_ncFILES(WMO, cycles_to_process, site_flag, dirs,1);  %second try: use alternate ftp
        err_count = err_count+1;
        count = count+1;
    else % ftp connect succeeded.  still need to check if ftp copy was successful
        count = count+1;
    end
end
TF

% Add code here to add WMO to list if any of its new incoming cycles are
% multiples of "cycleN_refresh".
cycleN_refresh = 5; %refresh every fifth cycle (for now...might bump this up to 10 or 20 down the road) 11/15/17)
if ischar(cycles_to_process)==1 && strcmp(cycles_to_process,'new')==1 && isfield(TF,'cycles') % if in AUTO mode
    thecycles = cell2mat(TF.cycles);
    isittime = ~rem(thecycles,cycleN_refresh);
    if sum(isittime)>0 %there are multiples of 5 in the cycles to process
        REFRESHflag = 1;
    else
        REFRESHflag = 0;
    end
end

%--------------------------------------------------------------------------
% COPY GDAC CORE FILES TO LOCAL_____________________________________________
% Once connected (get_argo_nc.m), the BR files listed on the GDAC for
% specified float are compared to the matfiles on Chem.  Any cycles on Chem
% for which no BR file exists on the GDAC?  If so, bring over R or D files
% for those cycles.
% If code reached this far, the ftp connect was successful.  Now we need to
% check to be sure the file copy was successful (ie, there were new matfiles
% (cycles) for which BR files did't already exist, so we need to copy the R
% or D files (if they exist) to local so that we can generate the BR files).
% The ftp connection and file copy was all done in the call to get_argo_nc.m above.
%
rightnow = now; %time now
xhmnf = strcmp(TF.filestatus,'nofiles'); %where do "nofiles" exist in file array
wherenf = find(xhmnf==1);
TIME_lag = 0; %amount of time to wait before sending email notification that R/D file is missing from GDAC (in days.  For 2 cycles, TIME_lag = 20)
hmoldNF = find(xhmnf==1 & cell2mat(TF.cycletime)<now-TIME_lag);
howmanyNF = sum(strcmp(TF.filestatus,'nofiles'));
if howmanyNF > 0  && length(TF.filestatus)>1 %CASE FOR WHEN THERE ARE MULTIPLE MAT FILES TO PROCESS BUT SELECT CYCLES HAVE R OR D FILES MISSING FROM THE GDAC
    nofiles_errmsg = [nofiles_errormsg,WMO,', cycle(s):',char(10),num2str([TF.cycles{xhmnf==1}]),char(10),'File(s) missing since:'];
    for jj = 1:length(wherenf)
        strtmp = [char(10),datestr(TF.cycletime{wherenf(jj)})];
        nofiles_errmsg = [nofiles_errmsg,strtmp];
    end
    disp(nofiles_errmsg) %keep all missing gdac files recorded in the logfile, but only send email for ones that are > 2 cycles old  ** 2/26/18: previous comment was original coding.  Now I'm just sending error msgs once per week (so time lag removed)
    if ~isempty(hmoldNF) %send email if missing cycle is > 2 profile cycles old
        nofiles_errmsg_4email = [nofiles_errormsg,WMO,', cycle(s):   ',num2str([TF.cycles{hmoldNF}]),char(10),'MBARI .mat files last updated:'];
        for jj = 1:length(hmoldNF)
            strtmp = [char(10),datestr(TF.cycletime{hmoldNF(jj)})];
            nofiles_errmsg_4email = [nofiles_errmsg_4email,strtmp];
        end
        %send errormsg via email on sunday morning only (once per week)
        if strcmp(WMO,'5904477')~=1  && weekday(now)==4 %Use this setting for testing.  Send errors once a week!  Let's not clog inboxes...
            %         if strcmp(WMO,'5904477')~=1  && weekday(now)==1 && NOW(4)<12 %We know this float died in 2015, prof 18 last one on GDAC, but MBARI has matfiles for 19, 22, 23.  Don't send daily error msg for this float!
            % sendmail(email_list,'MISSING FILE in MBARImat_to_ARGOb',nofiles_errmsg_4email) 
        end
    end
    errorwmo = 1;
elseif howmanyNF ==1 && length(TF.filestatus)==1 %CASE FOR WHEN THERE IS ONE MAT FILE TO PROCESS BUT NO D OR R FILES EXIST.
    nofiles_errmsg = [nofiles_errormsg,WMO,' cycle: ',num2str(cell2mat(TF.cycles)),char(10),...
        'File missing since,  ',datestr(cell2mat(TF.cycletime)),char(10),...
        'There are no additional files to update.  Ending process for WMO float ',WMO,'.'];
    disp(nofiles_errmsg)
    errorwmo = 1;
    if ~isempty(hmoldNF) && weekday(now)==1  && NOW(4)<12 %send errormsg via email on sunday morning only (once per week)
        nofiles_errmsg_4email = [nofiles_errormsg,WMO,' cycle: ',num2str(cell2mat(TF.cycles)),char(10),...
            'File missing since,  ',datestr(TF.cycletime{hmoldNF}),char(10),...
            'There are no additional files to update.  Ending process for WMO float ',WMO,'.'];
        % sendmail(email_list,'MISSING FILE in MBARImat_to_ARGOb',nofiles_errmsg)
        return
    end
elseif (TF.status ==0) && (strcmp(TF.filestatus,'copyfail') == 1) %CASE FOR WHEN THERE ARE MAT FILE(S) TO PROCESS, R OR D FILE EXISTS, BUT THE COPY TO LOCAL FAILED.
    disp(copyfail_errormsg)
    sendmail(email_list,'ERROR in MBARImat_to_ARGOb',copyfail_errormsg)
    return
elseif (strcmp(TF.filestatus,'notapplicable') ==1) %CASE WHERE NO NEW MATFILES EXIST
    disp(NA_errormsg)
    return
end

%Now run case for when there is a mismatch between number of Bfiles and Core files on the GDAC
%TM Sept2024; removing this notification system, as we now run a stand-alone monthly process for auditing files at the GDAC
%if strcmp(TF.filestatus,'missingBfile') == 1
%    missingBfile_errmsg = ['For float ',WMO,': Certain Bfiles are missing on GDAC while corresponding core files exist: ',num2str(cell2mat(TF.missingBs)')];
%    if NOW(3)==1 && NOW(4)<12 % send these error msgs monthly
%        sendmail(email_list_2,'MISSING BGC FILE on GDAC',missingBfile_errmsg)
%    end
%    return
%end
% Now proceed

%--------------------------------------------------------------------------
% LOAD GDAC CORE FILE AND MBARI MAT FILE___________________________________
% FTP connection was successful, GDAC D or R files were copied.  Now loop
% through all GDAC files that were copied to temp and try generating BR
% files for each D or R file. (There will be one per cycle per float).
%
% Define nlevels, nvalues, nlowres, and cpact
for j_tm = 1:length(TF.path)
    AOname = TF.path{j_tm};
    CYCLE = sprintf('%03.0f',TF.cycles{j_tm});
    MBname = [dirs.mat, WMO,'\',WMO,'.',CYCLE,'.mat'];
    %filename will be either BR or BD, depending on highest level of <param>DATA_MODE.
    fnameBR=[dirs.BRdir,strcat('BR', WMO, '_', CYCLE, '.nc')];
    fnameBD=[dirs.BRdir,strcat('BD', WMO, '_', CYCLE, '.nc')];
    if isempty(AOname) || strcmp(AOname,'File missing from GDAC')==1
        continue
    else

        MB = load(MBname);            % this is where nvalues and nlowres come from ------
        AOML = load_aomlinfoandpres(AOname,Ftype,MB);    % loads R or D file. this is where nlevels comes from ------
        % keyboard
        if( strcmp(Ftype,'apextype13')==1 || strcmp(Ftype,'apextype4')==1 || strcmp(Ftype,'apextype10')==1 || strcmp(Ftype,'apextype11')==1 || strcmp(Ftype,'apextype12')==1)
            nlowres=length(MB.LR.DOXY);
        elseif strcmp(Ftype,'apextype14')==1
            nocrres=length(MB.OCR.DOWNWELLING_PAR);
        elseif strcmp(Ftype,'solotype1')==1 || strcmp(Ftype,'solotype2')==1%how to make this more dynamic?  Maybe keep as is for now until we know more about how much future solos might change.
            nbgcres = nan(MB.INFO.bgc_pres_axes_ct,1);
            for inbgc = 1:MB.INFO.bgc_pres_axes_ct
                eval(['nbgcres(inbgc,1) = length(MB.BGC0',num2str(inbgc),'.PRES);']);
            end
            %             nbgcres1 = length(MB.BGC01.DOXY);
            %             nbgcres2 = length(MB.BGC02.PH_IN_SITU_TOTAL);
            %             nbgcres3 = length(MB.BGC03.CHLA);
            %             nbgcres4 = length(MB.BGC04.DOWNWELLING_PAR);
            %             nbgcres5 = length(MB.BGC05.NITRATE);
            presax = find(not(cellfun('isempty',strfind(MB.INFO.sensors,'SBE41CP'))));
            if length(presax)==1
                shiftind = 0;
            elseif length(presax)==2
                shiftind = 1;
            end %should be 2 pres axes (sometimes 1...ie 5906765 cycle 102), if any other number, we want it to barf!  TM 11/2/23
            dox_ax = find(not(cellfun('isempty',strfind(MB.INFO.sensors,'DOX'))))-1;%these indices are used directly in write_bfile_profparamqc_solo.m  Minus 1 because the indexing used starts at 0.
            ph_ax = find(not(cellfun('isempty',strfind(MB.INFO.sensors,'ALK'))))-1;
            eco_ax = find(not(cellfun('isempty',strfind(MB.INFO.sensors,'ECO'))))-1;
            ocr_ax = find(not(cellfun('isempty',strfind(MB.INFO.sensors,'OCR'))))-1;
            nit_ax = find(not(cellfun('isempty',strfind(MB.INFO.sensors,'NO3'))))-1;
            % %             dox_ax = 2; %these indices are used directly in write_bfile_profparamqc_solo.m
            % %             ph_ax = 3;
            % %             eco_ax = 4;
            % %             ocr_ax = 5;
            % %             nit_ax = 6;
            eval(['[~,nvalues] = size(MB.BGC0',num2str(nit_ax-shiftind),'.UV_INTENSITY_NITRATE);']);
        else
            [nlowres,nvalues]=size(MB.LR.UV_INTENSITY_NITRATE);
        end
        %         cpact=[' ', num2str(MB.INFO.CpActivationP)]; % this is where cpact comes from ------

        %--------------------------------------------------------------------------
        % RUN MATCHTEST____________________________________________________________
%         keyboard
        nlevels = AOML.nlevels; % rename, nlevels is called in all write routines.
        if strcmp(Ftype,'solotype1')==1 || strcmp(Ftype,'solotype2')==1
%             if strcmp(WMO,'5906765')==1
%                 continue
%             end
            MT = matchtest_core_SOLO(MB,AOML);
            if(MT.checknlevels1==0 || MT.checknlevels2==0 || MT.checknlevelsBGC==0)
                disp('!!!!! MATCHTEST FAILED !!!!!');
                matchtest_errormsg = ['ERROR: Matchtest failed for WMO# ',WMO,' cycle',CYCLE,...
                    '.',char(10),'Ending process "MBARImat_to_ARGOb.m".',char(10),...
                    '*** matchtest error note: ',MT.notes,' ***'];
                sendmail(email_list,'ERROR in BSOLO Bfile processing',matchtest_errormsg)
                %           investigate_matchtest
                return; % do not proceed if matchtest fails
            end
        else
            MT = matchtest_core_mbari(MB,AOML,AorN);
            if(MT.checknlevels1==0 || MT.checknlevels2==0 || MT.statuss==0)
                disp('!!!!! MATCHTEST FAILED !!!!!');
                matchtest_errormsg = ['ERROR: Matchtest failed for WMO# ',WMO,' cycle',CYCLE,...
                    '.',char(10),'Ending process "MBARImat_to_ARGOb.m".',char(10),...
                    '*** matchtest error note: ',MT.notes,' ***'];
                sendmail(email_list,'ERROR in MBARImat_to_ARGOb',matchtest_errormsg)
                %           investigate_matchtest
                return; % do not proceed if matchtest fails
            end
        end

        %--------------------------------------------------------------------------
        % MATCHTEST PASSED, WRITE BR FILE__________________________________________
        disp(['MATCHTEST SUCCEEDED!  ',AOname,' and ',WMO,'.',CYCLE,'.mat match to within machine error.'])
        %            pause
        LR = MB.LR; %Return structure variables since calls below are not functions.  Next effor to clean up write scripts: will make them functions.
        HR = MB.HR;
        INFO = MB.INFO;

        % NOW CHECK DATA MODE AND ASSIGN FILENAME ACCORDINGLY
        % condensed and removed looop JP 01/14/20
        filenameBR = fnameBR;
        mode_test  = @(s) ~isempty(regexp(s,'DATA_MODE','once'));
        CC         = fieldnames(INFO);
        CC_data    = struct2cell(INFO); % data for field names
        tmode      = cellfun(mode_test, CC);
        mydm       = strcmp(CC_data(tmode),'D'); % check for any D mode data
        if sum(mydm) > 0
            filenameBR = fnameBD;
        end

        %             % NOW CHECK DATA MODE AND ASSIGN FILENAME ACCORDINGLY
        %             CC = fieldnames(INFO);
        %             outCell = cellfun(@(s)regexp(s,'DATA_MODE'),CC,'uniform',0);
        %             Index = find(not(cellfun('isempty', outCell)));
        %             MYDM = [];
        %             for i = 1:length(Index)
        %                 MYDM(i,1) = INFO.(CC{Index(i)});
        %             end
        %             mydm = find(MYDM=='D');
        %             if ~isempty(mydm) %if any parameters are "D" mode...
        %                 filenameBR = fnameBD;
        %             else % otherwise....
        %                 filenameBR = fnameBR;
        %             end
        if strfind(char(Ftype),'solo')==1 % any solo type
            nprof = INFO.pres_axes_ct;
            %determin "nparam"
            nparam = 1;
            for ii = 1:nprof-2 %bgc only
                eval(['ff = fieldnames(MB.BGC0',num2str(ii),');']);
                IndexC = strfind(ff,'ADJUSTED');
                IndexD = strfind(ff,'QC');
                INDc = find(not(cellfun('isempty',IndexC)));
                INDd = find(not(cellfun('isempty',IndexD)));
                fff = unique([INDc;INDd]); %indices of QC or ADJUSTED fields -- do not use in count of nparam
                nptmp = length(ff) - length(fff) - 2; %length of structure minus length of indices with adjusted&qc fields (not included), minus T&S (not included)
                if nptmp>nparam
                    nparam = nptmp;
                end
            end
            
            eval(['skeletonV31_create_',char(Ftype),';']);  % create BR skeleton with nlevels & nvalues
            eval(['write_mbaridata_',char(Ftype),';']); 
%             write_mbaridata_solotype1;     % write MBARI bgc data & qc flags to BR skeleton
            write_bfile_qcandhistory_solo; % perform rtqc & write history to BR file
            write_bfile_profparamqc_solo;  % compute PROFILE_PARAM_QC in BR files
        end
        if( strcmp(Ftype,'apextype1')==1 )
            skeletonV31_create_apextype1;  % create BR skeleton with nlevels & nvalues
            write_mbaridata_apextype1;     % write MBARI bgc data & qc flags to BR skeleton
            write_bfile_qcandhistory_apex; % perform rtqc & write history to BR file
            write_bfile_profparamqc_apex;  % compute PROFILE_PARAM_QC in BR files
        end
        if( strcmp(Ftype,'apextype2')==1 )
            skeletonV31_create_apextype2;
            write_mbaridata_apextype2;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype3')==1 ) || (strcmp(Ftype,'apextype8')==1) %added 4/30/18.  NON-SOCCOM floats apextype8 can use write routine for apextype3 (per annie wong).
            skeletonV31_create_apextype3;
            write_mbaridata_apextype3;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype4')==1 ) || (strcmp(Ftype,'apextype10')==1) %added 4/30/18.  NON-SOCCOM floats apextype8 can use write routine for apextype3 (per annie wong).
            skeletonV31_create_apextype4;
            write_mbaridata_apextype4;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype5')==1 )
            skeletonV31_create_apextype5;
            write_mbaridata_apextype5;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype6')==1 ) || (strcmp(Ftype,'apextype9')==1) %added 4/30/18.  NON-SOCCOM floats apextype8 can use write routine for apextype3 (per annie wong).
            skeletonV31_create_apextype6;
            write_mbaridata_apextype6;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype7')==1 )
            skeletonV31_create_apextype7;
            write_mbaridata_apextype7;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype11')==1 )
            skeletonV31_create_apextype11;
            write_mbaridata_apextype11;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype12')==1 )
            skeletonV31_create_apextype12;
            write_mbaridata_apextype12;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype13')==1 )
            skeletonV31_create_apextype13;
            write_mbaridata_apextype13;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype14')==1 )
            skeletonV31_create_apextype14;
            write_mbaridata_apextype14;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype15')==1 )
          skeletonV31_create_apextype15;
         write_mbaridata_apextype15;
        write_bfile_qcandhistory_apex;
        write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype16')==1 )
            skeletonV31_create_apextype16;
            write_mbaridata_apextype16;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'apextype17')==1 )
            skeletonV31_create_apextype17;
            write_mbaridata_apextype17;
            write_bfile_qcandhistory_apex;
            write_bfile_profparamqc_apex;
        end
        if( strcmp(Ftype,'navistype1')==1 )|| (strcmp(Ftype,'navistype4')==1)|| (strcmp(Ftype,'navistype6')==1) %added 1/08/20 JP.  Andrea's OSP float navistype4 with non standard header lines for MCOMS but identical to type1
            skeletonV31_create_navistype1;                                                                      % added 10/27/20 TM, Newer NAVIS file format with pH diagnostics.  Same as type 1 but with diag.  May create it's own write routine including Iparam diagnostics if decided to push those (but not a diag for each sample so...?)
            write_mbaridata_navistype1;
            write_bfile_qcandhistory_navis;
            write_bfile_profparamqc_navis;
        end
        if( strcmp(Ftype,'navistype2')==1 )
            skeletonV31_create_navistype2;
            write_mbaridata_navistype2;
            write_bfile_qcandhistory_navis;
            write_bfile_profparamqc_navis;
        end
        if( strcmp(Ftype,'navistype3')==1 )
            skeletonV31_create_navistype3;
            write_mbaridata_navistype3;
            write_bfile_qcandhistory_navis;
            write_bfile_profparamqc_navis;
        end
        if( strcmp(Ftype,'navistype7')==1 )
            % keyboard
			load(['\\atlas\Chem\ARGO_PROCESSING\DATA\CAL\cal',MBARIid,'.mat'])
			OCRchs{1} = cal.OCR.CH01.WL;
			OCRchs{2} = cal.OCR.CH02.WL;
			OCRchs{3} = cal.OCR.CH03.WL;
			OCRchs{4} = cal.OCR.CH04.WL;
            skeletonV31_create_navistype7;
            write_mbaridata_navistype7;
            write_bfile_qcandhistory_navis;
            write_bfile_profparamqc_navis;
        end

        if( strfind(char(Ftype),'solo')==1 )
            write_bfile_aomlinfopres_solo;
        else
            write_bfile_aomlinfopres;     % write aoml general info and PRES to BR file
        end
        % set VERTICAL_SAMPLING_SCHEME and PI_NAME ------
        % TM 051121 Use info from core file for consistency!
        % % %             enough256=num2str(ones(256,1));
        % % %
        % % %             vscheme1=strcat('Primary sampling: mixed [deeper than nominal', cpact, 'dbar: discrete; nominal ', cpact, 'dbar to surface: 2dbar-bin averaged]');
        % % %             junk1=char(vscheme1,enough256');
        % % %
        % % %             vscheme2='Secondary sampling: discrete []';
        % % %             junk2=char(vscheme2,enough256');
        % % %
        % % %             vscheme256(1,:)=junk1(1,:);
        % % %             vscheme256(2,:)=junk2(1,:);


        %aw July 2017
        if(TF.is_there_AOnameD{j_tm}==3) % if D-file exists, use D-file variables; This variable is defined in get_argo_ncFILES.
            fid=netcdf.open(filenameBR,'write');
            varid=netcdf.inqVarID(fid,'VERTICAL_SAMPLING_SCHEME');
            netcdf.putVar(fid,varid,AOML.vss_core);
            varid=netcdf.inqVarID(fid,'PI_NAME');
            netcdf.putVar(fid,varid,AOML.pi_name_core);
            varid=netcdf.inqVarID(fid,'CONFIG_MISSION_NUMBER');
            netcdf.putVar(fid,varid,AOML.config_mission_core);
            netcdf.close(fid);
            disp(['USING EXISTING CYCLE ',num2str(CYCLE),' D-FILE VARIABLE NAMES FOR:'])
            disp('VERTICAL_SAMPLING_SCHEME')
            disp('PI_NAME')
            disp('CONFIG_MISSION_NUMBER')
        else % if no D-file
            fid=netcdf.open(filenameBR,'write');
            varid=netcdf.inqVarID(fid,'VERTICAL_SAMPLING_SCHEME');
            %                 netcdf.putVar(fid,varid,vscheme256');
            netcdf.putVar(fid,varid,AOML.vss_core); %TM 051121 use these fields from core files.
            varid=netcdf.inqVarID(fid,'PI_NAME');
            netcdf.putVar(fid,varid,AOML.pi_name_core);
            varid=netcdf.inqVarID(fid,'CONFIG_MISSION_NUMBER');
            %                 netcdf.putVar(fid,varid,AOML.cycle_number);
            netcdf.putVar(fid,varid,AOML.config_mission_core);
            netcdf.close(fid);
            disp(['NO D-FILE EXISTS FOR CYCLE ',num2str(CYCLE),'. VARIABLE NAMES ARE BEING AUTO FILLED FOR:'])
            disp('VERTICAL_SAMPLING_SCHEME')
            disp('PI_NAME')
            disp('CONFIG_MISSION_NUMBER')
        end
        % 3/8/21 TM -- switch back to extracting PINAME and PROJECTNAME
        % from AOML core files.  These fields need to match anyway;
        % Matt Alkire extracts his Dfile info from AOML.
        % %
        % %
        % %             % check for Steve Riser (only) floats:
        % %                 %12472SOOCN 12472 5905381 11 APEX
        % %                 %12631SOOCN 12631 5905382 11 APEX
        % %                 %12652SOOCN 12652 5905383 11 APEX
        % %                 %12712SOOCN 12712 5905380 11 APEX
        % %                 % the rest are eqpac (TPOS deployments)
        % %             RisFlt = [5905381;5905382;5905383;5905380;5906302;5906300;5906301;5906303;5906238;5906237;5906236;5906235];
        % %             RisFlti = find(RisFlt == str2num(WMO));
        % % 			GregFlt = [5906293;5906294;5906243];
        % % 			GregFlti = find(GregFlt == str2num(WMO));
        % % 			FasFlt = [5905988];
        % % 			FasFlti = find(FasFlt == str2num(WMO));
        % %             if ~isempty(RisFlti)
        % %                 piname=[...
        % %                     'STEPHEN RISER                                                   ',
        % %                     'STEPHEN RISER                                                   '];
        % %             elseif ~isempty(FasFlti)
        % %                 piname=[...
        % %                     'ANDREA FASSBENDER                                               ',
        % %                     'ANDREA FASSBENDER                                               '];
        % %             elseif ~isempty(GregFlti)
        % %                 piname=[...
        % %                     'GREGORY JOHNSON                                                 ',
        % %                     'GREGORY JOHNSON                                                 '];
        % % 			else
        % %                 piname=[...
        % %                     'STEPHEN RISER, KENNETH JOHNSON                                  ',
        % %                     'STEPHEN RISER, KENNETH JOHNSON                                  '];
        % %             end
        % %             varid=netcdf.inqVarID(fid,'PI_NAME');
        % %             netcdf.putVar(fid,varid,piname');
        % %             netcdf.close(fid);


        % add global attributes ------

        t=datetime('now','TimeZone','UTC');

        ncwriteatt(filenameBR, '/', 'title', 'Argo float vertical profile');
        ncwriteatt(filenameBR, '/', 'institution', 'MBARI');
        ncwriteatt(filenameBR, '/', 'source', 'Argo float');
        ncwriteatt(filenameBR, '/', 'history', strcat(datestr(t,'yyyy-mm-ddTHH:MM:SSZ'), ' creation'));
        ncwriteatt(filenameBR, '/', 'references', 'http://www.argodatamgt.org/Documentation');
        ncwriteatt(filenameBR, '/', 'comment', 'free text');
        ncwriteatt(filenameBR, '/', 'user_manual_version', '3.2');
        ncwriteatt(filenameBR, '/', 'Conventions', 'Argo-3.2 CF-1.6');
        ncwriteatt(filenameBR, '/', 'featureType', 'trajectoryProfile');
        if ~isempty(DMQCoperator)
            ncwriteatt(filenameBR, '/', 'comment_dmqc_operator', DMQCoperator.PRIMARY);
        end


        disp([filenameBR,' successfully written to ',dirs.BRdir,char(10),char(10)])

        %         end  % end if matchtest pass
    end %end if AOML file exists (it should if it made it past the other checks...)
    if strfind(char(Ftype),'solo')==1
        clear dsindicator dsindicatorFULL nparam nprof nbgcres nvalues datamode_CHECK FULLinds param_datamode datamode phdatamode doxydatamode chladatamode bbpdatamode cdomdatamode nidatamode irr380datamode irr412datamode irr490datamode pardatamode
    end
end %end for j_tm= 1:length(TF.path), loop through D files to create BR files

%--------------------------------------------------------------------------
% END



