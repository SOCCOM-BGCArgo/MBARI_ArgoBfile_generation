%
% This function writes MBARI-processed bgc data into my b-file skeleton with N_PROF=2
%
% APEX Iridium with Aanderaa 4330 (doxy), DURA (ph), FLBB (chla & bb)
%
% 4 B-Argo parameters: DOXY, CHLA, BBP700, PH_IN_SITU_TOTAL
%
% 9 I-Argo parameters: TEMP_DOXY, TPHASE_DOXY, FLUORESCENCE_CHLA, BETA_BACKSCATTERING700, VRS_PH, IB_PH, IK_PH, VK_PH, PH_IN_SITU_FREE
%
% N_PARAM = 13 + 1 (PRES) = 14
%
%
% Tanya Maurer April 27,2020
% Tanya Maurer, September 2021 added VK_PH and IK_PH, N_PARAM = 13+1(PRES) = 14
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

junktphasedoxy=char('TPHASE_DOXY',enough64');
tphasedoxy64=junktphasedoxy(1,:);

junkdoxy=char('DOXY',enough64');
doxy64=junkdoxy(1,:);

junkfluorescence=char('FLUORESCENCE_CHLA',enough64');
fluorescence64=junkfluorescence(1,:);

junkchla=char('CHLA',enough64');
chla64=junkchla(1,:);

junkbackscattering=char('BETA_BACKSCATTERING700',enough64');
backscattering64=junkbackscattering(1,:);

junkbbp=char('BBP700',enough64');
bbp64=junkbbp(1,:);

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

station_params=...
[pres64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64;
pres64, tempdoxy64, tphasedoxy64, doxy64, fluorescence64, chla64, backscattering64, bbp64, vrsph64, ibph64, ikph64, vkph64, phfree64, phtotal64];

varid=netcdf.inqVarID(fid,'STATION_PARAMETERS');
netcdf.putVar(fid, varid, station_params');

varid=netcdf.inqVarID(fid,'PARAMETER');
netcdf.putVar(fid, varid, station_params');

clear junk64 junkpres junktempdoxy junktphasedoxy junkdoxy junkfluorescence junkchla junkbackscattering junkbbp junkvrsph junkibph junkikph junkvkph junkphfree junkphtotal


% assign DATA_MODE and PARAMETER_DATA_MODE ------

datamode_check=ones(1,5);

doxydatamode=INFO.DOXY_DATA_MODE;
if(doxydatamode=='A')datamode_check(1)=2;end
if(doxydatamode=='D')datamode_check(1)=3;end

chladatamode=INFO.CHLA_DATA_MODE;
if(chladatamode=='A')datamode_check(2)=2;end
if(chladatamode=='D')datamode_check(2)=3;end

bbpdatamode=INFO.BBP700_DATA_MODE;
if(bbpdatamode=='A')datamode_check(3)=2;end
if(bbpdatamode=='D')datamode_check(3)=3;end

phdatamode=INFO.PH_DATA_MODE;
if(phdatamode=='A')datamode_check(4)=2;end
if(phdatamode=='D')datamode_check(4)=3;end

if(max(datamode_check)==1)datamode_whole='R';end
if(max(datamode_check)==2)datamode_whole='A';end
if(max(datamode_check)==3)datamode_whole='D';end

datamode=['R';datamode_whole];

param_datamode=...
['R', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ';
'R', 'R', 'R', doxydatamode, 'R', chladatamode, 'R', bbpdatamode, 'R', 'R', 'R', 'R', 'R', phdatamode];


% write bgc raw data and qc flags to nprof2 ------
% all I-Argo param_qc are filled with '0' ------
% all B-Argo param_qc are assigned by MBARI ------

temp_doxy=LR.TEMP_DOXY;
ii=find(temp_doxy>99998);
temp_doxy(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'TEMP_DOXY');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], temp_doxy);

temp_doxy_qc=num2str(zeros(nlowres,1));
temp_doxy_qc(ii)='9';
varid=netcdf.inqVarID(fid,'TEMP_DOXY_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], temp_doxy_qc);

tphase_doxy=LR.TPHASE_DOXY;
ii=find(tphase_doxy>99998);
tphase_doxy(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'TPHASE_DOXY');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], tphase_doxy);

tphase_doxy_qc=num2str(zeros(nlowres,1));
tphase_doxy_qc(ii)='9';
varid=netcdf.inqVarID(fid,'TPHASE_DOXY_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], tphase_doxy_qc);

doxy=LR.DOXY;
ii=find(doxy>99998);
doxy(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'DOXY');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], doxy);

jj=find(LR.DOXY_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no DOXY in cast :', num2str(INFO.cast)));
  doxy_qc=num2str(ones(nlowres,1).*9);
else
  LR.DOXY_QC(ii)=9;
  doxy_qc=num2str(LR.DOXY_QC);
end
varid=netcdf.inqVarID(fid,'DOXY_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], doxy_qc);

fluorescence_chla=LR.FLUORESCENCE_CHLA;
ii=find(fluorescence_chla>99998);
fluorescence_chla(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'FLUORESCENCE_CHLA');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], fluorescence_chla);

fluo_chla_qc=num2str(zeros(nlowres,1));
fluo_chla_qc(ii)='9';
varid=netcdf.inqVarID(fid,'FLUORESCENCE_CHLA_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], fluo_chla_qc);

chla=LR.CHLA;
ii=find(chla>99998);
chla(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'CHLA');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], chla);

jj=find(LR.CHLA_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no CHLA in cast :', num2str(INFO.cast)));
  chla_qc=num2str(ones(nlowres,1).*9);
else
  LR.CHLA_QC(ii)=9;
  chla_qc=num2str(LR.CHLA_QC);
end
varid=netcdf.inqVarID(fid,'CHLA_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], chla_qc);

beta_backscattering700=LR.BETA_BACKSCATTERING700;
ii=find(beta_backscattering700>99998);
beta_backscattering700(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'BETA_BACKSCATTERING700');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], beta_backscattering700);

beta_bbp700_qc=num2str(zeros(nlowres,1));
beta_bbp700_qc(ii)='9';
varid=netcdf.inqVarID(fid,'BETA_BACKSCATTERING700_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], beta_bbp700_qc);

bbp700=LR.BBP700;
ii=find(bbp700>99998);
bbp700(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'BBP700');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], bbp700);

jj=find(LR.BBP700_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no BBP700 in cast :', num2str(INFO.cast)));
  bbp700_qc=num2str(ones(nlowres,1).*9);
else
  LR.BBP700_QC(ii)=9;
  bbp700_qc=num2str(LR.BBP700_QC);
end
varid=netcdf.inqVarID(fid,'BBP700_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], bbp700_qc);

vrs_ph=LR.VRS_PH;
ii=find(vrs_ph>99998);
vrs_ph(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'VRS_PH');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], vrs_ph);

vrs_ph_qc=num2str(zeros(nlowres,1));
vrs_ph_qc(ii)='9';
varid=netcdf.inqVarID(fid,'VRS_PH_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], vrs_ph_qc);

ib_ph=LR.IB_PH;
ii=find(ib_ph>99998);
ib_ph(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'IB_PH');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], ib_ph);

ib_ph_qc=num2str(zeros(nlowres,1));
ib_ph_qc(ii)='9';
varid=netcdf.inqVarID(fid,'IB_PH_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], ib_ph_qc);

ik_ph=LR.IK_PH;
ii=find(ik_ph>99998);
ik_ph(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'IK_PH');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], ik_ph);

