%
% This function writes MBARI-processed bgc data into its b-file skeleton
% with N_PROF=7
%
% SOLO Rudix with SBE 83 (doxy), SUNA (nitrate), SBSpcomp (ph), ECO (chla & bb, cdom), OCR (irr380, irr412, irr490, par)
%
% 10 B-Argo parameters:
%         DOXY
%         CHLA
%		  CHLA_FLUORESCENCE
%         BBP700
%         CDOM
%         PH_IN_SITU_TOTAL
%         NITRATE
%         DOWNWELLING_PAR
%         DOWN_IRRADIANCE490
%         DOWN_IRRADIANCE412
%         DOWN_IRRADIANCE380
%
% 16 I-Argo parameters:
%         PHASE_DELAY_DOXY
%         TEMP_DOXY
%         FLUORESCENCE_CHLA
%         BETA_BACKSCATTERING700
%         FLUORESCENCE_CDOM
%         VRS_PH
%         PH_IN_SITU_FREE
%         IB_PH
%         IK_PH
%         VK_PH
%         UV_INTENSITY_DARK_NITRATE
%         UV_INTENSITY_NITRATE
%         RAW_DOWNWELLING_IRRADIANCE380
%         RAW_DOWNWELLING_IRRADIANCE412
%         RAW_DOWNWELLING_IRRADIANCE490
%         RAW_DOWNWELLING_PAR
%
% THIS TEMPLATE WAS GENERATED IN SUPPORT OF THE FIRST BSOLO TEST FLOAT IN THE GOBGC PROGRAM.
% BSOLO 0001 WMO 4903026, DEPLOYED IN MONTEREY BAY
% ALL BGC SENSORS REPORT ON A SEPARATE PRESSURE AXIS SO N_PROF = 2 (CTD HR and LR) + 5 (BGC SENSORS) = 7
% THE MAXIMUM NUMBER OF ARGO PARAMETERS FOR A GIVEN PRESSURE AXIS IS FOR THE OCR SENSOR, N_PARAM = 4 (B-ARGO PARAMS) + 4 (I-ARGO PARAMS) + 1 (PRES) = 9
%
%
% Tanya Maurer, Feb 7, 2022
% UPDATED 7/19/2022 to accomadate dynamic pressure axes identification (ie for floats that turn off pH sensors mid-life!)
% UPDATED 11/2/2023 to account for case where LR CTD pressure axis is empty!  5906765.102
% UPDATE 01/25/24 AGAIN to account for more problems when data is missing
% from transmissions!!
%  UPDATE 07/02/2024 TM to include CHLA_FLUORESCENCE parameter

%--------------------------------------------------------------

%-----------
% % % % TESTING!!!!
% % % filenameBR = 'testingSOLO.nc';
% % % nprof = 7;
% % % nparam = 9;
% % % skeletonV31_create_solotype1
% % % ncid=netcdf.create(filenameBR,'clobber');
% % % load Z:\ARGO_PROCESSING\DATA\FLOATS\4903026\4903026.100.mat
% % % % END TESTING!!!!
mytemp = MB.LR.PRES;
if isempty(mytemp)
    myindtmp = 1;
else
    myindtmp = 2;
end
%-----------

% declare FillValue ------

fillfloat=single(99999.);


% open the BR-file ------

fid=netcdf.open(filenameBR,'write');


% assign STATION_PARAMETERS and PARAMETER in calib ------

enough64=num2str(ones(64,1));

