%
% This function writes MBARI-processed bgc data into my b-file skeleton with N_PROF=2
%
% APEX Iridium with OCR504 (down irradiance) only
%
% 4 B-Argo parameters: 
%         DOWNWELLING_PAR
%         DOWN_IRRADIANCE490
%         DOWN_IRRADIANCE412
%         DOWN_IRRADIANCE380
%
% 4 I-Argo parameters: 
%         RAW_DOWNWELLING_IRRADIANCE380
%         RAW_DOWNWELLING_IRRADIANCE412
%         RAW_DOWNWELLING_IRRADIANCE490
%         RAW_DOWNWELLING_PAR
%
% N_PARAM = 8 + 1 (PRES) = 9
%
%
% Tanya Maurer, January, 2022 - template for 2 APEX OCR-only test floats
% (5906446, 5906320)
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

station_params=...
[pres64, junk64, junk64, junk64, junk64, junk64, junk64, junk64, junk64;
pres64, rawdwirr380_64, rawdwirr412_64, rawdwirr490_64, rawdpar_64, dwir380_64, dwir412_64, dwir490_64, dwpar_64];

varid=netcdf.inqVarID(fid,'STATION_PARAMETERS');
netcdf.putVar(fid, varid, station_params');

varid=netcdf.inqVarID(fid,'PARAMETER');
netcdf.putVar(fid, varid, station_params');

clear junk64 junkpres junktemp_rawdwirr380 junktemp_rawdwirr412 junktemp_rawdwirr490 junktemp_rawdwpar junkdwirr380 junkdwirr412 junkdwirr490 junkdwpar


% assign DATA_MODE and PARAMETER_DATA_MODE ------

datamode_check=ones(1,4);

irr380datamode=INFO.DOWN_IRRADIANCE380_DATA_MODE;
if(irr380datamode=='A')datamode_check(1)=2;end
if(irr380datamode=='D')datamode_check(1)=3;end

irr412datamode=INFO.DOWN_IRRADIANCE412_DATA_MODE;
if(irr412datamode=='A')datamode_check(2)=2;end
if(irr412datamode=='D')datamode_check(2)=3;end

irr490datamode=INFO.DOWN_IRRADIANCE490_DATA_MODE;
if(irr490datamode=='A')datamode_check(3)=2;end
if(irr490datamode=='D')datamode_check(3)=3;end

pardatamode=INFO.DOWNWELLING_PAR_DATA_MODE;
if(pardatamode=='A')datamode_check(4)=2;end
if(pardatamode=='D')datamode_check(4)=3;end

if(max(datamode_check)==1)datamode_whole='R';end
if(max(datamode_check)==2)datamode_whole='A';end
if(max(datamode_check)==3)datamode_whole='D';end

datamode=['R';datamode_whole];

param_datamode=...
['R', ' ', ' ', ' ',' ',' ',' ',' ',' ';
'R', 'R', 'R', 'R', 'R', irr380datamode, irr412datamode, irr490datamode, pardatamode];

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% write bgc raw data and qc flags to nprof2 ------
% all I-Argo param_qc are filled with '0' ------
% all B-Argo param_qc are assigned by MBARI ------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

temp_irr380=MB.OCR.RAW_DOWNWELLING_IRRADIANCE380;
%ii=find(temp_irr380>99998);
%temp_irr380(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE380');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], temp_irr380);

temp_irr380_qc=num2str(zeros(nocrres,1));
%temp_irr380_qc(ii)='9';
varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE380_QC');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], temp_irr380_qc);

temp_irr412=MB.OCR.RAW_DOWNWELLING_IRRADIANCE412;
%ii=find(temp_irr412>99998);
%temp_irr412(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE412');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], temp_irr412);

temp_irr412_qc=num2str(zeros(nocrres,1));
%temp_irr412_qc(ii)='9';
varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE412_QC');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], temp_irr412_qc);

temp_irr490=MB.OCR.RAW_DOWNWELLING_IRRADIANCE490;
%ii=find(temp_irr490>99998);
%temp_irr490(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE490');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], temp_irr490);

temp_irr490_qc=num2str(zeros(nocrres,1));
%temp_irr490_qc(ii)='9';
varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_IRRADIANCE490_QC');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], temp_irr490_qc);

temp_dwpar=MB.OCR.RAW_DOWNWELLING_PAR;
%ii=find(temp_dwpar>99998);
%temp_dwpar(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_PAR');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], temp_dwpar);

temp_dwpar_qc=num2str(zeros(nocrres,1));
%temp_dwpar_qc(ii)='9';
varid=netcdf.inqVarID(fid,'RAW_DOWNWELLING_PAR_QC');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], temp_dwpar_qc);

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% WRITE ALL OFFICIAL BPARAMS (4 FOR OCR!)
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%% 1) FIRST BPARAM = DOWN_IRRADIANCE380---------------------------------------------------------------------------------------------------------------------------------------------
ocr380=MB.OCR.DOWN_IRRADIANCE380;
ii=find(ocr380>99998);
ocr380(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr380);

jj=find(MB.OCR.DOWN_IRRADIANCE380_QC==99);
if(length(jj)==nocrres & length(ii)==nocrres)
  disp(strcat('no DOWN IRRADIANCE 380 in cast :', num2str(INFO.cast)));
  ocr380_qc=num2str(ones(nocrres,1).*9);
else
  MB.OCR.DOWN_IRRADIANCE380_QC(ii)=9;
  ocr380_qc=num2str(MB.OCR.DOWN_IRRADIANCE380_QC);
end
varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380_QC');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr380_qc);

% write bgc adjusted data, error, and qc flags to nprof2 ------

ocr380_adj=MB.OCR.DOWN_IRRADIANCE380_ADJUSTED;
ii=find(ocr380_adj>99998);

jj=find(MB.OCR.DOWN_IRRADIANCE380_ADJUSTED_QC==99);
if(length(jj)==nocrres & length(ii)==nocrres)
  disp(strcat('no DOWN_IRRADIANCE380_ADJUSTED in cast :', num2str(INFO.cast)));
else
  MB.OCR.DOWN_IRRADIANCE380_ADJUSTED_QC(ii)=9;
  ocr380_adj_qc=num2str(MB.OCR.DOWN_IRRADIANCE380_ADJUSTED_QC);
  varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr380_adj_qc);

  kk=find(ocr380_adj_qc=='4');
  ocr380_adj(ii)=fillfloat; % qc='9'
  if(irr380datamode=='D')
    ocr380_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380_ADJUSTED');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr380_adj);

  ocr380_adj_error=MB.OCR.DOWN_IRRADIANCE380_ADJUSTED_ERROR;
  ocr380_adj_error(ii)=fillfloat; % qc='9'
  if(irr380datamode=='D')
    ocr380_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE380_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr380_adj_error);
end
%% 2) SECOND BPARAM = DOWN_IRRADIANCE412---------------------------------------------------------------------------------------------------------------------------------------------
ocr412=MB.OCR.DOWN_IRRADIANCE412;
ii=find(ocr412>99998);
ocr412(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr412);