ik_ph_qc=num2str(zeros(nlowres,1));
ik_ph_qc(ii)='9';
varid=netcdf.inqVarID(fid,'IK_PH_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], ik_ph_qc);

vk_ph=LR.VK_PH;
ii=find(vk_ph>99998);
vk_ph(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'VK_PH');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], vk_ph);

vk_ph_qc=num2str(zeros(nlowres,1));
vk_ph_qc(ii)='9';
varid=netcdf.inqVarID(fid,'VK_PH_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], vk_ph_qc);

ph_in_situ_free=LR.PH_IN_SITU_FREE;
ii=find(ph_in_situ_free>99998);
ph_in_situ_free(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'PH_IN_SITU_FREE');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], ph_in_situ_free);

ph_in_situ_free_qc=num2str(zeros(nlowres,1));
ph_in_situ_free_qc(ii)='9';
varid=netcdf.inqVarID(fid,'PH_IN_SITU_FREE_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], ph_in_situ_free_qc);

ph_in_situ_total=LR.PH_IN_SITU_TOTAL;
ii=find(ph_in_situ_total>99998);
ph_in_situ_total(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], ph_in_situ_total);

jj=find(LR.PH_IN_SITU_TOTAL_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no PH_IN_SITU_TOTAL in cast :', num2str(INFO.cast)));
  ph_in_situ_total_qc=num2str(ones(nlowres,1).*9);
else
  LR.PH_IN_SITU_TOTAL_QC(ii)=9;
  ph_in_situ_total_qc=num2str(LR.PH_IN_SITU_TOTAL_QC);
end
varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_QC');
netcdf.putVar(fid, varid, [0 1], [nlowres 1], ph_in_situ_total_qc);


% write bgc adjusted data, error, and qc flags to nprof2 ------

doxy_adj=LR.DOXY_ADJUSTED;
ii=find(doxy_adj>99998);

jj=find(LR.DOXY_ADJUSTED_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no DOXY_ADJUSTED in cast :', num2str(INFO.cast)));
  doxy_adj_qc=num2str(ones(nlowres,1).*9);
  varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], doxy_adj_qc);