junkpres=char('PRES',enough64');
pres64=junkpres(1,:);

junk64=pres64;
junk64(1:4)='    ';

junktempdoxy=char('TEMP_DOXY',enough64');
tempdoxy64=junktempdoxy(1,:);

junkphasedelaydoxy=char('PHASE_DELAY_DOXY',enough64');
phasedelaydoxy64=junkphasedelaydoxy(1,:);

junkdoxy=char('DOXY',enough64');
doxy64=junkdoxy(1,:);

junkfluorescencechla=char('FLUORESCENCE_CHLA',enough64');
fluorescencechla64=junkfluorescencechla(1,:);

junkchla=char('CHLA',enough64');
chla64=junkchla(1,:);

junkchlaF=char('CHLA_FLUORESCENCE',enough64');
chlaF64=junkchlaF(1,:);

junkbackscattering=char('BETA_BACKSCATTERING700',enough64');
backscattering64=junkbackscattering(1,:);

junkbbp=char('BBP700',enough64');
bbp64=junkbbp(1,:);

junkfluorescencecdom=char('FLUORESCENCE_CDOM',enough64');
fluorescencecdom64=junkfluorescencecdom(1,:);

junkcdom=char('CDOM',enough64');
cdom64=junkcdom(1,:);

junkvrsph=char('VRS_PH',enough64');
vrsph64=junkvrsph(1,:);

junkibph=char('IB_PH',enough64');
ibph64=junkibph(1,:);

junkikph=char('IK_PH',enough64');
ikph64=junkikph(1,:);

junkvkph=char('VK_PH',enough64');
vkph64=junkvkph(1,:);

junkphfree=char('PH_IN_SITU_FREE',enough64');
phfree64=junkphfree(1,:);

junkphtotal=char('PH_IN_SITU_TOTAL',enough64');
phtotal64=junkphtotal(1,:);

junkuvdarknitrate=char('UV_INTENSITY_DARK_NITRATE',enough64');
uvdarknitrate64=junkuvdarknitrate(1,:);

junkuvnitrate=char('UV_INTENSITY_NITRATE',enough64');
uvnitrate64=junkuvnitrate(1,:);

junknitrate=char('NITRATE',enough64');
nitrate64=junknitrate(1,:);

junktemp_rawdwirr380=char('RAW_DOWNWELLING_IRRADIANCE380',enough64');
rawdwirr380_64=junktemp_rawdwirr380(1,:);

junktemp_rawdwirr412=char('RAW_DOWNWELLING_IRRADIANCE412',enough64');
rawdwirr412_64=junktemp_rawdwirr412(1,:);

junktemp_rawdwirr490=char('RAW_DOWNWELLING_IRRADIANCE490',enough64');
rawdwirr490_64=junktemp_rawdwirr490(1,:);

junktemp_rawdwpar=char('RAW_DOWNWELLING_PAR',enough64');
rawdpar_64=junktemp_rawdwpar(1,:);

junkdwirr380=char('DOWN_IRRADIANCE380',enough64');
dwir380_64=junkdwirr380(1,:);

junkdwirr412=char('DOWN_IRRADIANCE412',enough64');
dwir412_64=junkdwirr412(1,:);

junkdwirr490=char('DOWN_IRRADIANCE490',enough64');
dwir490_64=junkdwirr490(1,:);

junkdwpar=char('DOWNWELLING_PAR',enough64');
dwpar_64=junkdwpar(1,:);

DOXs = [tempdoxy64, phasedelaydoxy64, doxy64];
PHs = [vrsph64, ibph64, ikph64, vkph64, phfree64, phtotal64];
ECOs = [fluorescencechla64, chla64, chlaF64, backscattering64, bbp64, fluorescencecdom64, cdom64];
OCRs = [rawdwirr380_64, rawdwirr412_64, rawdwirr490_64, rawdpar_64, dwir380_64, dwir412_64, dwir490_64, dwpar_64];
NO3s = [uvdarknitrate64, uvnitrate64, nitrate64];
mywrites = {DOXs,PHs,ECOs,OCRs,NO3s};
fullsensors = {'DOX','ALK','ECO','OCR','NO3'};
TMP = cell(7,1); %start with max 7
FULLinds = [];
for ifs = 1:length(fullsensors) %loop through all BGC and concatenate as needed (ie if multiple sensors are on same axis, this will bring them together)
    indI = strfind(MB.INFO.sensors,fullsensors{ifs});
    IndexI = find(not(cellfun('isempty',indI)));
    if ~isempty(IndexI)
        TMP{IndexI} = [TMP{IndexI} mywrites{ifs}];
        FULLinds(ifs) = IndexI; %store indices of each BGC for use in datamode definitions
    else
        %can skip defining TMP; no axis here
        FULLinds(ifs) = 0;
    end
end
%Now that they are all on their appropriate row/axis, remove any extraneous rows (empty rows outside of the first 2 pres axes)
emptyinds = find(cellfun(@isempty,TMP));
emptyinds = emptyinds(emptyinds>2);
TMP(emptyinds,:) = [];
%Now assess the cell array, final "station_params" listing needs to have max columns in each row (fill with junk64 as needed).  Also, remove extraneous rows (axes).
LENGTH=0;
for ii2 = 1:size(TMP,1)
    tempp = TMP{ii2,1};
    LNG = length(tempp);
    if LNG>LENGTH
        LENGTH = LNG;
    end
end
lL = LENGTH/64; %should be equal to nparam - 1 (without pres).  Need to fill other rows with junk64 until we reach LENGTH.  This is cludgy!  But works. :0)
% Another loop...somewhat inefficient but I don't think I can combine with the previous loop.
for ii3 = 1:size(TMP,1)
    myrow = TMP{ii3};
    numrep = lL - length(myrow)./64; %find out number of junk64 that you need to fill out that row to reach max LENGTH for max pres axis.
    myrow = [pres64 myrow repmat(junk64,1,numrep)];
    station_params(ii3,:) = myrow;
end
% Old way: explicit definition of station params.  Hard coded to original
% BSOLO configuration for nprof, nparam.
% % % station_params=...
% % %     [pres64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64;
% % %     pres64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64;
% % %     pres64, tempdoxy64, phasedelaydoxy64, doxy64, junk64, junk64, junk64, junk64, junk64;
% % %     pres64,  vrsph64, ibph64, ikph64, vkph64, phfree64, phtotal64, junk64, junk64;
% % %     pres64, fluorescencechla64, chla64, backscattering64, bbp64, fluorescencecdom64, cdom64, junk64, junk64;
% % %     pres64, rawdwirr380_64, rawdwirr412_64, rawdwirr490_64, rawdpar_64, dwir380_64, dwir412_64, dwir490_64, dwpar_64;
% % %     pres64, uvdarknitrate64, uvnitrate64, nitrate64, junk64, junk64, junk64, junk64, junk64];

varid=netcdf.inqVarID(fid,'STATION_PARAMETERS');
netcdf.putVar(fid, varid, station_params');

varid=netcdf.inqVarID(fid,'PARAMETER');
netcdf.putVar(fid, varid, station_params');

clear TMP myrow station_params junk64 junkpres junktempdoxy junktphasedoxy junkdoxy junkfluorescence junkchla junkchlaF junkbackscattering junkbbp junkvrsph junkibph junkikph junkvkph junkphfree junkphtotal junkuvdarknitrate junkuvnitrate junknitrate junktemp_rawdwirr380 junktemp_rawdwirr412 junktemp_rawdwirr490 junktemp_rawdwpar junkdwirr380 junkdwirr412 junkdwirr490 junkdwpar


% assign DATA_MODE and PARAMETER_DATA_MODE ------
% each axis needs it's own full data mode.
% REMEMBER, FULLinds stores pressure axis indices for each parameter, in order (if they share a pressure axis, the index will be repeated): {'DOX','ALK','ECO','OCR','NO3'};
datamode_CHECK = repmat({1},length(unique(FULLinds)),1); %create a cell to store datamode for each param in each axis for full datamode definition
for kk = 1:length(FULLinds)
    if FULLinds(kk)>0 && kk == 1 %DOX
        doxydatamode=INFO.DOXY_DATA_MODE;
        if(doxydatamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(doxydatamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end
    elseif FULLinds(kk)>0 && kk == 2 %ALK
        phdatamode=INFO.PH_DATA_MODE;
        if(phdatamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(phdatamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end
    elseif FULLinds(kk)>0 && kk == 3 %ECO
        chladatamode=INFO.CHLA_DATA_MODE;
		chlaFdatamode=INFO.CHLA_FLUORESCENCE_DATA_MODE;
        bbpdatamode=INFO.BBP700_DATA_MODE;
        cdomdatamode=INFO.CDOM_DATA_MODE;
        if(chladatamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(chladatamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end
        if(chlaFdatamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(chlaFdatamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end		
        if(bbpdatamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(bbpdatamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end
        if(cdomdatamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(cdomdatamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end
    elseif FULLinds(kk)>0 && kk == 4 %OCR
        irr380datamode=INFO.DOWN_IRRADIANCE380_DATA_MODE;
        irr412datamode=INFO.DOWN_IRRADIANCE412_DATA_MODE;
        irr490datamode=INFO.DOWN_IRRADIANCE490_DATA_MODE;
        pardatamode=INFO.DOWNWELLING_PAR_DATA_MODE;
        if(irr380datamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(irr380datamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end
        if(irr412datamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(irr412datamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end
        if(irr490datamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(irr490datamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end
        if(pardatamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(pardatamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end
    elseif FULLinds(kk)>0 && kk == 5 %NO3
        nidatamode=INFO.NITRATE_DATA_MODE;
        if(nidatamode=='A')datamode_CHECK{kk}=[datamode_CHECK{kk} 2];end
        if(nidatamode=='D')datamode_CHECK{kk}=[datamode_CHECK{kk} 3];end
    end
end

if isempty(mytemp)
    datamode = ['R']; %for 1 ctd axis
else
    datamode = ['R';'R']; %for 2 ctd axes
end
for kk2 = 1:length(datamode_CHECK)
    if FULLinds(kk2)==0
        continue
    else
        tmpdm = datamode_CHECK{kk2};
        if(max(tmpdm)==1)datamode_whole='R';end
        if(max(tmpdm)==2)datamode_whole='A';end
        if(max(tmpdm)==3)datamode_whole='D';end
        datamode = [datamode; datamode_whole];
    end
end


%datamode=['R';'R';doxydatamode;phdatamode;datamode_check_BGC03whole;datamode_check_BGC04whole;nidatamode];

% % % param_datamode=...
% % %     ['R', ' ', ' ', ' ', ' ', ' ', ' ',' ',' ';
% % %     'R', ' ', ' ', ' ', ' ', ' ', ' ',' ',' ';
% % %     'R', 'R', 'R', doxydatamode, ' ', ' ', ' ', ' ', ' ';
% % %     'R', 'R', 'R', 'R', 'R', 'R',phdatamode, ' ', ' ';
% % %     'R', 'R', chladatamode, 'R', bbpdatamode, ' ', cdomdatamode, ' ', ' ';
% % %     'R', 'R', irr380datamode, 'R', irr412datamode, 'R', irr380datamode, 'R',pardatamode;
% % %     'R', 'R', 'R', nidatamode, ' ', ' ', ' ', ' ', ' '];


DOXsDM = ['R', 'R', 'R', doxydatamode];
if exist('phdatamode') %may not exist if sensor turned off!
    PHsDM = ['R', 'R', 'R', 'R', 'R', 'R',phdatamode];
else
    PHsDM = ['R', 'R', 'R', 'R', 'R', 'R', 'R']; %placeholder, won't get used if sensor turned off
end
ECOsDM = ['R', 'R', chladatamode, chlaFdatamode, 'R', bbpdatamode, 'R', cdomdatamode];
OCRsDM = ['R', 'R', irr380datamode, 'R', irr412datamode, 'R', irr380datamode, 'R',pardatamode];
NO3sDM = ['R', 'R', 'R', nidatamode];
mywritesDM = {DOXsDM,PHsDM,ECOsDM,OCRsDM,NO3sDM};
% param_datamode = strings(100);
tmp = cell(5,1);
for ii4 = 1:length(fullsensors)
    theind = FULLinds(ii4);
    if theind>0
        tmp{ii4} = [tmp{ii4} mywritesDM{ii4}];
        %         param_datamode(theind,:) = tmp{ii4,:};
    end
end
IndexI = find((cellfun('isempty',tmp)));
tmp(IndexI) = []; %remove empties (ie for turned off sensors)
tmp = pad(tmp);
if ~isempty(mytemp)
    param_datamode(1,:) = ['R', repmat(' ',1,lL)];
    param_datamode(2,:) = ['R', repmat(' ',1,lL)];
    for ii5 = 1:size(tmp,1)
        param_datamode(ii5+2,:) = tmp{ii5};
    end
else
    param_datamode(1,:) = ['R', repmat(' ',1,lL)];
    for ii5 = 1:size(tmp,1)
        param_datamode(ii5+1,:) = tmp{ii5};
    end
end
%%%%%%% TANYA: 6/21 -- FINISHED THE DATAMODE DEFINITIONS.  MOVE ON TO BELOW!!!
%%
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% COMPLETE ALL ENTRIES (I-PARAM, B-PARAM, RAW&ADJUSTED&QC FIELDS) EXCEPT
% OCR (SAVING THOSE PARAMS FOR LAST AS THEY ARE NUMEROUS)
% all I-Argo param_qc are filled with '0' ------
% all B-Argo param_qc are assigned by MBARI ------


% create variables that assign the proper pressure axis for each bgc
% variable.  Axes 0 & 1 are for hr,lr ctd.
% TM 6/22/22 - these are now defined dynamically in MBARImat_to_ARGOb.
% % dox_ax = 2;
% % ph_ax = 3;
% % eco_ax = 4;
% % ocr_ax = 5;
% % nit_ax = 6;

% OK, trying to move away from using the eval function at multiple locations even though I love it!  Create a new cell
% array holding each BGC structure and access as needed, depending on
% index/axis for each bgc variable.  Max possible is 5 BGC axes.
% Remember, we've stored the pressure axis index for each BGC in the
% variable FULLinds.  This is of length 5, each entry corresponding to each
% bgc axis index (if any of them does not exist due to ie turned off sensor
% or what not, then the entry will be nan).  {'DOX','ALK','ECO','OCR','NO3'};
%
for imybgc = 1:MB.INFO.bgc_pres_axes_ct
    eval(['MYBGC{imybgc} = MB.BGC0',num2str(imybgc),';']);
end

%% DOXY FIELDS-------------------------------------------------------------
if FULLinds(1)>0 %doxy data exists
    temp_doxy=MYBGC{FULLinds(1)-myindtmp}.TEMP_DOXY;
    ii=find(temp_doxy>99998);
    temp_doxy(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'TEMP_DOXY');
    netcdf.putVar(fid, varid, [0 dox_ax], [nbgcres(dox_ax-myindtmp+1,1) 1], temp_doxy);

    temp_doxy_qc=num2str(zeros(nbgcres(dox_ax-myindtmp+1,1),1));
    temp_doxy_qc(ii)='9';
    varid=netcdf.inqVarID(fid,'TEMP_DOXY_QC');
    netcdf.putVar(fid, varid, [0 dox_ax], [nbgcres(dox_ax-myindtmp+1,1) 1], temp_doxy_qc);

    phase_delay_doxy=MYBGC{FULLinds(1)-myindtmp}.PHASE_DELAY_DOXY;
    ii=find(phase_delay_doxy>99998);
    phase_delay_doxy(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'PHASE_DELAY_DOXY');
    netcdf.putVar(fid, varid, [0 dox_ax], [nbgcres(dox_ax-myindtmp+1,1) 1], phase_delay_doxy);

    phase_delay_doxy_qc=num2str(zeros(nbgcres(dox_ax-myindtmp+1,1),1));
    phase_delay_doxy_qc(ii)='9';
    varid=netcdf.inqVarID(fid,'PHASE_DELAY_DOXY_QC');
    netcdf.putVar(fid, varid, [0 dox_ax], [nbgcres(dox_ax-myindtmp+1,1) 1], phase_delay_doxy_qc);

    doxy=MYBGC{FULLinds(1)-myindtmp}.DOXY;
    ii=find(doxy>99998);
    doxy(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'DOXY');
    netcdf.putVar(fid, varid, [0 dox_ax], [nbgcres(dox_ax-myindtmp+1,1) 1], doxy);

    jj=find(MYBGC{FULLinds(1)-myindtmp}.DOXY_QC==99);
    if(length(jj)==nbgcres(dox_ax-myindtmp+1,1) & length(ii)==nbgcres(dox_ax-myindtmp+1,1))
        disp(strcat('no DOXY in cast :', num2str(INFO.cast)));
        doxy_qc=num2str(ones(nbgcres(dox_ax-myindtmp+1,1),1).*9);
    else
        MYBGC{FULLinds(1)-myindtmp}.DOXY_QC(ii)=9;
        doxy_qc=num2str(MYBGC{FULLinds(1)-myindtmp}.DOXY_QC);
    end
    varid=netcdf.inqVarID(fid,'DOXY_QC');
    netcdf.putVar(fid, varid, [0 dox_ax], [nbgcres(dox_ax-myindtmp+1,1) 1], doxy_qc);

    %doxy adjusted fields
    doxy_adj=MYBGC{FULLinds(1)-myindtmp}.DOXY_ADJUSTED;
    ii=find(doxy_adj>99998);

    jj=find(MYBGC{FULLinds(1)-myindtmp}.DOXY_ADJUSTED_QC==99);
    if(length(jj)==nbgcres(dox_ax-myindtmp+1,1) & length(ii)==nbgcres(dox_ax-myindtmp+1,1))
        disp(strcat('no DOXY_ADJUSTED in cast :', num2str(INFO.cast)));
        doxydatamode='R';
    else
        MYBGC{FULLinds(1)-myindtmp}.DOXY_ADJUSTED_QC(ii)=9;
        doxy_adj_qc=num2str(MYBGC{FULLinds(1)-myindtmp}.DOXY_ADJUSTED_QC);
        %varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_QC');
        %netcdf.putVar(fid, varid, [0 dox_ax], [nbgcres(dox_ax-myindtmp+1,1) 1], doxy_adj_qc);

        kk=find(doxy_adj_qc=='4');
        doxy_adj(ii)=fillfloat; % qc='9'
        if(doxydatamode=='D') || (doxydatamode=='A')
            doxy_adj(kk)=fillfloat; % qc='4'
            % 			doxy_adj_qc(kk)='9'; % qc='4'
        end
        varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED');
        netcdf.putVar(fid, varid, [0 dox_ax], [nbgcres(dox_ax-myindtmp+1,1) 1], doxy_adj);
        varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_QC');
        netcdf.putVar(fid, varid, [0 dox_ax], [nbgcres(dox_ax-myindtmp+1,1) 1], doxy_adj_qc);

        doxy_adj_error=MYBGC{FULLinds(1)-myindtmp}.DOXY_ADJUSTED_ERROR;
        doxy_adj_error(ii)=fillfloat; % qc='9'
        if(doxydatamode=='D')
            doxy_adj_error(kk)=fillfloat; % qc='4'
        end
        varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_ERROR');
        netcdf.putVar(fid, varid, [0 dox_ax], [nbgcres(dox_ax-myindtmp+1,1) 1], doxy_adj_error);
    end
end

%% FLBB FIELDS-------------------------------------------------------------

if FULLinds(3)>0 %eco data exists

    fluorescence_chla=MYBGC{FULLinds(3)-myindtmp}.FLUORESCENCE_CHLA;
    ii=find(fluorescence_chla>99998);
    fluorescence_chla(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'FLUORESCENCE_CHLA');
    nbgcres
    eco_ax
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], fluorescence_chla);

    fluo_chla_qc=num2str(zeros(nbgcres(eco_ax-myindtmp+1,1),1));
    fluo_chla_qc(ii)='9';
    varid=netcdf.inqVarID(fid,'FLUORESCENCE_CHLA_QC');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], fluo_chla_qc);

	%chla
    chla=MYBGC{FULLinds(3)-myindtmp}.CHLA;
    ii=find(chla>99998);
    chla(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'CHLA');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chla);

    jj=find(MYBGC{FULLinds(3)-myindtmp}.CHLA_QC==99);
    if(length(jj)==nbgcres(eco_ax-myindtmp+1,1) & length(ii)==nbgcres(eco_ax-myindtmp+1,1))
        disp(strcat('no CHLA in cast :', num2str(INFO.cast)));
        chla_qc=num2str(ones(nbgcres(eco_ax-myindtmp+1,1),1).*9);
    else
        MYBGC{FULLinds(3)-myindtmp}.CHLA_QC(ii)=9;
        chla_qc=num2str(MYBGC{FULLinds(3)-myindtmp}.CHLA_QC);
    end
    varid=netcdf.inqVarID(fid,'CHLA_QC');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chla_qc);
	
	%chlaFluorescence
	chlaF=MYBGC{FULLinds(3)-myindtmp}.CHLA_FLUORESCENCE;
    ii=find(chlaF>99998);
    chlaF(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chlaF);

    jj=find(MYBGC{FULLinds(3)-myindtmp}.CHLA_FLUORESCENCE_QC==99);
    if(length(jj)==nbgcres(eco_ax-myindtmp+1,1) & length(ii)==nbgcres(eco_ax-myindtmp+1,1))
        disp(strcat('no CHLA_FLUORESCENCE in cast :', num2str(INFO.cast)));
        chlaF_qc=num2str(ones(nbgcres(eco_ax-myindtmp+1,1),1).*9);
    else
        MYBGC{FULLinds(3)-myindtmp}.CHLA_FLUORESCENCE_QC(ii)=9;
        chlaF_qc=num2str(MYBGC{FULLinds(3)-myindtmp}.CHLA_FLUORESCENCE_QC);
    end
    varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE_QC');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chlaF_qc);

	%bbp700
    beta_backscattering700=MYBGC{FULLinds(3)-myindtmp}.BETA_BACKSCATTERING700;
    ii=find(beta_backscattering700>99998);
    beta_backscattering700(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'BETA_BACKSCATTERING700');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], beta_backscattering700);

    beta_bbp700_qc=num2str(zeros(nbgcres(eco_ax-myindtmp+1,1),1));
    beta_bbp700_qc(ii)='9';
    varid=netcdf.inqVarID(fid,'BETA_BACKSCATTERING700_QC');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], beta_bbp700_qc);

    bbp700=MYBGC{FULLinds(3)-myindtmp}.BBP700;
    ii=find(bbp700>99998);
    bbp700(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'BBP700');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], bbp700);

    jj=find(MYBGC{FULLinds(3)-myindtmp}.BBP700_QC==99);
    if(length(jj)==nbgcres(eco_ax-myindtmp+1,1) & length(ii)==nbgcres(eco_ax-myindtmp+1,1))
        disp(strcat('no BBP700 in cast :', num2str(INFO.cast)));
        bbp700_qc=num2str(ones(nbgcres(eco_ax-myindtmp+1,1),1).*9);
    else
        MYBGC{FULLinds(3)-myindtmp}.BBP700_QC(ii)=9;
        bbp700_qc=num2str(MYBGC{FULLinds(3)-myindtmp}.BBP700_QC);
    end
    varid=netcdf.inqVarID(fid,'BBP700_QC');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], bbp700_qc);

    fluorescence_cdom=[MYBGC{FULLinds(3)-myindtmp}.FLUORESCENCE_CDOM];
    ii=find(fluorescence_cdom>99998);
    fluorescence_cdom(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'FLUORESCENCE_CDOM');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], fluorescence_cdom);

    fluo_cdom_qc=num2str(zeros(nbgcres(eco_ax-myindtmp+1,1),1));
    fluo_cdom_qc(ii)='9';
    varid=netcdf.inqVarID(fid,'FLUORESCENCE_CDOM_QC');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], fluo_cdom_qc);

    cdom=[MYBGC{FULLinds(3)-myindtmp}.CDOM];
    ii=find(cdom>99998);
    cdom(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'CDOM');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], cdom);

    ncdom_qc=[MYBGC{FULLinds(3)-myindtmp}.CDOM_QC];
    jj=find(ncdom_qc==99);
    if(length(jj)==nbgcres(eco_ax-myindtmp+1,1) & length(ii)==nbgcres(eco_ax-myindtmp+1,1))
        disp(strcat('no CDOM in cast :', num2str(INFO.cast)));
        cdom_qc=num2str(ones(nbgcres(eco_ax-myindtmp+1,1),1).*9);
    else
        ncdom_qc(ii)=9;
        cdom_qc=num2str(ncdom_qc);
    end
    varid=netcdf.inqVarID(fid,'CDOM_QC');
    netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], cdom_qc);

	%chla_adjusted
    chla_adj=MYBGC{FULLinds(3)-myindtmp}.CHLA_ADJUSTED;
    ii=find(chla_adj>99998);

    jj=find(MYBGC{FULLinds(3)-myindtmp}.CHLA_ADJUSTED_QC==99);
    if(length(jj)==nbgcres(eco_ax-myindtmp+1,1) & length(ii)==nbgcres(eco_ax-myindtmp+1,1))
        disp(strcat('no CHLA_ADJUSTED in cast :', num2str(INFO.cast)));
    else
        MYBGC{FULLinds(3)-myindtmp}.CHLA_ADJUSTED_QC(ii)=9;
        chla_adj_qc=num2str(MYBGC{FULLinds(3)-myindtmp}.CHLA_ADJUSTED_QC);
        %varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED_QC');
        %netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chla_adj_qc);

        kk=find(chla_adj_qc=='4');
        chla_adj(ii)=fillfloat; % qc='9'
        if(chladatamode=='D')
            chla_adj(kk)=fillfloat; % qc='4'
            % 			chla_adj_qc(kk)='9'; % qc='4'
        end
        varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED');
        netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chla_adj);
        varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED_QC');
        netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chla_adj_qc);

        chla_adj_error=MYBGC{FULLinds(3)-myindtmp}.CHLA_ADJUSTED_ERROR;
        chla_adj_error(ii)=fillfloat; % qc='9'
        if(chladatamode=='D')
            chla_adj_error(kk)=fillfloat; % qc='4'
        end
        varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED_ERROR');
        netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chla_adj_error);
    end
	
	%chla_fluorescence_adjusted
    chlaF_adj=MYBGC{FULLinds(3)-myindtmp}.CHLA_FLUORESCENCE_ADJUSTED;
    ii=find(chlaF_adj>99998);

    jj=find(MYBGC{FULLinds(3)-myindtmp}.CHLA_FLUORESCENCE_ADJUSTED_QC==99);
    if(length(jj)==nbgcres(eco_ax-myindtmp+1,1) & length(ii)==nbgcres(eco_ax-myindtmp+1,1))
        disp(strcat('no CHLA_FLUORESCENCE_ADJUSTED in cast :', num2str(INFO.cast)));
    else
        MYBGC{FULLinds(3)-myindtmp}.CHLA_FLUORESCENCE_ADJUSTED_QC(ii)=9;
        chlaF_adj_qc=num2str(MYBGC{FULLinds(3)-myindtmp}.CHLA_FLUORESCENCE_ADJUSTED_QC);
        %varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE_ADJUSTED_QC');
        %netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chlaF_adj_qc);

        kk=find(chlaF_adj_qc=='4');
        chlaF_adj(ii)=fillfloat; % qc='9'
        if(chlaFdatamode=='D')
            chlaF_adj(kk)=fillfloat; % qc='4'
            % 			chlaF_adj_qc(kk)='9'; % qc='4'
        end
        varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE_ADJUSTED');
        netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chlaF_adj);
        varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE_ADJUSTED_QC');
        netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chlaF_adj_qc);

        chlaF_adj_error=MYBGC{FULLinds(3)-myindtmp}.CHLA_FLUORESCENCE_ADJUSTED_ERROR;
        chlaF_adj_error(ii)=fillfloat; % qc='9'
        if(chlaFdatamode=='D')
            chlaF_adj_error(kk)=fillfloat; % qc='4'
        end
        varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE_ADJUSTED_ERROR');
        netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], chlaF_adj_error);
    end

	%bbp700_adjusted
    bbp700_adj=MYBGC{FULLinds(3)-myindtmp}.BBP700_ADJUSTED;
    ii=find(bbp700_adj>99998);

    jj=find(MYBGC{FULLinds(3)-myindtmp}.BBP700_ADJUSTED_QC==99);
    if(length(jj)==nbgcres(eco_ax-myindtmp+1,1) & length(ii)==nbgcres(eco_ax-myindtmp+1,1))
        disp(strcat('no BBP700_ADJUSTED in cast :', num2str(INFO.cast)));
    else
        MYBGC{FULLinds(3)-myindtmp}.BBP700_ADJUSTED_QC(ii)=9;
        bbp700_adj_qc=num2str(MYBGC{FULLinds(3)-myindtmp}.BBP700_ADJUSTED_QC);
        % varid=netcdf.inqVarID(fid,'BBP700_ADJUSTED_QC');
        % netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], bbp700_adj_qc);

        kk=find(bbp700_adj_qc=='4');
        bbp700_adj(ii)=fillfloat; % qc='9'
        if(bbpdatamode=='D')
            bbp700_adj(kk)=fillfloat; % qc='4'
            bbp700_adj_qc(kk)=9; % qc='4'
        end
        varid=netcdf.inqVarID(fid,'BBP700_ADJUSTED');
        netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], bbp700_adj);
        varid=netcdf.inqVarID(fid,'BBP700_ADJUSTED_QC');
        netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], bbp700_adj_qc);

        bbp700_adj_error=MYBGC{FULLinds(3)-myindtmp}.BBP700_ADJUSTED_ERROR;
        bbp700_adj_error(ii)=fillfloat; % qc='9'
        if(bbpdatamode=='D')
            bbp700_adj_error(kk)=fillfloat; % qc='4'
        end
        varid=netcdf.inqVarID(fid,'BBP700_ADJUSTED_ERROR');
        netcdf.putVar(fid, varid, [0 eco_ax], [nbgcres(eco_ax-myindtmp+1,1) 1], bbp700_adj_error);
    end
end

%% PH FIELDS-------------------------------------------------------------

if FULLinds(2)>0 %pH data exists

    vrs_ph=MYBGC{FULLinds(2)-myindtmp}.VRS_PH;
    ii=find(vrs_ph>99998);
    vrs_ph(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'VRS_PH');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], vrs_ph);

    vrs_ph_qc=num2str(zeros(nbgcres(ph_ax-myindtmp+1,1),1));
    vrs_ph_qc(ii)='9';
    varid=netcdf.inqVarID(fid,'VRS_PH_QC');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], vrs_ph_qc);

    ib_ph=MYBGC{FULLinds(2)-myindtmp}.IB_PH;
    ii=find(ib_ph>99998);
    ib_ph(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'IB_PH');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ib_ph);

    ib_ph_qc=num2str(zeros(nbgcres(ph_ax-myindtmp+1,1),1));
    ib_ph_qc(ii)=' ';
    varid=netcdf.inqVarID(fid,'IB_PH_QC');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ib_ph_qc);

    ik_ph=MYBGC{FULLinds(2)-myindtmp}.IK_PH;
    ii=find(ik_ph>99998);
    ik_ph(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'IK_PH');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ik_ph);

    ik_ph_qc=num2str(zeros(nbgcres(ph_ax-myindtmp+1,1),1));
    ik_ph_qc(ii)=' ';
    varid=netcdf.inqVarID(fid,'IK_PH_QC');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ik_ph_qc);

    vk_ph=MYBGC{FULLinds(2)-myindtmp}.VK_PH;
    ii=find(vk_ph>99998);
    vk_ph(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'VK_PH');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], vk_ph);

    vk_ph_qc=num2str(zeros(nbgcres(ph_ax-myindtmp+1,1),1));
    vk_ph_qc(ii)=' ';
    varid=netcdf.inqVarID(fid,'VK_PH_QC');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], vk_ph_qc);

    ph_in_situ_free=MYBGC{FULLinds(2)-myindtmp}.PH_IN_SITU_FREE;
    ii=find(ph_in_situ_free>99998);
    ph_in_situ_free(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'PH_IN_SITU_FREE');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ph_in_situ_free);

    ph_in_situ_free_qc=num2str(zeros(nbgcres(ph_ax-myindtmp+1,1),1));
    ph_in_situ_free_qc(ii)='9';
    varid=netcdf.inqVarID(fid,'PH_IN_SITU_FREE_QC');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ph_in_situ_free_qc);

    ph_in_situ_total=MYBGC{FULLinds(2)-myindtmp}.PH_IN_SITU_TOTAL;
    ii=find(ph_in_situ_total>99998);
    ph_in_situ_total(ii)=fillfloat;
    varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ph_in_situ_total);

    jj=find(MYBGC{FULLinds(2)-myindtmp}.PH_IN_SITU_TOTAL_QC==99);
    if(length(jj)==nbgcres(ph_ax-myindtmp+1,1) & length(ii)==nbgcres(ph_ax-myindtmp+1,1))
        disp(strcat('no PH_IN_SITU_TOTAL in cast :', num2str(INFO.cast)));
        ph_in_situ_total_qc=num2str(ones(nbgcres(ph_ax-myindtmp+1,1),1).*9);
    else
        MYBGC{FULLinds(2)-myindtmp}.PH_IN_SITU_TOTAL_QC(ii)=9;
        ph_in_situ_total_qc=num2str(MYBGC{FULLinds(2)-myindtmp}.PH_IN_SITU_TOTAL_QC);
    end
    varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_QC');
    netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ph_in_situ_total_qc);

    ph_in_situ_total_adj=MYBGC{FULLinds(2)-myindtmp}.PH_IN_SITU_TOTAL_ADJUSTED;
    ii=find(ph_in_situ_total_adj>99998);

    jj=find(MYBGC{FULLinds(2)-myindtmp}.PH_IN_SITU_TOTAL_ADJUSTED_QC==99);
    if(length(jj)==nbgcres(ph_ax-myindtmp+1,1) & length(ii)==nbgcres(ph_ax-myindtmp+1,1))
        disp(strcat('no PH_IN_SITU_TOTAL_ADJUSTED in cast :', num2str(INFO.cast)));
        phdatamode='R';
    else
        MYBGC{FULLinds(2)-myindtmp}.PH_IN_SITU_TOTAL_ADJUSTED_QC(ii)=9;
        ph_in_situ_total_adj_qc=num2str(MYBGC{FULLinds(2)-myindtmp}.PH_IN_SITU_TOTAL_ADJUSTED_QC);
        %varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED_QC');
        %netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ph_in_situ_total_adj_qc);

        kk=find(ph_in_situ_total_adj_qc=='4');
        ph_in_situ_total_adj(ii)=fillfloat; % qc='9'
        if(phdatamode=='D')
            ph_in_situ_total_adj(kk)=fillfloat; % qc='4'
            % 			ph_in_situ_total_adj_qc(kk)='9';
        end
        varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED');
        netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ph_in_situ_total_adj);
        varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED_QC');
        netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ph_in_situ_total_adj_qc);

        ph_in_situ_total_adj_error=MYBGC{FULLinds(2)-myindtmp}.PH_IN_SITU_TOTAL_ADJUSTED_ERROR;
        ph_in_situ_total_adj_error(ii)=fillfloat; % qc='9'
        if(phdatamode=='D')
            ph_in_situ_total_adj_error(kk)=fillfloat; % qc='4'
        end
        varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED_ERROR');
        netcdf.putVar(fid, varid, [0 ph_ax], [nbgcres(ph_ax-myindtmp+1,1) 1], ph_in_situ_total_adj_error);
    end