jj=find(MB.OCR.DOWN_IRRADIANCE412_QC==99);
if(length(jj)==nocrres & length(ii)==nocrres)
  disp(strcat('no DOWN IRRADIANCE 412 in cast :', num2str(INFO.cast)));
  ocr412_qc=num2str(ones(nocrres,1).*9);
else
  MB.OCR.DOWN_IRRADIANCE412_QC(ii)=9;
  ocr412_qc=num2str(MB.OCR.DOWN_IRRADIANCE412_QC);
end
varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412_QC');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr412_qc);

% write bgc adjusted data, error, and qc flags to nprof2 ------

ocr412_adj=MB.OCR.DOWN_IRRADIANCE412_ADJUSTED;
ii=find(ocr412_adj>99998);

jj=find(MB.OCR.DOWN_IRRADIANCE412_ADJUSTED_QC==99);
if(length(jj)==nocrres & length(ii)==nocrres)
  disp(strcat('no DOWN_IRRADIANCE412_ADJUSTED in cast :', num2str(INFO.cast)));
else
  MB.OCR.DOWN_IRRADIANCE412_ADJUSTED_QC(ii)=9;
  ocr412_adj_qc=num2str(MB.OCR.DOWN_IRRADIANCE412_ADJUSTED_QC);
  varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr412_adj_qc);

  kk=find(ocr412_adj_qc=='4');
  ocr412_adj(ii)=fillfloat; % qc='9'
  if(irr412datamode=='D')
    ocr412_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412_ADJUSTED');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr412_adj);

  ocr412_adj_error=MB.OCR.DOWN_IRRADIANCE412_ADJUSTED_ERROR;
  ocr412_adj_error(ii)=fillfloat; % qc='9'
  if(irr412datamode=='D')
    ocr412_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE412_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr412_adj_error);