else
  LR.DOXY_ADJUSTED_QC(ii)=9;
  doxy_adj_qc=num2str(LR.DOXY_ADJUSTED_QC);
  varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], doxy_adj_qc);

  kk=find(doxy_adj_qc=='4');
  doxy_adj(ii)=fillfloat; % qc='9'
  if(doxydatamode=='D')
    doxy_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], doxy_adj);

  doxy_adj_error=LR.DOXY_ADJUSTED_ERROR;
  doxy_adj_error(ii)=fillfloat; % qc='9'
  if(doxydatamode=='D')
    doxy_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], doxy_adj_error);
end


chla_adj=LR.CHLA_ADJUSTED;
ii=find(chla_adj>99998);

jj=find(LR.CHLA_ADJUSTED_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no CHLA_ADJUSTED in cast :', num2str(INFO.cast)));
else
  LR.CHLA_ADJUSTED_QC(ii)=9;
  chla_adj_qc=num2str(LR.CHLA_ADJUSTED_QC);
  varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], chla_adj_qc);

  kk=find(chla_adj_qc=='4');
  chla_adj(ii)=fillfloat; % qc='9'
  if(chladatamode=='D')
    chla_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], chla_adj);

  chla_adj_error=LR.CHLA_ADJUSTED_ERROR;
  chla_adj_error(ii)=fillfloat; % qc='9'
  if(chladatamode=='D')
    chla_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], chla_adj_error);
end


bbp700_adj=LR.BBP700_ADJUSTED;
ii=find(bbp700_adj>99998);

jj=find(LR.BBP700_ADJUSTED_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no BBP700_ADJUSTED in cast :', num2str(INFO.cast)));
else
  LR.BBP700_ADJUSTED_QC(ii)=9;
  bbp700_adj_qc=num2str(LR.BBP700_ADJUSTED_QC);
  varid=netcdf.inqVarID(fid,'BBP700_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], bbp700_adj_qc);

  kk=find(bbp700_adj_qc=='4');
  bbp700_adj(ii)=fillfloat; % qc='9'
  if(bbpdatamode=='D')
    bbp700_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'BBP700_ADJUSTED');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], bbp700_adj);

  bbp700_adj_error=LR.BBP700_ADJUSTED_ERROR;
  bbp700_adj_error(ii)=fillfloat; % qc='9'
  if(bbpdatamode=='D')
    bbp700_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'BBP700_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], bbp700_adj_error);
end


ph_in_situ_total_adj=LR.PH_IN_SITU_TOTAL_ADJUSTED;
ii=find(ph_in_situ_total_adj>99998);

jj=find(LR.PH_IN_SITU_TOTAL_ADJUSTED_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no PH_IN_SITU_TOTAL_ADJUSTED in cast :', num2str(INFO.cast)));
else
  LR.PH_IN_SITU_TOTAL_ADJUSTED_QC(ii)=9;
  ph_in_situ_total_adj_qc=num2str(LR.PH_IN_SITU_TOTAL_ADJUSTED_QC);
  varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], ph_in_situ_total_adj_qc);

  kk=find(ph_in_situ_total_adj_qc=='4');
  ph_in_situ_total_adj(ii)=fillfloat; % qc='9'
  if(phdatamode=='D')
    ph_in_situ_total_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], ph_in_situ_total_adj);

  ph_in_situ_total_adj_error=LR.PH_IN_SITU_TOTAL_ADJUSTED_ERROR;
  ph_in_situ_total_adj_error(ii)=fillfloat; % qc='9'
  if(phdatamode=='D')
    ph_in_situ_total_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'PH_IN_SITU_TOTAL_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], ph_in_situ_total_adj_error);
