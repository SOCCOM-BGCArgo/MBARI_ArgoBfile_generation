
% this function writes PRES and general info to my skeleton V3.1 BR- profile file
%
% N_PROF=2
%
% Annie Wong, January 2018
%--------------------------------------------------------------

% open new V3.1 BR-file skeleton

newid=netcdf.open(filenameBR,'write');


% write general info ------

varid=netcdf.inqVarID(newid,'DATA_TYPE');
netcdf.putVar(newid,varid,'B-Argo profile                  ');

varid=netcdf.inqVarID(newid,'FORMAT_VERSION');
netcdf.putVar(newid,varid,'3.1 ');

varid=netcdf.inqVarID(newid,'HANDBOOK_VERSION');
netcdf.putVar(newid,varid,'1.2 ');

varid=netcdf.inqVarID(newid,'REFERENCE_DATE_TIME');
netcdf.putVar(newid,varid,'19500101000000');

varid=netcdf.inqVarID(newid,'DATE_CREATION');
netcdf.putVar(newid,varid,writedate);

varid=netcdf.inqVarID(newid,'DATE_UPDATE');
netcdf.putVar(newid,varid,writedate);

varid=netcdf.inqVarID(newid,'PLATFORM_NUMBER');
netcdf.putVar(newid,varid,AOML.platform_number);

varid=netcdf.inqVarID(newid,'PROJECT_NAME');
netcdf.putVar(newid,varid,AOML.project_name);

varid=netcdf.inqVarID(newid,'CYCLE_NUMBER');
netcdf.putVar(newid,varid,AOML.cycle_number);

% 8/3/2017: This is commented out as we are now adding variables from 
% D-files that Annie was previously
% entering manually (see her email dated 7/25/2017)
%varid=netcdf.inqVarID(newid,'CONFIG_MISSION_NUMBER');
%netcdf.putVar(newid,varid,AOML.cycle_number);

varid=netcdf.inqVarID(newid,'DIRECTION');
netcdf.putVar(newid,varid,'AA');

varid=netcdf.inqVarID(newid,'DATA_CENTRE');
netcdf.putVar(newid,varid,['AO','AO']');

varid=netcdf.inqVarID(newid,'DC_REFERENCE');
netcdf.putVar(newid,varid,AOML.dc_reference);

if(datamode(1)=='R')dsindicator1='2B  ';end
if(datamode(1)=='A')dsindicator1='2B  ';end
if(datamode(1)=='D')dsindicator1='2C  ';end
if(datamode(2)=='R')dsindicator2='2B  ';end
if(datamode(2)=='A')dsindicator2='2B  ';end
if(datamode(2)=='D')dsindicator2='2C  ';end

varid=netcdf.inqVarID(newid,'DATA_STATE_INDICATOR');
netcdf.putVar(newid,varid,[dsindicator1,dsindicator2]');

varid=netcdf.inqVarID(newid,'PLATFORM_TYPE');
if(strcmp( AOML.platform_type(1:4), 'APEX' )==1)
  netcdf.putVar(newid,varid,['APEX                            ','APEX                            '
]');
elseif(strcmp( AOML.platform_type(1:4), 'NAVI' )==1)
  netcdf.putVar(newid,varid,['NAVIS_A                         ','NAVIS_A                         '
]');
end

varid=netcdf.inqVarID(newid,'FLOAT_SERIAL_NO');
netcdf.putVar(newid,varid,AOML.sn32');

varid=netcdf.inqVarID(newid,'FIRMWARE_VERSION');
netcdf.putVar(newid,varid,AOML.fw32');

varid=netcdf.inqVarID(newid,'WMO_INST_TYPE');
if(strcmp( AOML.platform_type(1:4), 'APEX' )==1)
  netcdf.putVar(newid,varid,['846 ','846 ']');
elseif(strcmp( AOML.platform_type(1:4), 'NAVI' )==1)
  netcdf.putVar(newid,varid,['863 ','863 ']');
end

varid=netcdf.inqVarID(newid,'POSITIONING_SYSTEM');
netcdf.putVar(newid,varid,['GPS     ','GPS     ']');


% write lat/long/juld from AOML Rfile ------

varid=netcdf.inqVarID(newid,'JULD');
netcdf.putVar(newid,varid,AOML.juld);

varid=netcdf.inqVarID(newid,'JULD_QC');
netcdf.putVar(newid,varid,AOML.juld_qc);

varid=netcdf.inqVarID(newid,'JULD_LOCATION');
netcdf.putVar(newid,varid,AOML.juld_location);

varid=netcdf.inqVarID(newid,'LATITUDE');
netcdf.putVar(newid,varid,AOML.latitude);

varid=netcdf.inqVarID(newid,'LONGITUDE');
netcdf.putVar(newid,varid,AOML.longitude);

varid=netcdf.inqVarID(newid,'POSITION_QC');
netcdf.putVar(newid,varid,AOML.position_qc);


% write PRES from AOML Rfile ------

varid=netcdf.inqVarID(newid,'PRES');
netcdf.putVar(newid, varid, AOML.aomlpres);


% close new V3.1 BR-file

netcdf.close(newid);


