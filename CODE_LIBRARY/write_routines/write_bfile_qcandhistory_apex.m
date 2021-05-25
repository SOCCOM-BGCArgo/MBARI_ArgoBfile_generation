%
% This function carries out rtqc tests for DOXY and CHLA
%
% Annie Wong, January 2018
%----------------------------------------------------------------

% get MBARI data ------

doxy=LR.DOXY;
pres=LR.PRES;


% use qc character strings that are edited and carried over from write_mbaridata_apextypes ------

% only proceed if there are non-empty doxy data ------

good=find(doxy_qc~='9'&doxy_qc~=' ');
if(isempty(good)==0)

% global range test 6 ------

%--------------------------------------------------------------------------
% COMMENT OUT THESE QC CHECKS PER ANNIE WONG, SEE EMAIL 6/27/17 T.Maurer
%--------------------------------------------------------------------------
% bad=find(doxy~=99999&(doxy<-5|doxy>600));
% doxy_qc(bad)='4';
% if(param_datamode(2,4)=='A')doxy_adj_qc(bad)='4';end
% 
% % spike test 9 ------
% 
% for j=2:nlowres-1
%   if(sum(doxy(j-1:j+1))<9999) %only do this test if there is no missing value in 3 levels
%     testdoxy = abs(doxy(j)-(doxy(j+1)+doxy(j-1))/2) - abs((doxy(j+1)-doxy(j-1))/2);
%     if( (abs(testdoxy)>50&pres(j)<500) | (abs(testdoxy)>25&pres(j)>=500) )
%        doxy_qc(j)='4';
%        if(param_datamode(2,4)=='A')doxy_adj_qc(j)='4';end
%     end
%   end
% end
% 
% % gradient test 11 ------
% 
% for j=2:nlowres-1
%   if(sum(doxy(j-1:j+1))<9999) %only do this test if there is no missing value in 3 levels
%     testdoxy = doxy(j)-(doxy(j+1)+doxy(j-1))/2;
%     if( (abs(testdoxy)>50&pres(j)<500) | (abs(testdoxy)>25&pres(j)>=500) )
%        doxy_qc(j)='4';
%        if(param_datamode(2,4)=='A')doxy_adj_qc(j)='4';end
%     end
%   end
% end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

end % good doxy


% only proceed if there are non-empty chla data ------

if(exist('LR.CHLA','var')==1)chla=LR.CHLA;

good=find(chla_qc~='9'&chla_qc~=' ');
if(isempty(good)==0)

% global range test 6 ------

bad=find(chla~=99999&(chla<-.1|chla>50));
chla_qc(bad)='4';
if(chladatamode=='A')chla_adj_qc(bad)='4';end

% spike test 9 ------

missing=find(chla>99998);
if(isempty(missing)==1) %only do this test if there is no missing value

chla_runmedian=NaN.*ones(nlowres,1);
for j=3:nlowres-2
  chla_runmedian(j)=median(chla(j-2:j+2));
end
chla_runmedian(1:2)=chla_runmedian(3);
chla_runmedian(nlowres-1:nlowres)=chla_runmedian(nlowres-2);
residual=chla-chla_runmedian;

%sort residual in ascending order, then find the value of residual
%at index i where i = 10% * number of samples in the profile
res_sort=sort(residual);
index10=.1*nlowres;
q10residual=res_sort(floor(index10)); %I am shifting the bias towards the low end by using floor

bad=find(round(residual,4)<round(2*q10residual,4)); %compare numbers rounded to 4 decimals
chla_qc(bad)='4';
if(chladatamode=='A')chla_adj_qc(bad)='4';end

end % no missing chla
end % good chla
end % ifexist chla


% write to BR-file ------

fid=netcdf.open(filenameBR,'write');

%varid=netcdf.inqVarID(fid,'DOXY_QC');
%netcdf.putVar(fid, varid, [0 1], [nlowres 1], doxy_qc);
%if(param_datamode(2,4)=='A')
%  varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_QC');
%  netcdf.putVar(fid, varid, [0 1], [nlowres 1], doxy_adj_qc);
%end

