%
% This function writes MBARI-processed bgc data into my b-file skeleton with N_PROF=2.
%
% NAVIS "Nautilus"; Iridium with SBE83 (doxy), SUNA (nitrate), DURA (ph), MCOMS (chla & bb & cdom), and OCR (irr380, irr412, irr490, par)
%
% 11 B-Argo parameters:
%         DOXY
%         CHLA
%         CHLA_FLUORESCENCE
%         BBP700
%         CDOM
%         PH_IN_SITU_TOTAL
%         NITRATE
%         DOWNWELLING_PAR
%         DOWN_IRRADIANCE490
%         DOWN_IRRADIANCE412
%         DOWN_IRRADIANCE380
%
% 15 I-Argo parameters:
%         PHASE_DELAY_DOXY
%         TEMP_DOXY
%         TEMP_VOLTAGE_DOXY
%         FLUORESCENCE_CHLA
%         BETA_BACKSCATTERING700
%         FLUORESCENCE_CDOM
%         VRS_PH
%         TEMP_PH
%         PH_IN_SITU_FREE
%         UV_INTENSITY_DARK_NITRATE
%         UV_INTENSITY_NITRATE
%         RAW_DOWNWELLING_IRRADIANCE380
%         RAW_DOWNWELLING_IRRADIANCE412
%         RAW_DOWNWELLING_IRRADIANCE490
%         RAW_DOWNWELLING_PAR
%
%
% Tanya Maurer, July 2024.  
%--------------------------------------------------------------


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