end

%% NO3 FIELDS-------------------------------------------------------------

if FULLinds(5)>0 %no3 data exists

    uv_intensity_dark_nitrate=MYBGC{FULLinds(5)-myindtmp}.UV_INTENSITY_DARK_NITRATE;
    if ~isempty(uv_intensity_dark_nitrate)
        ii=find(uv_intensity_dark_nitrate>99998);
        uv_intensity_dark_nitrate(ii)=fillfloat;
        varid=netcdf.inqVarID(fid,'UV_INTENSITY_DARK_NITRATE');
        netcdf.putVar(fid, varid, [0 nit_ax], [nbgcres(nit_ax-myindtmp+1,1) 1], uv_intensity_dark_nitrate);

        uv_intensity_dark_nitrate_qc=num2str(zeros(nbgcres(nit_ax-myindtmp+1,1),1));
        uv_intensity_dark_nitrate_qc(ii)='9';
        varid=netcdf.inqVarID(fid,'UV_INTENSITY_DARK_NITRATE_QC');
        netcdf.putVar(fid, varid, [0 nit_ax], [nbgcres(nit_ax-myindtmp+1,1) 1], uv_intensity_dark_nitrate_qc);

        uv_intensity_nitrate=MYBGC{FULLinds(5)-myindtmp}.UV_INTENSITY_NITRATE;
        varid=netcdf.inqVarID(fid,'UV_INTENSITY_NITRATE');
        if(nvalues>1)
            ii=[];
            for j=1:nbgcres(nit_ax-myindtmp+1,1)
                uvn=uv_intensity_nitrate(j,:);
                kk=find(uvn>99998);
                if(length(kk)==nvalues)ii=[ii,j];end
                uvn(kk)=fillfloat;
                netcdf.putVar(fid, varid, [0 j-1 nit_ax], [nvalues 1 1], uvn);
            end
        elseif(nvalues==1)
            ii=find(uv_intensity_nitrate>99998);
            uv_intensity_nitrate(ii)=fillfloat;
            netcdf.putVar(fid, varid, [0 nit_ax], [nbgcres(nit_ax-myindtmp+1,1) 1], uv_intensity_nitrate);
        end

        uv_intensity_nitrate_qc=num2str(zeros(nbgcres(nit_ax-myindtmp+1,1),1));
        uv_intensity_nitrate_qc(ii)='9';
        varid=netcdf.inqVarID(fid,'UV_INTENSITY_NITRATE_QC');
        netcdf.putVar(fid, varid, [0 nit_ax], [nbgcres(nit_ax-myindtmp+1,1) 1], uv_intensity_nitrate_qc);

        nitrate=MYBGC{FULLinds(5)-myindtmp}.NITRATE;
        ii=find(nitrate>99998);
        nitrate(ii)=fillfloat;
        varid=netcdf.inqVarID(fid,'NITRATE');
        netcdf.putVar(fid, varid, [0 nit_ax], [nbgcres(nit_ax-myindtmp+1,1) 1], nitrate);

        jj=find(MYBGC{FULLinds(5)-myindtmp}.NITRATE_QC==99);
        if(length(jj)==nbgcres(nit_ax-myindtmp+1,1) & length(ii)==nbgcres(nit_ax-myindtmp+1,1))
            disp(strcat('no NITRATE in cast :', num2str(INFO.cast)));
            nitrate_qc=num2str(ones(nbgcres(nit_ax-myindtmp+1,1),1).*9);
        else
            MYBGC{FULLinds(5)-myindtmp}.NITRATE_QC(ii)=9;
            nitrate_qc=num2str(MYBGC{FULLinds(5)-myindtmp}.NITRATE_QC);
        end
        varid=netcdf.inqVarID(fid,'NITRATE_QC');
        netcdf.putVar(fid, varid, [0 nit_ax], [nbgcres(nit_ax-myindtmp+1,1) 1], nitrate_qc);

        nitrate_adj=MYBGC{FULLinds(5)-myindtmp}.NITRATE_ADJUSTED;
        ii=find(nitrate_adj>99998);

        jj=find(MYBGC{FULLinds(5)-myindtmp}.NITRATE_ADJUSTED_QC==99);
        if(length(jj)==nbgcres(nit_ax-myindtmp+1,1) & length(ii)==nbgcres(nit_ax-myindtmp+1,1))
            disp(strcat('no NITRATE_ADJUSTED in cast :', num2str(INFO.cast)));
            nidatamode='R';
        else
            MYBGC{FULLinds(5)-myindtmp}.NITRATE_ADJUSTED_QC(ii)=9;
            nitrate_adj_qc=num2str(MYBGC{FULLinds(5)-myindtmp}.NITRATE_ADJUSTED_QC);
            %varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED_QC');
            %netcdf.putVar(fid, varid, [0 nit_ax], [nbgcres(nit_ax-myindtmp+1,1) 1], nitrate_adj_qc);

            kk=find(nitrate_adj_qc=='4');
            nitrate_adj(ii)=fillfloat; % qc='9'
            if(nidatamode=='D')
                nitrate_adj(kk)=fillfloat; % qc='4'
                % 				nitrate_adj_qc(kk)='9'; % qc='4'
            end
            varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED');
            netcdf.putVar(fid, varid, [0 nit_ax], [nbgcres(nit_ax-myindtmp+1,1) 1], nitrate_adj);
            varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED_QC');
            netcdf.putVar(fid, varid, [0 nit_ax], [nbgcres(nit_ax-myindtmp+1,1) 1], nitrate_adj_qc);


            nitrate_adj_error=MYBGC{FULLinds(5)-myindtmp}.NITRATE_ADJUSTED_ERROR;
            nitrate_adj_error(ii)=fillfloat; % qc='9'
            if(nidatamode=='D')
                nitrate_adj_error(kk)=fillfloat; % qc='4'
            end
            varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED_ERROR');
            netcdf.putVar(fid, varid, [0 nit_ax], [nbgcres(nit_ax-myindtmp+1,1) 1], nitrate_adj_error);
        end
    end
