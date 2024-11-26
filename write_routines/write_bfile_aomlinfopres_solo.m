
% this function writes PRES and general info to my skeleton V3.1 BR- profile file
%
% N_PROF=2
%
% Annie Wong, January 2018
% Modified by Tmaurer for solo floats.
% UPDATED 7/19/2022 to accomadate dynamic pressure axes identification (ie for floats that turn off pH sensors mid-life!); TM
% UPDATED 2/5/2024 to add WMO_INST_TYPE for new solo "S2A" platform
%           deployments (per specification in Argo reference table 8)

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
dirstr = repmat('A',1,INFO.pres_axes_ct);
netcdf.putVar(newid,varid,dirstr);

varid=netcdf.inqVarID(newid,'DATA_CENTRE');
dcstr = repmat('AO',1,INFO.pres_axes_ct);
netcdf.putVar(newid,varid,dcstr');

varid=netcdf.inqVarID(newid,'DC_REFERENCE');
netcdf.putVar(newid,varid,AOML.dc_reference);

for idmi = 1:INFO.pres_axes_ct
if(datamode(idmi)=='R')tmpD='2B  ';end
if(datamode(idmi)=='A')tmpD='2B  ';end
if(datamode(idmi)=='D')tmpD='2C  ';end
dsindicator{num2str(idmi)}= tmpD;
end
dsindicatorFULL=[];
for idmi2 = 1:length(dsindicator)
dsindicatorFULL = [dsindicatorFULL,dsindicator{idmi2}];
end
% if(datamode(2)=='R')dsindicator2='2B  ';end
% if(datamode(2)=='A')dsindicator2='2B  ';end
% if(datamode(2)=='D')dsindicator2='2C  ';end

varid=netcdf.inqVarID(newid,'DATA_STATE_INDICATOR');
netcdf.putVar(newid,varid,dsindicatorFULL');

varid=netcdf.inqVarID(newid,'PLATFORM_TYPE');
if(strcmp( AOML.platform_type(1:4), 'SOLO_BGC' )==1)
  ptype = repmat('SOLO_BGC                        ',1,INFO.pres_axes_ct);
  netcdf.putVar(newid,varid,ptype');
end
if(strcmp( AOML.platform_type(1:4), 'SOLO_BGC_MRV' )==1)
  ptype = repmat('SOLO_BGC_MRV                    ',1,INFO.pres_axes_ct);
  netcdf.putVar(newid,varid,ptype');
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
elseif(strcmp( AOML.platform_type(1:8), 'SOLO_BGC' )==1) % let's make this more dynamic
    ptypestr = repmat('884 ',1,INFO.pres_axes_ct);
	netcdf.putVar(newid,varid,ptypestr');
  elseif(strcmp( AOML.platform_type(1:12), 'SOLO_BGC_MRV' )==1) % let's make this more dynamic
    ptypestr = repmat('886 ',1,INFO.pres_axes_ct);
  netcdf.putVar(newid,varid,ptypestr');
end

varid=netcdf.inqVarID(newid,'POSITIONING_SYSTEM');
PSstr = repmat('GPS     ',1,INFO.pres_axes_ct);
netcdf.putVar(newid,varid,PSstr');


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