junktempvoltagedoxy=char('TEMP_VOLTAGE_DOXY',enough64');
tempvoltagedoxy64=junktempvoltagedoxy(1,:);

junkdoxy=char('DOXY',enough64');
doxy64=junkdoxy(1,:);

junkfluorescencechla=char('FLUORESCENCE_CHLA',enough64');
fluorescencechla64=junkfluorescencechla(1,:);

junkchla=char('CHLA',enough64');
chla64=junkchla(1,:);

junkchlaF=char('CHLA_FLUORESCENCE',enough64');
chla64F=junkchlaF(1,:);

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

junktempph=char('TEMP_PH',enough64');
tempph64=junktempph(1,:);

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

for iip = 1:length(IPARAMS)
junktemp_rawdwirr{iip}=char(IPARAMS{iip},enough64');
rawdwirr_64{iip}=junktemp_rawdwirr{iip}(1,:);
end 

for ibp = 1:length(BPARAMS)
junkdwirr{ibp}=char(BPARAMS{ibp},enough64');
dwir_64{ibp}=junkdwirr{ibp}(1,:);
end 

station_params=...
[pres64, tempdoxy64, phasedelaydoxy64, tempvoltagedoxy64, doxy64, fluorescencechla64, chla64, chla64F, backscattering64, bbp64, fluorescencecdom64, cdom64, vrsph64, tempph64, phfree64, phtotal64, rawdwirr_64{1}, rawdwirr_64{2}, rawdwirr_64{3}, rawdwirr_64{4}, dwir_64{1}, dwir_64{2}, dwir_64{3}, dwir_64{4},;
pres64, uvdarknitrate64, uvnitrate64, nitrate64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64];

varid=netcdf.inqVarID(fid,'STATION_PARAMETERS');
netcdf.putVar(fid, varid, station_params');

varid=netcdf.inqVarID(fid,'PARAMETER');
netcdf.putVar(fid, varid, station_params');

clear junk64 junkpres junktempdoxy junkphasedelaydoxy junktempvoltagedoxy junkdoxy junkfluorescencechla junkchla junkbackscattering junkbbp junkfluorescencecdom junkcdom junkvrsph junktempph junkphfree junkphtotal junkuvdarknitrate junkuvnitrate junknitrate junknitrate junktemp_rawdwirr380 junktemp_rawdwirr412 junktemp_rawdwirr490 junktemp_rawdwpar junkdwirr380 junkdwirr412 junkdwirr490 junkdwpar


% assign DATA_MODE and PARAMETER_DATA_MODE ------

datamode_check=ones(2,5);

doxydatamode=INFO.DOXY_DATA_MODE;
if(doxydatamode=='A')datamode_check(1,1)=2;end
if(doxydatamode=='D')datamode_check(1,1)=3;end

chladatamode=INFO.CHLA_DATA_MODE;
if(chladatamode=='A')datamode_check(1,2)=2;end
if(chladatamode=='D')datamode_check(1,2)=3;end

chlaFdatamode=INFO.CHLA_FLUORESCENCE_DATA_MODE;
if(chlaFdatamode=='A')datamode_check(1,2)=2;end
if(chlaFdatamode=='D')datamode_check(1,2)=3;end

bbp700datamode=INFO.BBP700_DATA_MODE;
if(bbp700datamode=='A')datamode_check(1,3)=2;end
if(bbp700datamode=='D')datamode_check(1,3)=3;end

cdomdatamode=INFO.CDOM_DATA_MODE;
if(cdomdatamode=='A')datamode_check(1,4)=2;end
if(cdomdatamode=='D')datamode_check(1,4)=3;end

phdatamode=INFO.PH_DATA_MODE;
if(phdatamode=='A')datamode_check(1,5)=2;end
if(phdatamode=='D')datamode_check(1,5)=3;end

nidatamode=INFO.NITRATE_DATA_MODE;
if(nidatamode=='A')datamode_check(2,1)=2;end
if(nidatamode=='D')datamode_check(2,1)=3;end

for idm = 1:4
    irrCHdatamode{idm} = INFO.([BPARAMS{idm},'_DATA_MODE']);
    if(irrCHdatamode{idm}=='A')datamode_CHECK(1,5+idm)=2;end
    if(irrCHdatamode{idm}=='D')datamode_CHECK(1,5+idm)=3;end
end

%irrCHdatamode=INFO.([BPARAMS(1),'_DATA_MODE']);
%irrCH2datamode=INFO.([BPARAMS(2),'_DATA_MODE']);
%irrCH3datamode=INFO.([BPARAMS(3),'_DATA_MODE']);
%irrCH4datamode=INFO.([BPARAMS(4),'_DATA_MODE']);
%if(irrCH1datamode=='A')datamode_CHECK(1,6)=2;end
%if(irrCH1datamode=='D')datamode_CHECK(1,6)=3;end
%if(irrCH2datamode=='A')datamode_CHECK(1,7)=2;end
%if(irrCH2datamode=='D')datamode_CHECK(1,7)=3;end
%if(irrCH3datamode=='A')datamode_CHECK(1,8)=2;end
%if(irrCH3datamode=='D')datamode_CHECK(1,8)=3;end
%if(irrCH4datamode=='A')datamode_CHECK(1,9)=2;end
%if(irrCH4datamode=='D')datamode_CHECK(1,9)=3;end

if(max(datamode_check(1,:))==1)datamode_whole1='R';end
if(max(datamode_check(1,:))==2)datamode_whole1='A';end
if(max(datamode_check(1,:))==3)datamode_whole1='D';end
if(max(datamode_check(2,:))==1)datamode_whole2='R';end
if(max(datamode_check(2,:))==2)datamode_whole2='A';end
if(max(datamode_check(2,:))==3)datamode_whole2='D';end

datamode=[datamode_whole1;datamode_whole2];

param_datamode=...
['R', 'R', 'R', 'R', doxydatamode, 'R', chladatamode, chlaFdatamode, 'R', bbp700datamode, 'R', cdomdatamode, 'R', 'R', 'R', phdatamode, 'R', irrCHdatamode{1}, 'R', irrCHdatamode{2}, 'R', irrCHdatamode{3}, 'R', irrCHdatamode{4};
'R', 'R', 'R', nidatamode, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '];

% assemble and write bgc raw data and qc flags ------
% all I-Argo param_qc are filled with '0' ------
% all B-Argo param_qc are assigned by MBARI ------

% write to NPROF=1 ---

if(isempty(HR.PRES)==0) % assemble the mixed profiles in NPROF=1 from MBARI mat files
  maxhp=max(HR.PRES);
  deepindex=find(LR.PRES>maxhp);
else
  disp(strcat('no HR.PRES in cycle : ', num2str(k)))
end

temp_doxy=[HR.TEMP_DOXY;LR.TEMP_DOXY(deepindex)];
ii=find(temp_doxy>99998);
temp_doxy(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'TEMP_DOXY');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], temp_doxy);

temp_doxy_qc=num2str(zeros(nlevels,1));
temp_doxy_qc(ii)='9';
varid=netcdf.inqVarID(fid,'TEMP_DOXY_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], temp_doxy_qc);

phase_delay_doxy=[HR.PHASE_DELAY_DOXY;LR.PHASE_DELAY_DOXY(deepindex)];
ii=find(phase_delay_doxy>99998);
phase_delay_doxy(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'PHASE_DELAY_DOXY');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], phase_delay_doxy);

phase_delay_doxy_qc=num2str(zeros(nlevels,1));
phase_delay_doxy_qc(ii)='9';
varid=netcdf.inqVarID(fid,'PHASE_DELAY_DOXY_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], phase_delay_doxy_qc);

temp_voltage_doxy=[HR.TEMP_VOLTAGE_DOXY;LR.TEMP_VOLTAGE_DOXY(deepindex)];
ii=find(temp_voltage_doxy>99998);
temp_voltage_doxy(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'TEMP_VOLTAGE_DOXY');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], temp_voltage_doxy);

temp_voltage_doxy_qc=num2str(zeros(nlevels,1));
temp_voltage_doxy_qc(ii)='9';
varid=netcdf.inqVarID(fid,'TEMP_VOLTAGE_DOXY_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], temp_voltage_doxy_qc);

doxy=[HR.DOXY;LR.DOXY(deepindex)];
ii=find(doxy>99998);
doxy(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'DOXY');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], doxy);

ndoxy_qc=[HR.DOXY_QC;LR.DOXY_QC(deepindex)];
jj=find(ndoxy_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no DOXY in cast :', num2str(INFO.cast)));
  doxy_qc=num2str(ones(nlevels,1).*9);
else
  ndoxy_qc(ii)=9;
  doxy_qc=num2str(ndoxy_qc);
end
varid=netcdf.inqVarID(fid,'DOXY_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], doxy_qc);


fluorescence_chla=[HR.FLUORESCENCE_CHLA;LR.FLUORESCENCE_CHLA(deepindex)];
ii=find(fluorescence_chla>99998);
fluorescence_chla(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'FLUORESCENCE_CHLA');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], fluorescence_chla);

fluo_chla_qc=num2str(zeros(nlevels,1));
fluo_chla_qc(ii)='9';
varid=netcdf.inqVarID(fid,'FLUORESCENCE_CHLA_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], fluo_chla_qc);

chla=[HR.CHLA;LR.CHLA(deepindex)];
ii=find(chla>99998);
chla(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'CHLA');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], chla);

nchla_qc=[HR.CHLA_QC;LR.CHLA_QC(deepindex)];
jj=find(nchla_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no CHLA in cast :', num2str(INFO.cast)));
  chla_qc=num2str(ones(nlevels,1).*9);
else
  nchla_qc(ii)=9;
  chla_qc=num2str(nchla_qc);
end
varid=netcdf.inqVarID(fid,'CHLA_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], chla_qc);

chlaF=[HR.CHLA_FLUORESCENCE;LR.CHLA_FLUORESCENCE(deepindex)];
ii=find(chlaF>99998);
chlaF(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], chlaF);

nchlaF_qc=[HR.CHLA_FLUORESCENCE_QC;LR.CHLA_FLUORESCENCE_QC(deepindex)];
jj=find(nchlaF_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no CHLA_FLUORESCENCE in cast :', num2str(INFO.cast)));
  chlaF_qc=num2str(ones(nlevels,1).*9);
else
  nchlaF_qc(ii)=9;
  chlaF_qc=num2str(nchla_qc);
end
varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], chlaF_qc);

beta_backscattering700=[HR.BETA_BACKSCATTERING700;LR.BETA_BACKSCATTERING700(deepindex)];
ii=find(beta_backscattering700>99998);
beta_backscattering700(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'BETA_BACKSCATTERING700');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], beta_backscattering700);

beta_bbp700_qc=num2str(zeros(nlevels,1));
beta_bbp700_qc(ii)='9';
varid=netcdf.inqVarID(fid,'BETA_BACKSCATTERING700_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], beta_bbp700_qc);

bbp700=[HR.BBP700;LR.BBP700(deepindex)];
ii=find(bbp700>99998);
bbp700(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'BBP700');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], bbp700);

nbbp700_qc=[HR.BBP700_QC;LR.BBP700_QC(deepindex)];
jj=find(nbbp700_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no BBP700 in cast :', num2str(INFO.cast)));
  bbp700_qc=num2str(ones(nlevels,1).*9);
else
  nbbp700_qc(ii)=9;
  bbp700_qc=num2str(nbbp700_qc);
end
varid=netcdf.inqVarID(fid,'BBP700_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], bbp700_qc);


fluorescence_cdom=[HR.FLUORESCENCE_CDOM;LR.FLUORESCENCE_CDOM(deepindex)];
ii=find(fluorescence_cdom>99998);
fluorescence_cdom(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'FLUORESCENCE_CDOM');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], fluorescence_cdom);

fluo_cdom_qc=num2str(zeros(nlevels,1));
fluo_cdom_qc(ii)='9';
varid=netcdf.inqVarID(fid,'FLUORESCENCE_CDOM_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], fluo_cdom_qc);

cdom=[HR.CDOM;LR.CDOM(deepindex)];
ii=find(cdom>99998);
cdom(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'CDOM');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], cdom);

ncdom_qc=[HR.CDOM_QC;LR.CDOM_QC(deepindex)];
jj=find(ncdom_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no CDOM in cast :', num2str(INFO.cast)));
  cdom_qc=num2str(ones(nlevels,1).*9);
else
  ncdom_qc(ii)=9;
  cdom_qc=num2str(ncdom_qc);
end
varid=netcdf.inqVarID(fid,'CDOM_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], cdom_qc);



vrs_ph=[HR.VRS_PH;LR.VRS_PH(deepindex)];
ii=find(vrs_ph>99998);
vrs_ph(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'VRS_PH');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], vrs_ph);

vrs_ph_qc=num2str(zeros(nlevels,1));
vrs_ph_qc(ii)='9';
varid=netcdf.inqVarID(fid,'VRS_PH_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], vrs_ph_qc);

temp_ph=[HR.TEMP_PH;LR.TEMP_PH(deepindex)];
ii=find(temp_ph>99998);
temp_ph(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'TEMP_PH');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], temp_ph);