end


%%
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% COMPLETE ALL OCR ENTRIES (I-PARAM, B-PARAM, RAW&ADJUSTED&QC FIELDS) AT
% THE END AS THEY ARE VERY LENGTHY!

if FULLinds(4)>0 %ocr data exists
    temp_irr380=MYBGC{FULLinds(4)-myindtmp}.RAW_DOWNWELLING_IRRADIANCE380;
    if ~isempty(temp_irr380) %ie 0001 cycle 47....
        %ii=find(temp_irr380>99998);
        %temp_irr380(ii)=fillfloat;
        varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE380');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], temp_irr380);

        temp_irr380_qc=num2str(zeros(nbgcres(ocr_ax-myindtmp+1,1),1));
        %temp_irr380_qc(ii)='9';
        varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE380_QC');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], temp_irr380_qc);

        temp_irr412=MYBGC{FULLinds(4)-myindtmp}.RAW_DOWNWELLING_IRRADIANCE412;
        %ii=find(temp_irr412>99998);
        %temp_irr412(ii)=fillfloat;
        varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE412');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], temp_irr412);

        temp_irr412_qc=num2str(zeros(nbgcres(ocr_ax-myindtmp+1,1),1));
        %temp_irr412_qc(ii)='9';
        varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE412_QC');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], temp_irr412_qc);

        temp_irr490=MYBGC{FULLinds(4)-myindtmp}.RAW_DOWNWELLING_IRRADIANCE490;
        %ii=find(temp_irr490>99998);
        %temp_irr490(ii)=fillfloat;
        varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE490');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], temp_irr490);

        temp_irr490_qc=num2str(zeros(nbgcres(ocr_ax-myindtmp+1,1),1));
        %temp_irr490_qc(ii)='9';
        varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE490_QC');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], temp_irr490_qc);

        temp_dwpar=MYBGC{FULLinds(4)-myindtmp}.RAW_DOWNWELLING_PAR;
        %ii=find(temp_dwpar>99998);
        %temp_dwpar(ii)=fillfloat;
        varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_PAR');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], temp_dwpar);

        temp_dwpar_qc=num2str(zeros(nbgcres(ocr_ax-myindtmp+1,1),1));
        %temp_dwpar_qc(ii)='9';
        varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_PAR_QC');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], temp_dwpar_qc);

        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        % WRITE ALL OFFICIAL BPARAMS (4 FOR OCR!)
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        % 1) FIRST BPARAM = DOWN_IRRADIANCE380---------------------------------------------------------------------------------------------------------------------------------------------
        ocr380=MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE380;
        ii=find(ocr380>99998);
        ocr380(ii)=fillfloat;
        varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr380);

        jj=find(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE380_QC==99);
        if(length(jj)==nbgcres(ocr_ax-myindtmp+1,1) & length(ii)==nbgcres(ocr_ax-myindtmp+1,1))
            disp(strcat('no DOWN IRRADIANCE 380 in cast :', num2str(INFO.cast)));
            ocr380_qc=num2str(ones(nbgcres(ocr_ax-myindtmp+1,1),1).*9);
        else
            MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE380_QC(ii)=9;
            ocr380_qc=num2str(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE380_QC);
        end
        varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380_QC');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr380_qc);

        % write bgc adjusted data, error, and qc flags to nprof2 ------

        ocr380_adj=MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE380_ADJUSTED;
        ii=find(ocr380_adj>99998);

        jj=find(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE380_ADJUSTED_QC==99);
        if(length(jj)==nbgcres(ocr_ax-myindtmp+1,1) & length(ii)==nbgcres(ocr_ax-myindtmp+1,1))
            disp(strcat('no DOWN_IRRADIANCE380_ADJUSTED in cast :', num2str(INFO.cast)));
        else
            MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE380_ADJUSTED_QC(ii)=9;
            ocr380_adj_qc=num2str(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE380_ADJUSTED_QC);
            %varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380_ADJUSTED_QC');
            %netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr380_adj_qc);

            kk=find(ocr380_adj_qc=='4');
            ocr380_adj(ii)=fillfloat; % qc='9'
            if(irr380datamode=='D')
                ocr380_adj(kk)=fillfloat; % qc='4'
                % 			ocr380_adj_qc(kk)='9'; % qc='4'
            end
            varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380_ADJUSTED');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr380_adj);
    		varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380_ADJUSTED_QC');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr380_adj_qc);

            ocr380_adj_error=MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE380_ADJUSTED_ERROR;
            ocr380_adj_error(ii)=fillfloat; % qc='9'
            if(irr380datamode=='D')
                ocr380_adj_error(kk)=fillfloat; % qc='4'
            end
            varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380_ADJUSTED_ERROR');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr380_adj_error);
        end
        % 2) SECOND BPARAM = DOWN_IRRADIANCE412---------------------------------------------------------------------------------------------------------------------------------------------
        ocr412=MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE412;
        ii=find(ocr412>99998);
        ocr412(ii)=fillfloat;
        varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr412);

        jj=find(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE412_QC==99);
        if(length(jj)==nbgcres(ocr_ax-myindtmp+1,1) & length(ii)==nbgcres(ocr_ax-myindtmp+1,1))
            disp(strcat('no DOWN IRRADIANCE 412 in cast :', num2str(INFO.cast)));
            ocr412_qc=num2str(ones(nbgcres(ocr_ax-myindtmp+1,1),1).*9);
        else
            MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE412_QC(ii)=9;
            ocr412_qc=num2str(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE412_QC);
        end
        varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412_QC');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr412_qc);

        % write bgc adjusted data, error, and qc flags to nprof2 ------

        ocr412_adj=MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE412_ADJUSTED;
        ii=find(ocr412_adj>99998);

        jj=find(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE412_ADJUSTED_QC==99);
        if(length(jj)==nbgcres(ocr_ax-myindtmp+1,1) & length(ii)==nbgcres(ocr_ax-myindtmp+1,1))
            disp(strcat('no DOWN_IRRADIANCE412_ADJUSTED in cast :', num2str(INFO.cast)));
        else
            MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE412_ADJUSTED_QC(ii)=9;
            ocr412_adj_qc=num2str(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE412_ADJUSTED_QC);
            %varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412_ADJUSTED_QC');
            %netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr412_adj_qc);

            kk=find(ocr412_adj_qc=='4');
            ocr412_adj(ii)=fillfloat; % qc='9'
            if(irr412datamode=='D')
                ocr412_adj(kk)=fillfloat; % qc='4'
                % 			ocr412_adj_qc(kk)='9'; % qc='4'
            end
            varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412_ADJUSTED');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr412_adj);
    		varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412_ADJUSTED_QC');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr412_adj_qc);

            ocr412_adj_error=MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE412_ADJUSTED_ERROR;
            ocr412_adj_error(ii)=fillfloat; % qc='9'
            if(irr412datamode=='D')
                ocr412_adj_error(kk)=fillfloat; % qc='4'
            end
            varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412_ADJUSTED_ERROR');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr412_adj_error);
        end
        % 3) THIRD BPARAM = DOWN_IRRADIANCE490---------------------------------------------------------------------------------------------------------------------------------------------
        ocr490=MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE490;
        ii=find(ocr490>99998);
        ocr490(ii)=fillfloat;
        varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr490);

        jj=find(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE490_QC==99);
        if(length(jj)==nbgcres(ocr_ax-myindtmp+1,1) & length(ii)==nbgcres(ocr_ax-myindtmp+1,1))
            disp(strcat('no DOWN IRRADIANCE 490 in cast :', num2str(INFO.cast)));
            ocr490_qc=num2str(ones(nbgcres(ocr_ax-myindtmp+1,1),1).*9);
        else
            MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE490_QC(ii)=9;
            ocr490_qc=num2str(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE490_QC);
        end
        varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490_QC');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr490_qc);

        % write bgc adjusted data, error, and qc flags to nprof2 ------

        ocr490_adj=MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE490_ADJUSTED;
        ii=find(ocr490_adj>99998);

        jj=find(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE490_ADJUSTED_QC==99);
        %     length(jj)
        %     length(ii)
        %     nbgcres4
        if(length(jj)==nbgcres(ocr_ax-myindtmp+1,1) & length(ii)==nbgcres(ocr_ax-myindtmp+1,1))
            disp(strcat('no DOWN_IRRADIANCE490_ADJUSTED in cast :', num2str(INFO.cast)));
        else
            MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE490_ADJUSTED_QC(ii)=9;
            ocr490_adj_qc=num2str(MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE490_ADJUSTED_QC);
            %varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490_ADJUSTED_QC');
            %netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr490_adj_qc);

            kk=find(ocr490_adj_qc=='4');
            ocr490_adj(ii)=fillfloat; % qc='9'
            if(irr490datamode=='D')
                ocr490_adj(kk)=fillfloat; % qc='4'
                % 			ocr490_adj_qc(kk)='9'; % qc='4'
            end
            varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490_ADJUSTED');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr490_adj);
    		varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490_ADJUSTED_QC');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr490_adj_qc);

            ocr490_adj_error=MYBGC{FULLinds(4)-myindtmp}.DOWN_IRRADIANCE490_ADJUSTED_ERROR;
            ocr490_adj_error(ii)=fillfloat; % qc='9'
            if(irr490datamode=='D')
                ocr490_adj_error(kk)=fillfloat; % qc='4'
            end
            varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490_ADJUSTED_ERROR');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocr490_adj_error);
        end
        % 4) FOURTH BPARAM = DOWNWELLING_PAR---------------------------------------------------------------------------------------------------------------------------------------------
        ocrpar=MYBGC{FULLinds(4)-myindtmp}.DOWNWELLING_PAR;
        ii=find(ocrpar>99998);
        ocrpar(ii)=fillfloat;
        varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocrpar);

        jj=find(MYBGC{FULLinds(4)-myindtmp}.DOWNWELLING_PAR_QC==99);
        if(length(jj)==nbgcres(ocr_ax-myindtmp+1,1) & length(ii)==nbgcres(ocr_ax-myindtmp+1,1))
            disp(strcat('no DOWN IRRADIANCE 380 in cast :', num2str(INFO.cast)));
            ocrpar_qc=num2str(ones(nbgcres(ocr_ax-myindtmp+1,1),1).*9);
        else
            MYBGC{FULLinds(4)-myindtmp}.DOWNWELLING_PAR_QC(ii)=9;
            ocrpar_qc=num2str(MYBGC{FULLinds(4)-myindtmp}.DOWNWELLING_PAR_QC);
        end
        varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR_QC');
        netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocrpar_qc);

        % write bgc adjusted data, error, and qc flags to nprof2 ------

        ocrpar_adj=MYBGC{FULLinds(4)-myindtmp}.DOWNWELLING_PAR_ADJUSTED;
        ii=find(ocrpar_adj>99998);

        jj=find(MYBGC{FULLinds(4)-myindtmp}.DOWNWELLING_PAR_ADJUSTED_QC==99);
        if(length(jj)==nbgcres(ocr_ax-myindtmp+1,1) & length(ii)==nbgcres(ocr_ax-myindtmp+1,1))
            disp(strcat('no DOWNWELLING_PAR_ADJUSTED in cast :', num2str(INFO.cast)));
        else
            MYBGC{FULLinds(4)-myindtmp}.DOWNWELLING_PAR_ADJUSTED_QC(ii)=9;
            ocrpar_adj_qc=num2str(MYBGC{FULLinds(4)-myindtmp}.DOWNWELLING_PAR_ADJUSTED_QC);
            %varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR_ADJUSTED_QC');
            %netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocrpar_adj_qc);

            kk=find(ocrpar_adj_qc=='4');
            ocrpar_adj(ii)=fillfloat; % qc='9'
            if(pardatamode=='D')
                ocrpar_adj(kk)=fillfloat; % qc='4'
                % 			ocrpar_adj_qc(kk)='9'; % qc='4'
            end
            varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocrpar_adj);
    		varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR_ADJUSTED_QC');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocrpar_adj_qc);

            ocrpar_adj_error=MYBGC{FULLinds(4)-myindtmp}.DOWNWELLING_PAR_ADJUSTED_ERROR;
            ocrpar_adj_error(ii)=fillfloat; % qc='9'
            if(pardatamode=='D')
                ocrpar_adj_error(kk)=fillfloat; % qc='4'
            end
            varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR_ADJUSTED_ERROR');
            netcdf.putVar(fid, varid, [0 ocr_ax], [nbgcres(ocr_ax-myindtmp+1,1) 1], ocrpar_adj_error);
        end
    end