end
%% 3) THIRD BPARAM = DOWN_IRRADIANCE490---------------------------------------------------------------------------------------------------------------------------------------------
ocr490=MB.OCR.DOWN_IRRADIANCE490;
ii=find(ocr490>99998);
ocr490(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr490);

jj=find(MB.OCR.DOWN_IRRADIANCE490_QC==99);
if(length(jj)==nocrres & length(ii)==nocrres)
  disp(strcat('no DOWN IRRADIANCE 490 in cast :', num2str(INFO.cast)));
  ocr490_qc=num2str(ones(nocrres,1).*9);
else
  MB.OCR.DOWN_IRRADIANCE490_QC(ii)=9;
  ocr490_qc=num2str(MB.OCR.DOWN_IRRADIANCE490_QC);
end
varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490_QC');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr490_qc);

% write bgc adjusted data, error, and qc flags to nprof2 ------

ocr490_adj=MB.OCR.DOWN_IRRADIANCE490_ADJUSTED;
ii=find(ocr490_adj>99998);

jj=find(MB.OCR.DOWN_IRRADIANCE490_ADJUSTED_QC==99);
length(jj)
length(ii)
nocrres
if(length(jj)==nocrres & length(ii)==nocrres)
  disp(strcat('no DOWN_IRRADIANCE490_ADJUSTED in cast :', num2str(INFO.cast)));
else
  MB.OCR.DOWN_IRRADIANCE490_ADJUSTED_QC(ii)=9;
  ocr490_adj_qc=num2str(MB.OCR.DOWN_IRRADIANCE490_ADJUSTED_QC);
  varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr490_adj_qc);

  kk=find(ocr490_adj_qc=='4');
  ocr490_adj(ii)=fillfloat; % qc='9'
  if(irr490datamode=='D')
    ocr490_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490_ADJUSTED');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr490_adj);

  ocr490_adj_error=MB.OCR.DOWN_IRRADIANCE490_ADJUSTED_ERROR;
  ocr490_adj_error(ii)=fillfloat; % qc='9'
  if(irr490datamode=='D')
    ocr490_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOWN_IRRADIANCE490_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocr490_adj_error);
end
%% 4) FOURTH BPARAM = DOWNWELLING_PAR---------------------------------------------------------------------------------------------------------------------------------------------
ocrpar=MB.OCR.DOWNWELLING_PAR;
ii=find(ocrpar>99998);
ocrpar(ii)=fillfloat;
varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocrpar);

jj=find(MB.OCR.DOWNWELLING_PAR_QC==99);
if(length(jj)==nocrres & length(ii)==nocrres)
  disp(strcat('no DOWN IRRADIANCE 380 in cast :', num2str(INFO.cast)));
  ocrpar_qc=num2str(ones(nocrres,1).*9);
else
  MB.OCR.DOWNWELLING_PAR_QC(ii)=9;
  ocrpar_qc=num2str(MB.OCR.DOWNWELLING_PAR_QC);
end
varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR_QC');
netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocrpar_qc);

% write bgc adjusted data, error, and qc flags to nprof2 ------

ocrpar_adj=MB.OCR.DOWNWELLING_PAR_ADJUSTED;
ii=find(ocrpar_adj>99998);