temp_ph_qc=num2str(zeros(nlevels,1));
temp_ph_qc(ii)='9';
varid=netcdf.inqVarID(fid,'TEMP_PH_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], temp_ph_qc);

ph_in_situ_free=[HR.PH_IN_SITU_FREE;LR.PH_IN_SITU_FREE(deepindex)];
ii=find(ph_in_situ_free>99998);
ph_in_situ_free(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'PH_IN_SITU_FREE');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], ph_in_situ_free);

ph_in_situ_free_qc=num2str(zeros(nlevels,1));
ph_in_situ_free_qc(ii)='9';
varid=netcdf.inqVarID(fid,'PH_IN_SITU_FREE_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], ph_in_situ_free_qc);

ph_in_situ_total=[HR.PH_IN_SITU_TOTAL;LR.PH_IN_SITU_TOTAL(deepindex)];
ii=find(ph_in_situ_total>99998);
ph_in_situ_total(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], ph_in_situ_total);

nph_in_situ_total_qc=[HR.PH_IN_SITU_TOTAL_QC;LR.PH_IN_SITU_TOTAL_QC(deepindex)];
jj=find(nph_in_situ_total_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no PH_IN_SITU_TOTAL in cast :', num2str(INFO.cast)));
  ph_in_situ_total_qc=num2str(ones(nlevels,1).*9);
else
  nph_in_situ_total_qc(ii)=9;
  ph_in_situ_total_qc=num2str(nph_in_situ_total_qc);
end
varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_QC');
netcdf.putVar(fid, varid, [0 0], [nlevels 1], ph_in_situ_total_qc);

% OCR -----------
% loop through channels.

for i_irr = 1:4
temp_irr{i_irr}=[HR.(IPARAMS{i_irr});LR.(IPARAMS{i_irr})(deepindex)];
%ii=find(temp_irr{i_irr}==99999);
%temp_irr{i_irr}(ii)=fillfloat;
varid=netcdf.inqVarID(fid,IPARAMS{i_irr});
netcdf.putVar(fid, varid, [0 0], [nlevels 1], temp_irr{i_irr});

temp_irr_qc{i_irr}=num2str(zeros(nlevels,1));
%temp_irr_qc{i_irr}(ii)='9';
varid=netcdf.inqVarID(fid,[IPARAMS{i_irr},'_QC']);
netcdf.putVar(fid, varid, [0 0], [nlevels 1], temp_irr_qc{i_irr});

ocrCH{i_irr}=[HR.(BPARAMS{i_irr});LR.(BPARAMS{i_irr})(deepindex)];
ii=find(ocrCH{i_irr}==99999);
ocrCH{i_irr}(ii)=fillfloat;
varid=netcdf.inqVarID(fid,(BPARAMS{i_irr}));
netcdf.putVar(fid, varid, [0 0], [nlevels 1], ocrCH{i_irr});

ocrCH_qc{i_irr}=[HR.([BPARAMS{i_irr},'_QC']);LR.([BPARAMS{i_irr},'_QC'])(deepindex)];
jj=find(ocrCH_qc{i_irr}==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no ', (BPARAMS{i_irr}),' in cast :', num2str(INFO.cast)));
  ocrCH_qc{i_irr}=num2str(ones(nlevels,1).*9);
else
  ocrCH_qc{i_irr}(ii)=9;
  ocrCH_qc{i_irr}=num2str(ocrCH_qc{i_irr});
end
varid=netcdf.inqVarID(fid,[BPARAMS{i_irr},'_QC']);
netcdf.putVar(fid, varid, [0 0], [nlevels 1], ocrCH_qc{i_irr});
end

%----------------

% write to NPROF=2 ---

uv_intensity_dark_nitrate=LR.UV_INTENSITY_DARK_NITRATE;
ii=find(uv_intensity_dark_nitrate>99998);
uv_intensity_dark_nitrate(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'UV_INTENSITY_DARK_NITRATE');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], uv_intensity_dark_nitrate);