end


% set SCIENTIFIC_CALIB entries ------

enough256=num2str(ones(256,1));

junk=char('Adjusted values are provided in the core profile file',enough256');
prescomment256=junk(1,:);
varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COMMENT');
netcdf.putVar(fid, varid, [0,0,0,0], [256,1,1,1], prescomment256); %nprof1
netcdf.putVar(fid, varid, [0,0,0,1], [256,1,1,1], prescomment256); %nprof2


%if(datamode(2)=='A'|datamode(2)=='D') %---only write out sci cal info when datamode='A' or 'D'---

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

junk=char(INFO.BBP700_SCI_CAL_EQU,enough256');
bbp700_eqn256=junk(1,:);
junk=char(INFO.BBP700_SCI_CAL_COEF,enough256');
bbp700_coeff256=junk(1,:);
junk=char(INFO.BBP700_SCI_CAL_COM,enough256');
bbp700_comment256=junk(1,:);

junk=char(INFO.PH_SCI_CAL_EQU,enough256');
ph_eqn256=junk(1,:);
junk=char(INFO.PH_SCI_CAL_COEF,enough256');
ph_coeff256=junk(1,:);
junk=char(INFO.PH_SCI_CAL_COM,enough256');
ph_comment256=junk(1,:);

varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COMMENT');
for i=2:14
   netcdf.putVar(fid, varid, [0,i-1,0,1], [256,1,1,1], nocomment256);
end
netcdf.putVar(fid, varid, [0,4-1,0,1], [256,1,1,1], doxy_comment256); %doxy=4
netcdf.putVar(fid, varid, [0,6-1,0,1], [256,1,1,1], chla_comment256); %chla=6
netcdf.putVar(fid, varid, [0,8-1,0,1], [256,1,1,1], bbp700_comment256); %bbp700=8
netcdf.putVar(fid, varid, [0,14-1,0,1], [256,1,1,1], ph_comment256); %ph=12

varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_EQUATION');
for i=2:12
   netcdf.putVar(fid, varid, [0,i-1,0,1], [256,1,1,1], nocomment256);
end
netcdf.putVar(fid, varid, [0,4-1,0,1], [256,1,1,1], doxy_eqn256); %doxy=4
netcdf.putVar(fid, varid, [0,6-1,0,1], [256,1,1,1], chla_eqn256); %chla=6
netcdf.putVar(fid, varid, [0,8-1,0,1], [256,1,1,1], bbp700_eqn256); %bbp700=8
netcdf.putVar(fid, varid, [0,14-1,0,1], [256,1,1,1], ph_eqn256); %ph=12

varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COEFFICIENT');
for i=2:14
   netcdf.putVar(fid, varid, [0,i-1,0,1], [256,1,1,1], nocomment256);
end
netcdf.putVar(fid, varid, [0,4-1,0,1], [256,1,1,1], doxy_coeff256); %doxy=4
netcdf.putVar(fid, varid, [0,6-1,0,1], [256,1,1,1], chla_coeff256); %chla=6
netcdf.putVar(fid, varid, [0,8-1,0,1], [256,1,1,1], bbp700_coeff256); %bbp700=8
netcdf.putVar(fid, varid, [0,14-1,0,1], [256,1,1,1], ph_coeff256); %ph=12

varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_DATE');
for i=2:14
   netcdf.putVar(fid, varid, [0,i-1,0,1], [14,1,1,1], writedate);
end


%end %---if datamode(2)=='A' or 'D'


% write DATA_MODE and PARAMETER_DATA_MODE ------

varid=netcdf.inqVarID(fid,'DATA_MODE');
netcdf.putVar(fid, varid, datamode');

varid=netcdf.inqVarID(fid,'PARAMETER_DATA_MODE');
netcdf.putVar(fid, varid, param_datamode');


% close the BR-file ------

netcdf.close(fid);


