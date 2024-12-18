%
% this function creates a skeleton V3.1 b-Argo profile file with N_PROF=2
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
% Modified 3/21/23 to update raw OCR I-param data-type (per updates to the argo parameters list)
%--------------------------------------------------------------

%nlevels=490;
%nvalues=43;

ncid=netcdf.create(filenameBR,'clobber');

% declare variables
BPARAMS = {'DOWNWELLING_PAR',...
           'DOWN_IRRADIANCE380',...
           'DOWN_IRRADIANCE412',...
           'DOWN_IRRADIANCE490'};
IPARAMS = {'RAW_DOWNWELLING_PAR',...
           'RAW_DOWNWELLING_IRRADIANCE380',...
           'RAW_DOWNWELLING_IRRADIANCE412',...
           'RAW_DOWNWELLING_IRRADIANCE490'};
IPARAMlongname = {'Raw downwelling photosynthetic available radiation',...
                  'Raw downwelling irradiance at 380 nanometers',...
                  'Raw downwelling irradiance at 412 nanometers',...
                  'Raw downwelling irradiance at 490 nanometers'};
BPARAMlongname = {'Downwelling photosynthetic available radiation',...
                  'Downwelling irradiance at 380 nanometers',...
                  'Downwelling irradiance at 412 nanometers',...
                  'Downwelling irradiance at 490 nanometers'};
BPARAMstdname = {'downwelling_photosynthetic_photon_flux_in_sea_water',...
                  '',...
                  '',...
                  ''};             
BPARAMunits = {'microMoleQuanta/m^2/sec',...
                  'W/m^2/nm',...
                  'W/m^2/nm',...
                  'W/m^2/nm'};  
BPARAMres = {'single(0.001)',...
                  'single(1e-6)',...
                  'single(1e-6)',...
                  'single(1e-6)'};  
BPARAMcformat = {'%.3f',...
                  '%.6f',...
                  '%.6f',...
                  '%.6f'};  
BPARAMfformat = { 'F.3',...
                  'F.6',...
                  'F.6',...
                  'F.6'};  
Nparam = length(BPARAMS)+length(IPARAMS)+1; %Bparams plus Iparams plus PRES

% declare dimensions

datetime_dimid=netcdf.defDim(ncid,'DATE_TIME',14);
string2_dimid=netcdf.defDim(ncid,'STRING2',2);
string4_dimid=netcdf.defDim(ncid,'STRING4',4);
string8_dimid=netcdf.defDim(ncid,'STRING8',8);
string16_dimid=netcdf.defDim(ncid,'STRING16',16);
string32_dimid=netcdf.defDim(ncid,'STRING32',32);
string64_dimid=netcdf.defDim(ncid,'STRING64',64);
string256_dimid=netcdf.defDim(ncid,'STRING256',256);
nprof_dimid=netcdf.defDim(ncid,'N_PROF',2);
nparam_dimid=netcdf.defDim(ncid,'N_PARAM',Nparam);
nlevels_dimid=netcdf.defDim(ncid,'N_LEVELS',nlevels);
ncalib_dimid=netcdf.defDim(ncid,'N_CALIB',1);
nhistory_dimid=netcdf.defDim(ncid,'N_HISTORY',netcdf.getConstant('NC_UNLIMITED'));

% general information ------