uv_intensity_dark_nitrate_qc=num2str(zeros(nlowres,1));
uv_intensity_dark_nitrate_qc(ii)='9';
varid=netcdf.inqVarID(fid,'UV_INTENSITY_DARK_NITRATE_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], uv_intensity_dark_nitrate_qc);

uv_intensity_nitrate=LR.UV_INTENSITY_NITRATE;
varid=netcdf.inqVarID(fid,'UV_INTENSITY_NITRATE');
if(nvalues>1)
  ii=[];
  for j=1:nlowres
    uvn=uv_intensity_nitrate(j,:);
    kk=find(uvn>99998);
    if(length(kk)==nvalues)ii=[ii,j];end
    uvn(kk)=fillfloat;
    netcdf.putVar(fid, varid, [0 j-1 1], [nvalues 1 1], uvn);
  end
elseif(nvalues==1)
  ii=find(uv_intensity_nitrate>99998);
  uv_intensity_nitrate(ii)=fillfloat;
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], uv_intensity_nitrate);
end

uv_intensity_nitrate_qc=num2str(zeros(nlowres,1));
uv_intensity_nitrate_qc(ii)='9';
varid=netcdf.inqVarID(fid,'UV_INTENSITY_NITRATE_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], uv_intensity_nitrate_qc);

nitrate=LR.NITRATE;
ii=find(nitrate>99998);
nitrate(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'NITRATE');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], nitrate);