if(exist('LR.CHLA','var')==1)
  varid=netcdf.inqVarID(fid,'CHLA_QC');
  netcdf.putVar(fid, varid, [0 1], [nlowres 1], chla_qc);
  if(chladatamode=='A')
    varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED_QC');
    netcdf.putVar(fid, varid, [0 1], [nlowres 1], chla_adj_qc);
  end
end


% write HISTORY section for NPROF=2 ------
% Test 6 global range test = 64;
% Test 9 spike test = 512;
% Test 11 gradient test = 2048;
% Test 17 visual qc test = 131072;
% dec2hex(sum([64,512,2048,131072])) = 20A40

if(datamode(2)=='R')
  step=['ARFM';'ARGQ'];
  action=['IP  ';'QCP$'];
  qctest=['                ';'20A40           '];
  nhistory=2;
elseif(datamode(2)=='A')
  step=['ARFM';'ARGQ';'ARCA'];
  action=['IP  ';'QCP$';'IP  '];
  qctest=['                ';'20A40           ';'                '];
  nhistory=3;
else(datamode(2)=='D')
  step=['ARFM';'ARGQ';'ARCA';'ARSQ'];
  action=['IP  ';'QCP$';'IP  ';'IP  '];
  qctest=['                ';'20A40           ';'                ';'                '];
  nhistory=4;	
end


for i=1:nhistory

varid=netcdf.inqVarID(fid,'HISTORY_INSTITUTION');
netcdf.putVar( fid, varid, [0 1 i-1], [4 1 1], 'MB  ');

varid=netcdf.inqVarID(fid,'HISTORY_STEP');
netcdf.putVar( fid, varid, [0 1 i-1], [4 1 1], step(i,:) );

%  varid=netcdf.inqVarID(fid,'HISTORY_SOFTWARE');
%  z=hist_software(:,1,i);
%  netcdf.putVar( fid, varid, [0 1 i-1], [4 1 1], z' );

%  varid=netcdf.inqVarID(fid,'HISTORY_SOFTWARE_RELEASE');
%  z=hist_software_release(:,1,i);
%  netcdf.putVar( fid, varid, [0 1 i-1], [4 1 1], z' );

%  varid=netcdf.inqVarID(fid,'HISTORY_REFERENCE');
%  z=hist_reference(:,1,i);
%  netcdf.putVar( fid, varid, [0 1 i-1], [64 1 1], z' );

  varid=netcdf.inqVarID(fid,'HISTORY_DATE');
  netcdf.putVar( fid, varid, [0 1 i-1], [14 1 1], writedate );

  varid=netcdf.inqVarID(fid,'HISTORY_ACTION');
  netcdf.putVar( fid, varid, [0 1 i-1], [4 1 1], action(i,:) );

%  varid=netcdf.inqVarID(fid,'HISTORY_PARAMETER');
%  z=hist_parameter(:,1,i);
%  netcdf.putVar( fid, varid, [0 1 i-1], [16 1 1], z' );

%  varid=netcdf.inqVarID(fid,'HISTORY_START_PRES');
%  z=hist_start_pres(1,i);
%  netcdf.putVar( fid, varid, [1 i-1], [1 1], z );

%  varid=netcdf.inqVarID(fid,'HISTORY_STOP_PRES');
%  z=hist_stop_pres(1,i);
%  netcdf.putVar( fid, varid, [1 i-1], [1 1], z );

%  varid=netcdf.inqVarID(fid,'HISTORY_PREVIOUS_VALUE');
%  z=hist_previous_value(1,i);
%  netcdf.putVar( fid, varid, [1 i-1], [1 1], z );

varid=netcdf.inqVarID(fid,'HISTORY_QCTEST');
netcdf.putVar( fid, varid, [0 1 i-1], [16 1 1], qctest(i,:) );

end %nhistory


% close the BR-file ------

netcdf.close(fid);