jj=find(MB.OCR.DOWNWELLING_PAR_ADJUSTED_QC==99);
if(length(jj)==nocrres & length(ii)==nocrres)
  disp(strcat('no DOWNWELLING_PAR_ADJUSTED in cast :', num2str(INFO.cast)));
else
  MB.OCR.DOWNWELLING_PAR_ADJUSTED_QC(ii)=9;
  ocrpar_adj_qc=num2str(MB.OCR.DOWNWELLING_PAR_ADJUSTED_QC);
  varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR_ADJUSTED_QC');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocrpar_adj_qc);

  kk=find(ocrpar_adj_qc=='4');
  ocrpar_adj(ii)=fillfloat; % qc='9'
  if(pardatamode=='D')
    ocrpar_adj(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocrpar_adj);

  ocrpar_adj_error=MB.OCR.DOWNWELLING_PAR_ADJUSTED_ERROR;
  ocrpar_adj_error(ii)=fillfloat; % qc='9'
  if(pardatamode=='D')
    ocrpar_adj_error(kk)=fillfloat; % qc='4'
  end
  varid=netcdf.inqVarID(fid,'DOWNWELLING_PAR_ADJUSTED_ERROR');
  netcdf.putVar(fid, varid, [0 1], [nocrres 1], ocrpar_adj_error);
end

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% set SCIENTIFIC_CALIB entries ------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

enough256=num2str(ones(256,1));

junk=char('Adjusted values are provided in the core profile file',enough256');
prescomment256=junk(1,:);
varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COMMENT');
netcdf.putVar(fid, varid, [0,0,0,0], [256,1,1,1], prescomment256); %nprof1
netcdf.putVar(fid, varid, [0,0,0,1], [256,1,1,1], prescomment256); %nprof2


%if(datamode(2)=='A'|datamode(2)=='D') %---only write out sci cal info when datamode='A'---

junk=char('not applicable',enough256');
nocomment256=junk(1,:);

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

varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COMMENT');
for i=2:9
   netcdf.putVar(fid, varid, [0,i-1,0,1], [256,1,1,1], nocomment256);
end
netcdf.putVar(fid, varid, [0,6-1,0,1], [256,1,1,1], ocr380_comment256); %ocr380 = 6
netcdf.putVar(fid, varid, [0,7-1,0,1], [256,1,1,1], ocr412_comment256); %ocr412 = 7
netcdf.putVar(fid, varid, [0,8-1,0,1], [256,1,1,1], ocr490_comment256); %ocr490 = 8
netcdf.putVar(fid, varid, [0,9-1,0,1], [256,1,1,1], ocrpar_comment256); %ocrpar = 9


varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_EQUATION');
for i=2:9
   netcdf.putVar(fid, varid, [0,i-1,0,1], [256,1,1,1], nocomment256);
end
netcdf.putVar(fid, varid, [0,6-1,0,1], [256,1,1,1], ocr380_eqn256); %ocr380 = 6
netcdf.putVar(fid, varid, [0,7-1,0,1], [256,1,1,1], ocr412_eqn256); %ocr412 = 7
netcdf.putVar(fid, varid, [0,8-1,0,1], [256,1,1,1], ocr490_eqn256); %ocr490 = 8
netcdf.putVar(fid, varid, [0,9-1,0,1], [256,1,1,1], ocrpar_eqn256); %ocrpar = 9


varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_COEFFICIENT');
for i=2:9
   netcdf.putVar(fid, varid, [0,i-1,0,1], [256,1,1,1], nocomment256);
end
netcdf.putVar(fid, varid, [0,6-1,0,1], [256,1,1,1], ocr380_coeff256); %ocr380 = 6
netcdf.putVar(fid, varid, [0,7-1,0,1], [256,1,1,1], ocr412_coeff256); %ocr412 = 7
netcdf.putVar(fid, varid, [0,8-1,0,1], [256,1,1,1], ocr490_coeff256); %ocr490 = 8
netcdf.putVar(fid, varid, [0,9-1,0,1], [256,1,1,1], ocrpar_coeff256); %ocrpar = 9


varid=netcdf.inqVarID(fid,'SCIENTIFIC_CALIB_DATE');
for i=2:9
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