jj=find(LR.NITRATE_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no NITRATE in cast :', num2str(INFO.cast)));
  nitrate_qc=num2str(ones(nlowres,1).*9);
else
  LR.NITRATE_QC(ii)=9;
  nitrate_qc=num2str(LR.NITRATE_QC);
end
varid=netcdf.inqVarID(fid,'NITRATE_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], nitrate_qc);


% write bgc adjusted data, adjusted error, and adjusted qc ------

% write to NPROF=1 ---

doxy_adj=[HR.DOXY_ADJUSTED;LR.DOXY_ADJUSTED(deepindex)];
ii=find(doxy_adj>99998);

ndoxy_adj_qc=[HR.DOXY_ADJUSTED_QC;LR.DOXY_ADJUSTED_QC(deepindex)];
jj=find(ndoxy_adj_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no DOXY_ADJUSTED in cast :', num2str(INFO.cast)));
  doxy_adj_qc=num2str(ones(nlevels,1).*9);
    varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], doxy_adj_qc);
else
  ndoxy_adj_qc(ii)=9;
  doxy_adj_qc=num2str(ndoxy_adj_qc);
  varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], doxy_adj_qc);

  kk=find(doxy_adj_qc=='4');
  doxy_adj(ii)=fillfloat; % qc='9'
  if(doxydatamode=='D')
    doxy_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], doxy_adj);

  doxy_adj_error=[HR.DOXY_ADJUSTED_ERROR;LR.DOXY_ADJUSTED_ERROR(deepindex)];
  doxy_adj_error(ii)=fillfloat; % qc='9'
  if(doxydatamode=='D')
    doxy_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], doxy_adj_error);
end


chla_adj=[HR.CHLA_ADJUSTED;LR.CHLA_ADJUSTED(deepindex)];
ii=find(chla_adj>99998);

nchla_adj_qc=[HR.CHLA_ADJUSTED_QC;LR.CHLA_ADJUSTED_QC(deepindex)];
jj=find(nchla_adj_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no CHLA_ADJUSTED in cast :', num2str(INFO.cast)));
else
  nchla_adj_qc(ii)=9;
  chla_adj_qc=num2str(nchla_adj_qc);
  varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], chla_adj_qc);

  kk=find(chla_adj_qc=='4');
  chla_adj(ii)=fillfloat; % qc='9'
  if(chladatamode=='D')
    chla_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], chla_adj);

  chla_adj_error=[HR.CHLA_ADJUSTED_ERROR;LR.CHLA_ADJUSTED_ERROR(deepindex)];
  chla_adj_error(ii)=fillfloat; % qc='9'
  if(chladatamode=='D')
    chla_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], chla_adj_error);
end

chlaF_adj=[HR.CHLA_FLUORESCENCE_ADJUSTED;LR.CHLA_FLUORESCENCE_ADJUSTED(deepindex)];
ii=find(chlaF_adj>99998);

nchlaF_adj_qc=[HR.CHLA_FLUORESCENCE_ADJUSTED_QC;LR.CHLA_FLUORESCENCE_ADJUSTED_QC(deepindex)];
jj=find(nchlaF_adj_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no CHLA_FLUORESCENCE_ADJUSTED in cast :', num2str(INFO.cast)));
else
  nchlaF_adj_qc(ii)=9;
  chlaF_adj_qc=num2str(nchlaF_adj_qc);
  varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], chlaF_adj_qc);

  kk=find(chlaF_adj_qc=='4');
  chlaF_adj(ii)=fillfloat; % qc='9'
  if(chlaFdatamode=='D')
    chlaF_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE_ADJUSTED');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], chlaF_adj);

  chlaF_adj_error=[HR.CHLA_FLUORESCENCE_ADJUSTED_ERROR;LR.CHLA_FLUORESCENCE_ADJUSTED_ERROR(deepindex)];
  chlaF_adj_error(ii)=fillfloat; % qc='9'
  if(chlaFdatamode=='D')
    chlaF_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'CHLA_FLUORESCENCE_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], chlaF_adj_error);
end


bbp700_adj=[HR.BBP700_ADJUSTED;LR.BBP700_ADJUSTED(deepindex)];
ii=find(bbp700_adj>99998);

nbbp700_adj_qc=[HR.BBP700_ADJUSTED_QC;LR.BBP700_ADJUSTED_QC(deepindex)];
jj=find(nbbp700_adj_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no BBP700_ADJUSTED in cast :', num2str(INFO.cast)));
else
  nbbp700_adj_qc(ii)=9;
  bbp700_adj_qc=num2str(nbbp700_adj_qc);
  varid=netcdf.inqVarID(fid,'BBP700_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], bbp700_adj_qc);

  kk=find(bbp700_adj_qc=='4');
  bbp700_adj(ii)=fillfloat; % qc='9'
  if(bbp700datamode=='D')
    bbp700_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'BBP700_ADJUSTED');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], bbp700_adj);

  bbp700_adj_error=[HR.BBP700_ADJUSTED_ERROR;LR.BBP700_ADJUSTED_ERROR(deepindex)];
  bbp700_adj_error(ii)=fillfloat; % qc='9'
  if(bbp700datamode=='D')
    bbp700_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'BBP700_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], bbp700_adj_error);
end


cdom_adj=[HR.CDOM_ADJUSTED;LR.CDOM_ADJUSTED(deepindex)];
ii=find(cdom_adj>99998);

