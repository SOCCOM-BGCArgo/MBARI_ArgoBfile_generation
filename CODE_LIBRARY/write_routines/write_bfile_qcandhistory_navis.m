%
% This function carries out rtqc tests for DOXY and CHLA
%
% Annie Wong, January 2018
%----------------------------------------------------------------

% get MBARI data ------

doxy=[HR.DOXY;LR.DOXY(deepindex)];
pres=[HR.PRES;LR.PRES(deepindex)];


% use qc character strings that are edited and carried over from write_mbaridata_navistypes ------

% only proceed if there are non-empty doxy data ------

good=find(doxy_qc~='9'&doxy_qc~=' ');
if(isempty(good)==0)

% global range test 6 ------

%--------------------------------------------------------------------------------------
%bad=find(doxy~=99999&(doxy<-5|doxy>600));
%doxy_qc(bad)='4';
%if(param_datamode(1,5)=='A')doxy_adj_qc(bad)='4';end
%
% spike test 9 ------
%
%for j=2:nlevels-1
%  if(sum(doxy(j-1:j+1))<9999) %only do this test if there is no missing value in 3 levels
%    testdoxy = abs(doxy(j)-(doxy(j+1)+doxy(j-1))/2) - abs((doxy(j+1)-doxy(j-1))/2);
%    if( (abs(testdoxy)>50&pres(j)<500) | (abs(testdoxy)>25&pres(j)>=500) )
%       doxy_qc(j)='4';
%       if(param_datamode(1,5)=='A')doxy_adj_qc(j)='4';end
%    end
%  end
%end
%
%% gradient test 11 ------
%
%for j=2:nlevels-1
%  if(sum(doxy(j-1:j+1))<9999) %only do this test if there is no missing value in 3 levels
%    testdoxy = doxy(j)-(doxy(j+1)+doxy(j-1))/2;
%    if( (abs(testdoxy)>50&pres(j)<500) | (abs(testdoxy)>25&pres(j)>=500) )
%       doxy_qc(j)='4';
%       if(param_datamode(1,5)=='A')doxy_adj_qc(j)='4';end
%    end
%  end
%end
%---------------------------------------------------------------------------------------
end % good doxy


% only proceed if there are non-empty chla data ------

if(exist('LR.CHLA','var')==1 & exist('HR.CHLA','var')==1)
chla=[HR.CHLA;LR.CHLA(deepindex)];

good=find(chla_qc~='9'&chla_qc~=' ');
if(isempty(good)==0)

% global range test 6 ------

bad=find(chla~=99999&(chla<-.1|chla>50));
chla_qc(bad)='4';
if(param_datamode(1,7)=='A')chla_adj_qc(bad)='4';end

% spike test 9 ------

missing=find(chla>99998);
if(isempty(missing)==1) %only do this test if there is no missing value

chla_runmedian=NaN.*ones(nlevels,1);
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
if(param_datamode(1,7)=='A')chla_adj_qc(bad)='4';end

end % no missing chla
end % good chla
end % ifexist chla


% write to BR-file ------

fid=netcdf.open(filenameBR,'write');

%varid=netcdf.inqVarID(fid,'DOXY_QC');
%netcdf.putVar(fid, varid, [0 0], [nlevels 1], doxy_qc);
%if(param_datamode(1,5)=='A')
%  varid=netcdf.inqVarID(fid,'DOXY_ADJUSTED_QC');
%  netcdf.putVar(fid, varid, [0 0], [nlevels 1], doxy_adj_qc);
%end

if(exist('LR.CHLA','var')==1 & exist('HR.CHLA','var')==1)
  varid=netcdf.inqVarID(fid,'CHLA_QC');
  netcdf.putVar(fid, varid, [0 0], [nlevels 1], chla_qc);
  if(chladatamode=='A')
    varid=netcdf.inqVarID(fid,'CHLA_ADJUSTED_QC');
    netcdf.putVar(fid, varid, [0 0], [nlevels 1], chla_adj_qc);
  end
end


% write HISTORY section for NPROF=1 and NPROF=2------
% Test 6 global range test = 64;
% Test 9 spike test = 512;
% Test 11 gradient test = 2048;
% Test 17 visual qc test = 131072;
% dec2hex(sum([64,512,2048,131072])) = 20A40;
% dec2hex(131072) = 20000;

nhistory=4; %easier to have this fixed
step={'ARFM','ARGQ','ARCA','ARSQ'; 'ARFM','ARGQ','ARCA','ARSQ'};
action={'IP  ','QCP$','IP  ','IP  '; 'IP  ','QCP$','IP  ','IP  '};
qctest={'                ','20A40           ','                ','                '; '                ','20000           ','                ','                '};

for i=1:nhistory
  for j=1:2

varid=netcdf.inqVarID(fid,'HISTORY_INSTITUTION');
netcdf.putVar( fid, varid, [0 j-1 i-1], [4 1 1], 'MB  ');

varid=netcdf.inqVarID(fid,'HISTORY_STEP');
netcdf.putVar( fid, varid, [0 j-1 i-1], [4 1 1], step{j,i} );

%  varid=netcdf.inqVarID(fid,'HISTORY_SOFTWARE');
%  z=hist_software(:,1,i);
%  netcdf.putVar( fid, varid, [0 j-1 i-1], [4 1 1], z' );

%  varid=netcdf.inqVarID(fid,'HISTORY_SOFTWARE_RELEASE');
%  z=hist_software_release(:,1,i);
%  netcdf.putVar( fid, varid, [0 j-1 i-1], [4 1 1], z' );

varid=netcdf.inqVarID(fid,'HISTORY_DATE');
netcdf.putVar( fid, varid, [0 j-1 i-1], [14 1 1], writedate );

varid=netcdf.inqVarID(fid,'HISTORY_ACTION');
netcdf.putVar( fid, varid, [0 j-1 i-1], [4 1 1], action{j,i} );

varid=netcdf.inqVarID(fid,'HISTORY_QCTEST');
netcdf.putVar( fid, varid, [0 j-1 i-1], [16 1 1], qctest{j,i} );

  end %j=nprof
end %nhistory


% close the BR-file ------

netcdf.close(fid);