varid=netcdf.defVar(ncid,'DATA_TYPE','NC_CHAR',[string32_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Data type');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 1');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'FORMAT_VERSION','NC_CHAR',[string4_dimid]);
netcdf.putAtt(ncid,varid,'long_name','File format version');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'HANDBOOK_VERSION','NC_CHAR',[string4_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Data handbook version');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'REFERENCE_DATE_TIME','NC_CHAR',[datetime_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Date of reference for Julian days');
netcdf.putAtt(ncid,varid,'conventions','YYYYMMDDHHMISS');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'DATE_CREATION','NC_CHAR',[datetime_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Date of file creation');
netcdf.putAtt(ncid,varid,'conventions','YYYYMMDDHHMISS');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'DATE_UPDATE','NC_CHAR',[datetime_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Date of update of this file');
netcdf.putAtt(ncid,varid,'conventions','YYYYMMDDHHMISS');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'PLATFORM_NUMBER','NC_CHAR',[string8_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Float unique identifier');
netcdf.putAtt(ncid,varid,'conventions','WMO float identifier : A9IIIII');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'PROJECT_NAME','NC_CHAR',[string64_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Name of the project');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'PI_NAME','NC_CHAR',[string64_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Name of the principal investigator');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'STATION_PARAMETERS','NC_CHAR',[string64_dimid, nparam_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','List of available parameters for the station');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 3');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'CYCLE_NUMBER','NC_INT',[nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Float cycle number');
netcdf.putAtt(ncid,varid,'conventions','0...N, 0 : launch cycle (if exists), 1 : first complete cycle');
netcdf.putAtt(ncid,varid,'_FillValue',int32(99999));

varid=netcdf.defVar(ncid,'DIRECTION','NC_CHAR',[nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Direction of the station profiles');
netcdf.putAtt(ncid,varid,'conventions','A: ascending profiles, D: descending profiles');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'DATA_CENTRE','NC_CHAR',[string2_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Data centre in charge of float data processing');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 4');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'DC_REFERENCE','NC_CHAR',[string32_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Station unique identifier in data centre');
netcdf.putAtt(ncid,varid,'conventions','Data centre convention');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'DATA_STATE_INDICATOR','NC_CHAR',[string4_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Degree of processing the data have passed through');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 6');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'DATA_MODE','NC_CHAR',[nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Delayed mode or real time data');
netcdf.putAtt(ncid,varid,'conventions','R : real time; D : delayed mode; A : real time with adjustment');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'PARAMETER_DATA_MODE','NC_CHAR',[nparam_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Delayed mode or real time data');
netcdf.putAtt(ncid,varid,'conventions','R : real time; D : delayed mode; A : real time with adjustment');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'PLATFORM_TYPE','NC_CHAR',[string32_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Type of float');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 23');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'FLOAT_SERIAL_NO','NC_CHAR',[string32_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Serial number of the float');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'FIRMWARE_VERSION','NC_CHAR',[string32_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Instrument firmware version');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'WMO_INST_TYPE','NC_CHAR',[string4_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Coded instrument type');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 8');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'JULD','NC_DOUBLE',[nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Julian day (UTC) of the station relative to REFERENCE_DATE_TIME');
netcdf.putAtt(ncid,varid,'standard_name','time');
netcdf.putAtt(ncid,varid,'units','days since 1950-01-01 00:00:00 UTC');
netcdf.putAtt(ncid,varid,'conventions','Relative julian days with decimal part (as parts of day)');
netcdf.putAtt(ncid,varid,'resolution',1./(24*60*60)); %UPDATE TM, Jul2021: resolution changed from 1.e-08
netcdf.putAtt(ncid,varid,'_FillValue',999999.);
netcdf.putAtt(ncid,varid,'axis','T');

varid=netcdf.defVar(ncid,'JULD_QC','NC_CHAR',[nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Quality on date and time');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 2');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'JULD_LOCATION','NC_DOUBLE',[nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Julian day (UTC) of the location relative to REFERENCE_DATE_TIME');
netcdf.putAtt(ncid,varid,'units','days since 1950-01-01 00:00:00 UTC');
netcdf.putAtt(ncid,varid,'conventions','Relative julian days with decimal part (as parts of day)');
netcdf.putAtt(ncid,varid,'resolution',1./(24*60*60)); %UPDATE TM, Jul2021: resolution changed from 1.e-08
netcdf.putAtt(ncid,varid,'_FillValue',999999.);

varid=netcdf.defVar(ncid,'LATITUDE','NC_DOUBLE',[nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Latitude of the station, best estimate');
netcdf.putAtt(ncid,varid,'standard_name','latitude');
netcdf.putAtt(ncid,varid,'units','degree_north');
netcdf.putAtt(ncid,varid,'_FillValue',99999.);
netcdf.putAtt(ncid,varid,'valid_min',-90.);
netcdf.putAtt(ncid,varid,'valid_max',90.);
netcdf.putAtt(ncid,varid,'axis','Y');

varid=netcdf.defVar(ncid,'LONGITUDE','NC_DOUBLE',[nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Longitude of the station, best estimate');
netcdf.putAtt(ncid,varid,'standard_name','longitude');
netcdf.putAtt(ncid,varid,'units','degree_east');
netcdf.putAtt(ncid,varid,'_FillValue',99999.);
netcdf.putAtt(ncid,varid,'valid_min',-180.);
netcdf.putAtt(ncid,varid,'valid_max',180.);
netcdf.putAtt(ncid,varid,'axis','X');

varid=netcdf.defVar(ncid,'POSITION_QC','NC_CHAR',[nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Quality on position (latitude and longitude)');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 2');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'POSITIONING_SYSTEM','NC_CHAR',[string8_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Positioning system');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'VERTICAL_SAMPLING_SCHEME','NC_CHAR',[string256_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Vertical sampling scheme');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 16');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'CONFIG_MISSION_NUMBER','NC_INT',[nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Unique number denoting the missions performed by the float');
netcdf.putAtt(ncid,varid,'conventions','1...N, 1 : first complete mission');
netcdf.putAtt(ncid,varid,'_FillValue',int32(99999));


% profile_param_qc ------
for ip = 1:length(IPARAMS)
    defVar_input = ['PROFILE_',IPARAMS{ip},'_QC'];
    long_name_input = ['Global quality flag of ',IPARAMS{ip},' profile'];
    varid=netcdf.defVar(ncid,defVar_input,'NC_CHAR',[nprof_dimid]);
    netcdf.putAtt(ncid,varid,'long_name',long_name_input);
    netcdf.putAtt(ncid,varid,'conventions','Argo reference table 2a');
    netcdf.putAtt(ncid,varid,'_FillValue',' ');
end
for bp = 1:length(BPARAMS)
    defVar_input = ['PROFILE_',BPARAMS{bp},'_QC'];
    long_name_input = ['Global quality flag of ',BPARAMS{bp},' profile'];
    varid=netcdf.defVar(ncid,defVar_input,'NC_CHAR',[nprof_dimid]);
    netcdf.putAtt(ncid,varid,'long_name',long_name_input);
    netcdf.putAtt(ncid,varid,'conventions','Argo reference table 2a');
    netcdf.putAtt(ncid,varid,'_FillValue',' ');
end

% params with associated qc & adjusted variables ------

varid=netcdf.defVar(ncid,'PRES','NC_FLOAT',[nlevels_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Sea water pressure, equals 0 at sea-level');
netcdf.putAtt(ncid,varid,'standard_name','sea_water_pressure');
netcdf.putAtt(ncid,varid,'units','decibar');
netcdf.putAtt(ncid,varid,'valid_min',single(0.));
netcdf.putAtt(ncid,varid,'valid_max',single(12000.));
netcdf.putAtt(ncid,varid,'resolution',single(0.1));
netcdf.putAtt(ncid,varid,'C_format','%7.1f');
netcdf.putAtt(ncid,varid,'FORTRAN_format','F7.1');
netcdf.putAtt(ncid,varid,'_FillValue',single(99999.));
netcdf.putAtt(ncid,varid,'axis','Z');

for i2k = 1:length(IPARAMS)
    varid=netcdf.defVar(ncid,IPARAMS{i2k},'NC_DOUBLE',[nlevels_dimid, nprof_dimid]);
    netcdf.putAtt(ncid,varid,'long_name',IPARAMlongname{i2k});
    netcdf.putAtt(ncid,varid,'units','count');
    netcdf.putAtt(ncid,varid,'resolution',double(1));
    netcdf.putAtt(ncid,varid,'C_format','%9.1f');
    netcdf.putAtt(ncid,varid,'FORTRAN_format','F9.1');
    netcdf.putAtt(ncid,varid,'_FillValue',9.969209968386869e+36);
    defVarQC = [IPARAMS{i2k},'_QC'];
    varid=netcdf.defVar(ncid,defVarQC,'NC_CHAR',[nlevels_dimid, nprof_dimid]);
    netcdf.putAtt(ncid,varid,'long_name','quality flag');
    netcdf.putAtt(ncid,varid,'conventions','Argo reference table 2');
    netcdf.putAtt(ncid,varid,'_FillValue',' ');
end


for b2k = 1:length(BPARAMS)
    varid=netcdf.defVar(ncid,BPARAMS{b2k},'NC_FLOAT',[nlevels_dimid, nprof_dimid]);
    netcdf.putAtt(ncid,varid,'long_name',BPARAMlongname{b2k});
    if ~isempty(BPARAMstdname{b2k})
        netcdf.putAtt(ncid,varid,'standard_name',BPARAMstdname{b2k});
    end
    netcdf.putAtt(ncid,varid,'units',BPARAMunits{b2k});
    % netcdf.putAtt(ncid,varid,'valid_min',eval(BPARAMmin{b2k}));
    % netcdf.putAtt(ncid,varid,'valid_max',eval(BPARAMmax{b2k}));
    netcdf.putAtt(ncid,varid,'resolution',eval(BPARAMres{b2k}));
    netcdf.putAtt(ncid,varid,'C_format',BPARAMcformat{b2k});
    netcdf.putAtt(ncid,varid,'FORTRAN_format',BPARAMfformat{b2k});
    netcdf.putAtt(ncid,varid,'_FillValue',single(99999.));
    
    defVarQC = [BPARAMS{b2k},'_QC'];
    varid=netcdf.defVar(ncid,defVarQC,'NC_CHAR',[nlevels_dimid, nprof_dimid]);
    netcdf.putAtt(ncid,varid,'long_name','quality flag');
    netcdf.putAtt(ncid,varid,'conventions','Argo reference table 2');
    netcdf.putAtt(ncid,varid,'_FillValue',' ');
    
    defVarAdj = [BPARAMS{b2k},'_ADJUSTED'];
    varid=netcdf.defVar(ncid,defVarAdj,'NC_FLOAT',[nlevels_dimid, nprof_dimid]);
    netcdf.putAtt(ncid,varid,'long_name',BPARAMlongname{b2k});
    if ~isempty(BPARAMstdname{b2k})
        netcdf.putAtt(ncid,varid,'standard_name',BPARAMstdname{b2k});
    end
    netcdf.putAtt(ncid,varid,'units',BPARAMunits{b2k});
    % netcdf.putAtt(ncid,varid,'valid_min',single(-5.));
    % netcdf.putAtt(ncid,varid,'valid_max',single(600.));
    netcdf.putAtt(ncid,varid,'resolution',eval(BPARAMres{b2k}));
    netcdf.putAtt(ncid,varid,'C_format',BPARAMcformat{b2k});
    netcdf.putAtt(ncid,varid,'FORTRAN_format',BPARAMfformat{b2k});
    netcdf.putAtt(ncid,varid,'_FillValue',single(99999.));
    
    defVarAdjQC = [BPARAMS{b2k},'_ADJUSTED_QC'];
    varid=netcdf.defVar(ncid,defVarAdjQC,'NC_CHAR',[nlevels_dimid, nprof_dimid]);
    netcdf.putAtt(ncid,varid,'long_name','quality flag');
    netcdf.putAtt(ncid,varid,'conventions','Argo reference table 2');
    netcdf.putAtt(ncid,varid,'_FillValue',' ');
    
    defVarERR = [BPARAMS{b2k},'_ADJUSTED_ERROR'];
    varid=netcdf.defVar(ncid,defVarERR,'NC_FLOAT',[nlevels_dimid, nprof_dimid]);
    netcdf.putAtt(ncid,varid,'long_name','Contains the error on the adjusted values as determined by the delayed mode QC process');
    netcdf.putAtt(ncid,varid,'units',BPARAMunits{b2k});
    netcdf.putAtt(ncid,varid,'resolution',eval(BPARAMres{b2k}));
    netcdf.putAtt(ncid,varid,'C_format',BPARAMcformat{b2k});
    netcdf.putAtt(ncid,varid,'FORTRAN_format',BPARAMfformat{b2k});
    netcdf.putAtt(ncid,varid,'_FillValue',single(99999.));
end


% SCIENTIFIC_CALIB ------

varid=netcdf.defVar(ncid,'PARAMETER','NC_CHAR',[string64_dimid, nparam_dimid, ncalib_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','List of parameters with calibration information');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 3');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'SCIENTIFIC_CALIB_EQUATION','NC_CHAR',[string256_dimid, nparam_dimid, ncalib_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Calibration equation for this parameter');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'SCIENTIFIC_CALIB_COEFFICIENT','NC_CHAR',[string256_dimid, nparam_dimid, ncalib_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Calibration coefficients for this equation');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'SCIENTIFIC_CALIB_COMMENT','NC_CHAR',[string256_dimid, nparam_dimid, ncalib_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Comment applying to this parameter calibration');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'SCIENTIFIC_CALIB_DATE','NC_CHAR',[datetime_dimid, nparam_dimid, ncalib_dimid, nprof_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Date of calibration');
netcdf.putAtt(ncid,varid,'conventions','YYYYMMDDHHMISS');
netcdf.putAtt(ncid,varid,'_FillValue',' ');


% HISTORY ------

varid=netcdf.defVar(ncid,'HISTORY_INSTITUTION','NC_CHAR',[string4_dimid, nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Institution which performed action');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 4');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'HISTORY_STEP','NC_CHAR',[string4_dimid, nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Step in data processing');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 12');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'HISTORY_SOFTWARE','NC_CHAR',[string4_dimid, nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Name of software which performed action');
netcdf.putAtt(ncid,varid,'conventions','Institution dependent');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'HISTORY_SOFTWARE_RELEASE','NC_CHAR',[string4_dimid, nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Version/release of software which performed action');
netcdf.putAtt(ncid,varid,'conventions','Institution dependent');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'HISTORY_REFERENCE','NC_CHAR',[string64_dimid, nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Reference of database');
netcdf.putAtt(ncid,varid,'conventions','Institution dependent');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'HISTORY_DATE','NC_CHAR',[datetime_dimid, nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Date the history record was created');
netcdf.putAtt(ncid,varid,'conventions','YYYYMMDDHHMISS');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'HISTORY_ACTION','NC_CHAR',[string4_dimid, nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Action performed on data');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 7');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'HISTORY_PARAMETER','NC_CHAR',[string64_dimid, nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Station parameter action is performed on');
netcdf.putAtt(ncid,varid,'conventions','Argo reference table 3');
netcdf.putAtt(ncid,varid,'_FillValue',' ');

varid=netcdf.defVar(ncid,'HISTORY_START_PRES','NC_FLOAT',[nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Start pressure action applied on');
netcdf.putAtt(ncid,varid,'units','decibar');
netcdf.putAtt(ncid,varid,'_FillValue',single(99999.));

varid=netcdf.defVar(ncid,'HISTORY_STOP_PRES','NC_FLOAT',[nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Stop pressure action applied on');
netcdf.putAtt(ncid,varid,'units','decibar');
netcdf.putAtt(ncid,varid,'_FillValue',single(99999.));

varid=netcdf.defVar(ncid,'HISTORY_PREVIOUS_VALUE','NC_FLOAT',[nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Parameter/Flag previous value before action');
netcdf.putAtt(ncid,varid,'_FillValue',single(99999.));

varid=netcdf.defVar(ncid,'HISTORY_QCTEST','NC_CHAR',[string16_dimid, nprof_dimid, nhistory_dimid]);
netcdf.putAtt(ncid,varid,'long_name','Documentation of tests performed, tests failed (in hex form)');
netcdf.putAtt(ncid,varid,'conventions','Write tests performed when ACTION=QCP$; tests failed when ACTION=QCF$');
netcdf.putAtt(ncid,varid,'_FillValue',' ');


% close file

netcdf.close(ncid);