ncdom_adj_qc=[HR.CDOM_ADJUSTED_QC;LR.CDOM_ADJUSTED_QC(deepindex)];
jj=find(ncdom_adj_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no CDOM_ADJUSTED in cast :', num2str(INFO.cast)));
else
  ncdom_adj_qc(ii)=9;
  cdom_adj_qc=num2str(ncdom_adj_qc);
  varid=netcdf.inqVarID(fid,'CDOM_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], cdom_adj_qc);

  kk=find(cdom_adj_qc=='4');
  cdom_adj(ii)=fillfloat; % qc='9'
  if(cdomdatamode=='D')
    cdom_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'CDOM_ADJUSTED');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], cdom_adj);

  cdom_adj_error=[HR.CDOM_ADJUSTED_ERROR;LR.CDOM_ADJUSTED_ERROR(deepindex)];
  cdom_adj_error(ii)=fillfloat; % qc='9'
  if(cdomdatamode=='D')
    cdom_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'CDOM_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], cdom_adj_error);
end


ph_in_situ_total_adj=[HR.PH_IN_SITU_TOTAL_ADJUSTED;LR.PH_IN_SITU_TOTAL_ADJUSTED(deepindex)];
ii=find(ph_in_situ_total_adj>99998);

nph_in_situ_total_adj_qc=[HR.PH_IN_SITU_TOTAL_ADJUSTED_QC;LR.PH_IN_SITU_TOTAL_ADJUSTED_QC(deepindex)];
jj=find(nph_in_situ_total_adj_qc==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no PH_IN_SITU_TOTAL_ADJUSTED in cast :', num2str(INFO.cast)));
    ph_in_situ_total_adj_qc=num2str(ones(nlevels,1).*9);
	varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED_QC');
    netcdf.putVar(fid, varid, [0 0], [nlevels 1], ph_in_situ_total_adj_qc);
else
  nph_in_situ_total_adj_qc(ii)=9;
  ph_in_situ_total_adj_qc=num2str(nph_in_situ_total_adj_qc);
  varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], ph_in_situ_total_adj_qc);

  kk=find(ph_in_situ_total_adj_qc=='4');
  ph_in_situ_total_adj(ii)=fillfloat; % qc='9'
  if(phdatamode=='D')
    ph_in_situ_total_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], ph_in_situ_total_adj);

  ph_in_situ_total_adj_error=[HR.PH_IN_SITU_TOTAL_ADJUSTED_ERROR;LR.PH_IN_SITU_TOTAL_ADJUSTED_ERROR(deepindex)];
  ph_in_situ_total_adj_error(ii)=fillfloat; % qc='9'
  if(phdatamode=='D')
    ph_in_situ_total_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], ph_in_situ_total_adj_error);
end


% OCR adjusted
for i_adj = 1:4
ocrCH_adj{i_adj}=[HR.([BPARAMS{i_adj},'_ADJUSTED']);LR.([BPARAMS{i_adj},'_ADJUSTED'])(deepindex)];
ii=find(ocrCH_adj{i_adj}>99998);

ocrCH_adj_qc{i_adj}=[HR.([BPARAMS{i_adj},'_ADJUSTED_QC']);LR.([BPARAMS{i_adj},'_ADJUSTED_QC'])(deepindex)];
jj=find(ocrCH_adj_qc{i_adj}==99);
if(length(jj)==nlevels & length(ii)==nlevels)
  disp(strcat('no ',BPARAMS{i_adj},'_ADJUSTED in cast :', num2str(INFO.cast)));
else
  ocrCH_adj_qc{i_adj}(ii)=9;
  ocrCH_adj_qc{i_adj}=num2str(ocrCH_adj_qc{i_adj});
  varid=netcdf.inqVarID(fid,[BPARAMS{i_adj},'_ADJUSTED_QC']);
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], ocrCH_adj_qc{i_adj});

  kk=find(ocrCH_adj_qc{i_adj}=='4');
  ocrCH_adj{i_adj}(ii)=fillfloat; % qc='9'
  if(irrCHdatamode{i_adj}=='D')
    ocrCH_adj{i_adj}(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,[BPARAMS{i_adj},'_ADJUSTED']);
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], ocrCH_adj{i_adj});

  ocrCH_adj_error{i_adj}=[HR.([BPARAMS{i_adj},'_ADJUSTED_ERROR']);LR.([BPARAMS{i_adj},'_ADJUSTED_ERROR'])(deepindex)];
  ocrCH_adj_error{i_adj}(ii)=fillfloat; % qc='9'
  if(irrCHdatamode{i_adj}=='D')
    ocrCH_adj_error{i_adj}(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,[BPARAMS{i_adj},'_ADJUSTED_ERROR']);
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], ocrCH_adj_error{i_adj});
end
end

% write to NPROF=2 ---

nitrate_adj=LR.NITRATE_ADJUSTED;
ii=find(nitrate_adj>99998);

jj=find(LR.NITRATE_ADJUSTED_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no NITRATE_ADJUSTED in cast :', num2str(INFO.cast)));
      nitrate_adj_qc=num2str(ones(nlowres,1).*9);
	varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], nitrate_adj_qc);
else
  LR.NITRATE_ADJUSTED_QC(ii)=9;
  nitrate_adj_qc=num2str(LR.NITRATE_ADJUSTED_QC);
  varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], nitrate_adj_qc);

  kk=find(nitrate_adj_qc=='4');
  nitrate_adj(ii)=fillfloat; % qc='9'
  if(nidatamode=='D')
    nitrate_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], nitrate_adj);

  nitrate_adj_error=LR.NITRATE_ADJUSTED_ERROR;
  nitrate_adj_error(ii)=fillfloat; % qc='9'
  if(nidatamode=='D')
    nitrate_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], nitrate_adj_error);