end

%%
%--------------------------------------------------------------------------
% set SCIENTIFIC_CALIB entries ------
%--------------------------------------------------------------------------


enough256=num2str(ones(256,1));

junk=char('not applicable',enough256');
nocomment256=junk(1,:);

junk=char('Adjusted values are provided in the core profile file',enough256');
prescomment256=junk(1,:);
varid_sccomP=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COMMENT');
for iAx = 1:nprof %7 pressure axes
    netcdf.putVar(fid, varid_sccomP, [0,0,0,iAx-1], [256,1,1,1], prescomment256);
end
clear iAx

varid_sccom=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COMMENT');
nprof
for iAx = 3:nprof-1
    for i=2:nparam
        netcdf.putVar(fid, varid_sccom, [0,i-1,0,iAx-1], [256,1,1,1], nocomment256);
    end
end
clear iAx i

varid_sceq=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_EQUATION');
for iAx = 3:nprof-1
    for i=2:nparam
        netcdf.putVar(fid, varid_sceq, [0,i-1,0,iAx-1], [256,1,1,1], nocomment256);
    end
end
clear iAx i

varid_sccof=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COEFFICIENT');
for iAx = 3:nprof-1
    for i=2:nparam
        netcdf.putVar(fid, varid_sccof, [0,i-1,0,iAx-1], [256,1,1,1], nocomment256);
    end
end
clear iAx i

varid_dat=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_DATE');


%if(datamode(2)=='A'|datamode(2)=='D') %---only write out sci cal info when datamode='A' or 'D'---

junk=char('not applicable',enough256');
nocomment256=junk(1,:);

if FULLinds(1)>0 %dox data exists
    junk=char(INFO.DOXY_SCI_CAL_EQU,enough256');
    doxy_eqn256=junk(1,:);
    junk=char(INFO.DOXY_SCI_CAL_COEF,enough256');
    doxy_coeff256=junk(1,:);
    junk=char(INFO.DOXY_SCI_CAL_COM,enough256');
    doxy_comment256=junk(1,:);
    netcdf.putVar(fid, varid_sccom, [0,4-1,0,FULLinds(1)-1], [256,1,1,1], doxy_comment256); %doxy
    netcdf.putVar(fid, varid_sceq, [0,4-1,0,FULLinds(1)-1], [256,1,1,1], doxy_eqn256); %doxy
    netcdf.putVar(fid, varid_sccof, [0,4-1,0,FULLinds(1)-1], [256,1,1,1], doxy_coeff256); %doxy
    for i=2:4
        netcdf.putVar(fid, varid_dat, [0,i-1,0,FULLinds(3)-1], [14,1,1,1], writedate);
    end

end

if FULLinds(3)>0 %eco data exists
    junk=char(INFO.CHLA_SCI_CAL_EQU,enough256');
    chla_eqn256=junk(1,:);
    junk=char(INFO.CHLA_SCI_CAL_COEF,enough256');
    chla_coeff256=junk(1,:);
    junk=char(INFO.CHLA_SCI_CAL_COM,enough256');
    chla_comment256=junk(1,:);

    junk=char(INFO.BBP700_SCI_CAL_EQU,enough256');
    bbp700_eqn256=junk(1,:);
    junk=char(INFO.BBP700_SCI_CAL_COEF,enough256');
    bbp700_coeff256=junk(1,:);
    junk=char(INFO.BBP700_SCI_CAL_COM,enough256');
    bbp700_comment256=junk(1,:);

    junk=char(INFO.CDOM_SCI_CAL_EQU,enough256');
    cdom_eqn256=junk(1,:);
    junk=char(INFO.CDOM_SCI_CAL_COEF,enough256');
    cdom_coeff256=junk(1,:);
    junk=char(INFO.CDOM_SCI_CAL_COM,enough256');
    cdom_comment256=junk(1,:);

    netcdf.putVar(fid, varid_sccom, [0,3-1,0,FULLinds(3)-1], [256,1,1,1], chla_comment256); %chla
    netcdf.putVar(fid, varid_sccom, [0,5-1,0,FULLinds(3)-1], [256,1,1,1], bbp700_comment256); %bbp700
    netcdf.putVar(fid, varid_sccom, [0,7-1,0,FULLinds(3)-1], [256,1,1,1], cdom_comment256); %cdom
    netcdf.putVar(fid, varid_sceq, [0,3-1,0,FULLinds(3)-1], [256,1,1,1], chla_eqn256); %chla
    netcdf.putVar(fid, varid_sceq, [0,5-1,0,FULLinds(3)-1], [256,1,1,1], bbp700_eqn256); %bbp700
    netcdf.putVar(fid, varid_sceq, [0,7-1,0,FULLinds(3)-1], [256,1,1,1], cdom_eqn256); %cdom
    netcdf.putVar(fid, varid_sccof, [0,3-1,0,FULLinds(3)-1], [256,1,1,1], chla_coeff256); %chla
    netcdf.putVar(fid, varid_sccof, [0,5-1,0,FULLinds(3)-1], [256,1,1,1], bbp700_coeff256); %bbp700
    netcdf.putVar(fid, varid_sccof, [0,7-1,0,FULLinds(3)-1], [256,1,1,1], cdom_coeff256); %cdom
    for i=2:7
        netcdf.putVar(fid, varid_dat, [0,i-1,0,FULLinds(3)-1], [14,1,1,1], writedate);
    end
end

if FULLinds(2)>0 %ph data exists
    junk=char(INFO.PH_SCI_CAL_EQU,enough256');
    ph_eqn256=junk(1,:);
    junk=char(INFO.PH_SCI_CAL_COEF,enough256');
    ph_coeff256=junk(1,:);
    junk=char(INFO.PH_SCI_CAL_COM,enough256');
    ph_comment256=junk(1,:);

    netcdf.putVar(fid, varid_sccom, [0,7-1,0,FULLinds(2)-1], [256,1,1,1], ph_comment256); %ph
    netcdf.putVar(fid, varid_sceq, [0,7-1,0,FULLinds(2)-1], [256,1,1,1], ph_eqn256); %ph
    netcdf.putVar(fid, varid_sccof, [0,7-1,0,FULLinds(2)-1], [256,1,1,1], ph_coeff256); %ph
    for i=2:7
        netcdf.putVar(fid, varid_dat, [0,i-1,0,FULLinds(2)-1], [14,1,1,1], writedate);
    end

end

if FULLinds(5)>0 %no3 data exists
    junk=char(INFO.NITRATE_SCI_CAL_EQU,enough256');
    ni_eqn256=junk(1,:);
    junk=char(INFO.NITRATE_SCI_CAL_COEF,enough256');
    ni_coeff256=junk(1,:);
    junk=char(INFO.NITRATE_SCI_CAL_COM,enough256');
    ni_comment256=junk(1,:);

    netcdf.putVar(fid, varid_sccom, [0,4-1,0,FULLinds(5)-1], [256,1,1,1], ni_comment256); %nitrate
    netcdf.putVar(fid, varid_sceq, [0,4-1,0,FULLinds(5)-1], [256,1,1,1], ni_eqn256); %nitrate
    netcdf.putVar(fid, varid_sccof, [0,4-1,0,FULLinds(5)-1], [256,1,1,1], ni_coeff256); %nitrate
    for i=2:4
        netcdf.putVar(fid, varid_dat, [0,i-1,0,FULLinds(5)-1], [14,1,1,1], writedate);
    end

end

if FULLinds(4)>0 %ocr data exists
    junk=char(INFO.DOWN_IRRADIANCE380_SCI_CAL_EQU,enough256');
    ocr380_eqn256=junk(1,:);
    junk=char(INFO.DOWN_IRRADIANCE380_SCI_CAL_COEF,enough256');
    ocr380_coeff256=junk(1,:);
    junk=char(INFO.DOWN_IRRADIANCE380_SCI_CAL_COM,enough256');
    ocr380_comment256=junk(1,:);

    junk=char(INFO.DOWN_IRRADIANCE412_SCI_CAL_EQU,enough256');
    ocr412_eqn256=junk(1,:);
    junk=char(INFO.DOWN_IRRADIANCE412_SCI_CAL_COEF,enough256');
    ocr412_coeff256=junk(1,:);
    junk=char(INFO.DOWN_IRRADIANCE412_SCI_CAL_COM,enough256');
    ocr412_comment256=junk(1,:);

    junk=char(INFO.DOWN_IRRADIANCE490_SCI_CAL_EQU,enough256');
    ocr490_eqn256=junk(1,:);
    junk=char(INFO.DOWN_IRRADIANCE490_SCI_CAL_COEF,enough256');
    ocr490_coeff256=junk(1,:);
    junk=char(INFO.DOWN_IRRADIANCE490_SCI_CAL_COM,enough256');
    ocr490_comment256=junk(1,:);

    junk=char(INFO.DOWNWELLING_PAR_SCI_CAL_EQU,enough256');
    ocrpar_eqn256=junk(1,:);
    junk=char(INFO.DOWNWELLING_PAR_SCI_CAL_COEF,enough256');
    ocrpar_coeff256=junk(1,:);
    junk=char(INFO.DOWNWELLING_PAR_SCI_CAL_COM,enough256');
    ocrpar_comment256=junk(1,:);

    netcdf.putVar(fid, varid_sccom, [0,3-1,0,FULLinds(4)-1], [256,1,1,1], ocr380_comment256); %ocr380
    netcdf.putVar(fid, varid_sccom, [0,5-1,0,FULLinds(4)-1], [256,1,1,1], ocr412_comment256); %ocr412
    netcdf.putVar(fid, varid_sccom, [0,7-1,0,FULLinds(4)-1], [256,1,1,1], ocr490_comment256); %ocr490
    netcdf.putVar(fid, varid_sccom, [0,9-1,0,FULLinds(4)-1], [256,1,1,1], ocrpar_comment256); %ocrpar
    netcdf.putVar(fid, varid_sceq, [0,3-1,0,FULLinds(4)-1], [256,1,1,1], ocr380_eqn256); %ocr380
    netcdf.putVar(fid, varid_sceq, [0,5-1,0,FULLinds(4)-1], [256,1,1,1], ocr412_eqn256); %ocr412
    netcdf.putVar(fid, varid_sceq, [0,7-1,0,FULLinds(4)-1], [256,1,1,1], ocr490_eqn256); %ocr490
    netcdf.putVar(fid, varid_sceq, [0,9-1,0,FULLinds(4)-1], [256,1,1,1], ocrpar_eqn256); %ocrpar
    netcdf.putVar(fid, varid_sccof, [0,3-1,0,FULLinds(4)-1], [256,1,1,1], ocr380_coeff256); %ocr380
    netcdf.putVar(fid, varid_sccof, [0,5-1,0,FULLinds(4)-1], [256,1,1,1], ocr412_coeff256); %ocr412
    netcdf.putVar(fid, varid_sccof, [0,7-1,0,FULLinds(4)-1], [256,1,1,1], ocr490_coeff256); %ocr490
    netcdf.putVar(fid, varid_sccof, [0,9-1,0,FULLinds(4)-1], [256,1,1,1], ocrpar_coeff256); %ocrpar
    for i=2:9
        netcdf.putVar(fid, varid_dat, [0,i-1,0,FULLinds(4)-1], [14,1,1,1], writedate);
    end
end


%-------
% TM: 6/22/22: moved this to each param block; hopefully works.  Keep the
% original below for reference for now.
% % % varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_DATE');
% % % nparamax = [3 6 6 8 3]; % N params for each axi
% % % for iAx = 1:5
% % %     Pax = nparamax(iAx);
% % %     for i=2:1+Pax
% % %         netcdf.putVar(fid, varid, [0,i-1,0,iAx+1], [14,1,1,1], writedate);
% % %     end
% % % end


%end %---if datamode(2)=='A' or 'D'


% write DATA_MODE and PARAMETER_DATA_MODE ------

varid=netcdf.inqVarID(fid,'DATA_MODE');


netcdf.putVar(fid, varid, datamode');

varid=netcdf.inqVarID(fid,'PARAMETER_DATA_MODE');
netcdf.putVar(fid, varid, param_datamode');


% close the BR-file ------

netcdf.close(fid);


