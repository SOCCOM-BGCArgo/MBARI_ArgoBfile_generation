%
% This function writes MBARI-processed bgc data into my b-file skeleton with N_PROF=2
%
% APEX Iridium with Aanderaa 4330 (doxy), ISUS (nitrate), FLBB (chla & bb)
%
% 4 B-Argo parameters: DOXY, CHLA, BBP700, NITRATE
%
% 6 I-Argo parameters: TEMP_DOXY, TPHASE_DOXY, FLUORESCENCE_CHLA, BETA_BACKSCATTERING700, UV_INTENSITY_PARK_NITRATE, UV_INTENSITY_NITRATE (spectral)
%
% N_PARAM = 10 + 1 (PRES) = 11
%
%
% Annie Wong, January 2018
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

junkuvdarknitrate=char('UV_INTENSITY_DARK_NITRATE',enough64');
uvdarknitrate64=junkuvdarknitrate(1,:);

junkuvnitrate=char('UV_INTENSITY_NITRATE',enough64');
uvnitrate64=junkuvnitrate(1,:);

junknitrate=char('NITRATE',enough64');
nitrate64=junknitrate(1,:);

station_params=...
[pres64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64;
pres64, tempdoxy64, tphasedoxy64, doxy64, fluorescence64, chla64, backscattering64, bbp64, uvdarknitrate64, uvnitrate64, nitrate64];

varid=netcdf.inqVarID(fid,'STATION_PARAMETERS');
netcdf.putVar(fid, varid, station_params');

varid=netcdf.inqVarID(fid,'PARAMETER');
netcdf.putVar(fid, varid, station_params');

clear junk64 junkpres junktempdoxy junktphasedoxy junkdoxy junkfluorescence junkchla junkbackscattering junkbbp junkuvdarknitrate junkuvnitrate junknitrate


% assign DATA_MODE and PARAMETER_DATA_MODE ------

datamode_check=ones(1,4);

doxydatamode=INFO.DOXY_DATA_MODE;
if(doxydatamode=='A')datamode_check(1)=2;end
if(doxydatamode=='D')datamode_check(1)=3;end

chladatamode=INFO.CHLA_DATA_MODE;
if(chladatamode=='A')datamode_check(2)=2;end
if(chladatamode=='D')datamode_check(2)=3;end

bbpdatamode=INFO.BBP700_DATA_MODE;
if(bbpdatamode=='A')datamode_check(3)=2;end
if(bbpdatamode=='D')datamode_check(3)=3;end

nidatamode=INFO.NITRATE_DATA_MODE;
if(nidatamode=='A')datamode_check(4)=2;end
if(nidatamode=='D')datamode_check(4)=3;end

if(max(datamode_check)==1)datamode_whole='R';end
if(max(datamode_check)==2)datamode_whole='A';end
if(max(datamode_check)==3)datamode_whole='D';end

datamode=['R';datamode_whole];

param_datamode=...
['R', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ';
'R', 'R', 'R', doxydatamode, 'R', chladatamode, 'R', bbpdatamode, 'R', 'R', nidatamode];


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


% write bgc adjusted data, error, and qc flags to nprof2 ------

doxy_adj=LR.DOXY_ADJUSTED;
ii=find(doxy_adj>99998);

jj=find(LR.DOXY_ADJUSTED_QC==99);
if(length(jj)==nlowres & length(ii)==nlowres)
  disp(strcat('no DOXY_ADJUSTED in cast :', num2str(INFO.cast)));
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
% jj=find(LR.NITRATE_ADJUSTED_QC==99);
% if(length(jj)==nlowres & length(ii)==nlowres)
%   disp(strcat('no NITRATE_ADJUSTED in cast :', num2str(INFO.cast)));
% else
%   LR.NITRATE_ADJUSTED_QC(ii)=9;
%   nitrate_adj_qc=num2str(LR.NITRATE_ADJUSTED_QC);
%   varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED_QC');
%   netcdf.putVar(fid, varid, [0 1], [nlowres 1], nitrate_adj_qc);
% 
%   kk=find(nitrate_adj_qc=='4');
%   nitrate_adj(ii)=fillfloat; % qc='9'
%   if(nidatamode=='D')
%     nitrate_adj(kk)=fillfloat; % qc='4'
%   end
%   varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED');
%   netcdf.putVar(fid, varid, [0 1], [nlowres 1], nitrate_adj);
% 
%   nitrate_adj_error=LR.NITRATE_ADJUSTED_ERROR;
%   nitrate_adj_error(ii)=fillfloat; % qc='9'
%   if(nidatamode=='D')
%     nitrate_adj_error(kk)=fillfloat; % qc='4'
%   end
%   varid=netcdf.inqVarID(fid,'NITRATE_ADJUSTED_ERROR');
%   netcdf.putVar(fid, varid, [0 1], [nlowres 1], nitrate_adj_error);
% end


% set SCIENTIFIC_CALIB entries ------

enough256=num2str(ones(256,1));

junk=char('Adjusted values are provided in the core profile file',enough256');
prescomment256=junk(1,:);
varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COMMENT');
netcdf.putVar(fid, varid, [0,0,0,0], [256,1,1,1], prescomment256); %nprof1
netcdf.putVar(fid, varid, [0,0,0,1], [256,1,1,1], prescomment256); %nprof2


%if(datamode(2)=='A'|datamode(2)=='D') %---only write out sci cal info when datamode='A'---

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

junk=char(INFO.NITRATE_SCI_CAL_EQU,enough256');
ni_eqn256=junk(1,:);
junk=char(INFO.NITRATE_SCI_CAL_COEF,enough256');
ni_coeff256=junk(1,:);
junk=char(INFO.NITRATE_SCI_CAL_COM,enough256');
ni_comment256=junk(1,:);

varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COMMENT');
for i=2:11
   netcdf.putVar(fid, varid, [0,i-1,0,1], [256,1,1,1], nocomment256);
end
netcdf.putVar(fid, varid, [0,4-1,0,1], [256,1,1,1], doxy_comment256); %doxy=4
netcdf.putVar(fid, varid, [0,6-1,0,1], [256,1,1,1], chla_comment256); %chla=6
netcdf.putVar(fid, varid, [0,8-1,0,1], [256,1,1,1], bbp700_comment256); %bbp700=8
netcdf.putVar(fid, varid, [0,11-1,0,1], [256,1,1,1], ni_comment256); %nitrate=11

varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_EQUATION');
for i=2:11
   netcdf.putVar(fid, varid, [0,i-1,0,1], [256,1,1,1], nocomment256);
end
netcdf.putVar(fid, varid, [0,4-1,0,1], [256,1,1,1], doxy_eqn256); %doxy=4
netcdf.putVar(fid, varid, [0,6-1,0,1], [256,1,1,1], chla_eqn256); %chla=6
netcdf.putVar(fid, varid, [0,8-1,0,1], [256,1,1,1], bbp700_eqn256); %bbp700=8
netcdf.putVar(fid, varid, [0,11-1,0,1], [256,1,1,1], ni_eqn256); %nitrate=11

varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COEFFICIENT');
for i=2:11
   netcdf.putVar(fid, varid, [0,i-1,0,1], [256,1,1,1], nocomment256);
end
netcdf.putVar(fid, varid, [0,4-1,0,1], [256,1,1,1], doxy_coeff256); %doxy=4
netcdf.putVar(fid, varid, [0,6-1,0,1], [256,1,1,1], chla_coeff256); %chla=6
netcdf.putVar(fid, varid, [0,8-1,0,1], [256,1,1,1], bbp700_coeff256); %bbp700=8
netcdf.putVar(fid, varid, [0,11-1,0,1], [256,1,1,1], ni_coeff256); %nitrate=11

varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_DATE');
for i=2:11
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