end


% set SCIENTIFIC_CALIB entries ------

enough256=num2str(ones(256,1));

junk=char('Adjusted values are provided in the core profile file',enough256');
prescomment256=junk(1,:);
varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COMMENT');
netcdf.putVar(fid, varid, [0,0,0,0], [256,1,1,1], prescomment256); %nprof1
netcdf.putVar(fid, varid, [0,0,0,1], [256,1,1,1], prescomment256); %nprof2

junk=char('not applicable',enough256');
nocomment256=junk(1,:);

junk=char(INFO.DOXY_SCI_CAL_EQU,enough256');
doxy_eqn256=junk(1,:);
junk=char(INFO.DOXY_SCI_CAL_COEF,enough256');
doxy_coeff256=junk(1,:);
junk=char(INFO.DOXY_SCI_CAL_COM,enough256');
doxy_comment256=junk(1,:);

junk=char(INFO.CHLA_SCI_CAL_EQU,enough256');
chla_eqn256=junk(1,:);
junk=char(INFO.CHLA_SCI_CAL_COEF,enough256');
chla_coeff256=junk(1,:);
junk=char(INFO.CHLA_SCI_CAL_COM,enough256');
chla_comment256=junk(1,:);

junk=char(INFO.CHLA_FLUORESCENCE_SCI_CAL_EQU,enough256');
chla_eqn256=junk(1,:);
junk=char(INFO.CHLA_FLUORESCENCE_SCI_CAL_COEF,enough256');
chla_coeff256=junk(1,:);
junk=char(INFO.CHLA_FLUORESCENCE_SCI_CAL_COM,enough256');
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

junk=char(INFO.PH_SCI_CAL_EQU,enough256');
ph_eqn256=junk(1,:);
junk=char(INFO.PH_SCI_CAL_COEF,enough256');
ph_coeff256=junk(1,:);
junk=char(INFO.PH_SCI_CAL_COM,enough256');
ph_comment256=junk(1,:);

junk=char(INFO.NITRATE_SCI_CAL_EQU,enough256');
ni_eqn256=junk(1,:);
junk=char(INFO.NITRATE_SCI_CAL_COEF,enough256');
ni_coeff256=junk(1,:);
junk=char(INFO.NITRATE_SCI_CAL_COM,enough256');
ni_comment256=junk(1,:);

for isc = 1:4
junk=char(INFO.([BPARAMS{isc},'_SCI_CAL_EQU']),enough256');
irr_eqn256{isc}=junk(1,:);
junk=char(INFO.([BPARAMS{isc},'_SCI_CAL_COEF']),enough256');
irr_coeff256{isc}=junk(1,:);
junk=char(INFO.([BPARAMS{isc},'_SCI_CAL_COM']),enough256');
irr_comment256{isc}=junk(1,:);
end



%---only write out sci cal info when datamode='A' or 'D'---

varid_com=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COMMENT');
varid_equ=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_EQUATION');
varid_coef=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COEFFICIENT');
varid_date=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_DATE');

%if(doxydatamode=='A'|doxydatamode=='D')
  for i=2:4
   netcdf.putVar(fid, varid_com, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_equ, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_coef, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_date, [0,i-1,0,0], [14,1,1,1], writedate);
  end
  netcdf.putVar(fid, varid_com, [0,5-1,0,0], [256,1,1,1], doxy_comment256); %doxy=5
  netcdf.putVar(fid, varid_equ, [0,5-1,0,0], [256,1,1,1], doxy_eqn256);
  netcdf.putVar(fid, varid_coef, [0,5-1,0,0], [256,1,1,1], doxy_coeff256);
  netcdf.putVar(fid, varid_date, [0,5-1,0,0], [14,1,1,1], writedate);
%end
%if(chladatamode=='A'|chladatamode=='D')
  for i=6
   netcdf.putVar(fid, varid_com, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_equ, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_coef, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_date, [0,i-1,0,0], [14,1,1,1], writedate);
  end
  netcdf.putVar(fid, varid_com, [0,7-1,0,0], [256,1,1,1], chla_comment256); %chla=7
  netcdf.putVar(fid, varid_equ, [0,7-1,0,0], [256,1,1,1], chla_eqn256);
  netcdf.putVar(fid, varid_coef, [0,7-1,0,0], [256,1,1,1], chla_coeff256);
  netcdf.putVar(fid, varid_date, [0,7-1,0,0], [14,1,1,1], writedate);
%end
%if(bbp700datamode=='A'|bbp700datamode=='D')
  for i=8
   netcdf.putVar(fid, varid_com, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_equ, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_coef, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_date, [0,i-1,0,0], [14,1,1,1], writedate);
  end
  netcdf.putVar(fid, varid_com, [0,9-1,0,0], [256,1,1,1], bbp700_comment256); %bbp700=9
  netcdf.putVar(fid, varid_equ, [0,9-1,0,0], [256,1,1,1], bbp700_eqn256);
  netcdf.putVar(fid, varid_coef, [0,9-1,0,0], [256,1,1,1], bbp700_coeff256);
  netcdf.putVar(fid, varid_date, [0,9-1,0,0], [14,1,1,1], writedate);
%end
%if(cdomdatamode=='A'|cdomdatamode=='D')
  for i=10
   netcdf.putVar(fid, varid_com, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_equ, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_coef, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_date, [0,i-1,0,0], [14,1,1,1], writedate);
  end
  netcdf.putVar(fid, varid_com, [0,11-1,0,0], [256,1,1,1], cdom_comment256); %cdom=11
  netcdf.putVar(fid, varid_equ, [0,11-1,0,0], [256,1,1,1], cdom_eqn256);
  netcdf.putVar(fid, varid_coef, [0,11-1,0,0], [256,1,1,1], cdom_coeff256);
  netcdf.putVar(fid, varid_date, [0,11-1,0,0], [14,1,1,1], writedate);
%end
%if(phdatamode=='A'|phdatamode=='D')
  for i=12:14
   netcdf.putVar(fid, varid_com, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_equ, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_coef, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_date, [0,i-1,0,0], [14,1,1,1], writedate);
  end
  netcdf.putVar(fid, varid_com, [0,15-1,0,0], [256,1,1,1], ph_comment256); %ph=15
  netcdf.putVar(fid, varid_equ, [0,15-1,0,0], [256,1,1,1], ph_eqn256);
  netcdf.putVar(fid, varid_coef, [0,15-1,0,0], [256,1,1,1], ph_coeff256);
  netcdf.putVar(fid, varid_date, [0,15-1,0,0], [14,1,1,1], writedate);
%end
  for i=16:2:22
   netcdf.putVar(fid, varid_com, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_equ, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_coef, [0,i-1,0,0], [256,1,1,1], nocomment256);
   netcdf.putVar(fid, varid_date, [0,i-1,0,0], [14,1,1,1], writedate);
  end
  netcdf.putVar(fid, varid_com, [0,17-1,0,0], [256,1,1,1], irr_comment256{1}); 
  netcdf.putVar(fid, varid_equ, [0,17-1,0,0], [256,1,1,1], irr_eqn256{1});
  netcdf.putVar(fid, varid_coef, [0,17-1,0,0], [256,1,1,1], irr_coeff256{1});
  netcdf.putVar(fid, varid_date, [0,17-1,0,0], [14,1,1,1], writedate);
    netcdf.putVar(fid, varid_com, [0,19-1,0,0], [256,1,1,1], irr_comment256{2}); 
  netcdf.putVar(fid, varid_equ, [0,19-1,0,0], [256,1,1,1], irr_eqn256{2});
  netcdf.putVar(fid, varid_coef, [0,19-1,0,0], [256,1,1,1], irr_coeff256{2});
  netcdf.putVar(fid, varid_date, [0,19-1,0,0], [14,1,1,1], writedate);
    netcdf.putVar(fid, varid_com, [0,21-1,0,0], [256,1,1,1], irr_comment256{3}); 
  netcdf.putVar(fid, varid_equ, [0,21-1,0,0], [256,1,1,1], irr_eqn256{3});
  netcdf.putVar(fid, varid_coef, [0,21-1,0,0], [256,1,1,1], irr_coeff256{3});
  netcdf.putVar(fid, varid_date, [0,21-1,0,0], [14,1,1,1], writedate);
    netcdf.putVar(fid, varid_com, [0,23-1,0,0], [256,1,1,1], irr_comment256{4}); 
  netcdf.putVar(fid, varid_equ, [0,23-1,0,0], [256,1,1,1], irr_eqn256{4});
  netcdf.putVar(fid, varid_coef, [0,23-1,0,0], [256,1,1,1], irr_coeff256{4});
  netcdf.putVar(fid, varid_date, [0,23-1,0,0], [14,1,1,1], writedate);

%if(nidatamode=='A'|nidatamode=='D') %---only write out sci cal info when datamode='A'---

for i=2:3
  netcdf.putVar(fid, varid_com, [0,i-1,0,1], [256,1,1,1], nocomment256);
  netcdf.putVar(fid, varid_equ, [0,i-1,0,1], [256,1,1,1], nocomment256);
  netcdf.putVar(fid, varid_coef, [0,i-1,0,1], [256,1,1,1], nocomment256);
  netcdf.putVar(fid, varid_date, [0,i-1,0,1], [14,1,1,1], writedate);
end
netcdf.putVar(fid, varid_com, [0,4-1,0,1], [256,1,1,1], ni_comment256); %nitrate=4
netcdf.putVar(fid, varid_equ, [0,4-1,0,1], [256,1,1,1], ni_eqn256);
netcdf.putVar(fid, varid_coef, [0,4-1,0,1], [256,1,1,1], ni_coeff256);
netcdf.putVar(fid, varid_date, [0,4-1,0,1], [14,1,1,1], writedate);

%end %---if datamode(2)=='A' or 'D'

% write DATA_MODE and PARAMETER_DATA_MODE ------

varid=netcdf.inqVarID(fid,'DATA_MODE');
netcdf.putVar(fid, varid, datamode');

varid=netcdf.inqVarID(fid,'PARAMETER_DATA_MODE');
netcdf.putVar(fid, varid, param_datamode');


% close the BR-file ------

netcdf.close(fid);


