function AOML = load_aomlinfoandpres(AOname)
% UPDATE: 8/3/2017: Added variables from D-files that Annie was previously
% entering manually (see her email dated 7/25/2017)

fid=netcdf.open(AOname,'nowrite');

AOML.dimid = netcdf.inqDimID(fid,'N_LEVELS');
[AOML.dimname, AOML.nlevels] = netcdf.inqDim(fid,AOML.dimid);

AOML.dimid = netcdf.inqDimID(fid,'N_HISTORY');
[AOML.dimname, AOML.nhistory] = netcdf.inqDim(fid,AOML.dimid);

varid=netcdf.inqVarID(fid,'PLATFORM_NUMBER');
AOML.platform_number=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'PROJECT_NAME');
AOML.project_name=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'CYCLE_NUMBER');
AOML.cycle_number=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'DC_REFERENCE');
AOML.dc_reference=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'PLATFORM_TYPE');
AOML.platform_type=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'FLOAT_SERIAL_NO');
AOML.float_serial_no=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'FIRMWARE_VERSION');
AOML.firmware_version=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'CONFIG_MISSION_NUMBER'); %aw July 2017
AOML.config_mission_core=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'PI_NAME'); %aw July 2017
AOML.pi_name_core=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'VERTICAL_SAMPLING_SCHEME'); %aw July 2017
AOML.vss_core=netcdf.getVar(fid,varid);

% change sn and fw to string32, because AOML is still producing V3.0 R-files ------

enough32=num2str(ones(32,1));

snjunk=char(AOML.float_serial_no',enough32');
AOML.sn32=snjunk(1:2,:);

fwjunk=char(AOML.firmware_version',enough32');
AOML.fw32=fwjunk(1:2,:);


% load aoml data ------

varid=netcdf.inqVarID(fid,'JULD');
AOML.juld=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'JULD_QC');
AOML.juld_qc=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'JULD_LOCATION');
AOML.juld_location=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'LATITUDE');
AOML.latitude=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'LONGITUDE');
AOML.longitude=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'POSITION_QC');
AOML.position_qc=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'POSITIONING_SYSTEM');
AOML.positioning_system=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'PRES');
AOML.aomlpres=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'PRES_QC');
AOML.aomlpresqc=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'TEMP');
AOML.aomltemp=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'TEMP_QC');
AOML.aomltempqc=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'PSAL');
AOML.aomlsal=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'PSAL_QC');
AOML.aomlsalqc=netcdf.getVar(fid,varid);


% load aoml history, this part is for Annie, not needed at MBARI ------

varid=netcdf.inqVarID(fid,'HISTORY_INSTITUTION');
AOML.hist_inst=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_STEP');
AOML.hist_step=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_SOFTWARE');
AOML.hist_software=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_SOFTWARE_RELEASE');
AOML.hist_software_release=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_REFERENCE');
AOML.hist_reference=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_DATE');
AOML.hist_date=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_ACTION');
AOML.hist_action=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_PARAMETER');
AOML.hist_parameter=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_START_PRES');
AOML.hist_start_pres=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_STOP_PRES');
AOML.hist_stop_pres=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_PREVIOUS_VALUE');
AOML.hist_previous_value=netcdf.getVar(fid,varid);

varid=netcdf.inqVarID(fid,'HISTORY_QCTEST');
AOML.hist_qctest=netcdf.getVar(fid,varid);


netcdf.close(fid);


