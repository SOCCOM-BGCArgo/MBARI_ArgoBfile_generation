
% use qc character strings that are edited and carried over from write_mbaridata_apextypes & write_bfile_qcandhistory ------

% open BR-file ------

fid=netcdf.open(filenameBR,'write');


% set PROFILE_DOXY_QC ------

if(doxydatamode=='A'|doxydatamode=='D')
  qcdoxy=doxy_adj_qc;
else
  qcdoxy=doxy_qc;
end

lennot9=length(find(qcdoxy~='9'));
lengood=length(find(qcdoxy=='1'|qcdoxy=='2'|qcdoxy=='5'|qcdoxy=='8'));
if(lennot9~=0)
  if lengood/lennot9 == 1
    profile_qcdoxy='A';
  elseif lengood/lennot9 >= .75
    profile_qcdoxy='B';
  elseif lengood/lennot9 >= .50
    profile_qcdoxy='C';
  elseif lengood/lennot9 >= .25
    profile_qcdoxy='D';
  elseif lengood/lennot9 > .0
    profile_qcdoxy='E';
  else
    profile_qcdoxy='F';
  end

  varid=netcdf.inqVarID(fid,'PROFILE_DOXY_QC');
  netcdf.putVar(fid, varid, [1], [1], profile_qcdoxy);
end


% set PROFILE_CHLA_QC ------

if(exist('chladatamode','var')==1)

if(chladatamode=='A'|chladatamode=='D')
  qcchla=chla_adj_qc;
else
  qcchla=chla_qc;
end

lennot9=length(find(qcchla~='9'));
lengood=length(find(qcchla=='1'|qcchla=='2'|qcchla=='5'|qcchla=='8'));
if(lennot9~=0)
  if lengood/lennot9 == 1
    profile_qcchla='A';
  elseif lengood/lennot9 >= .75
    profile_qcchla='B';
  elseif lengood/lennot9 >= .50
    profile_qcchla='C';
  elseif lengood/lennot9 >= .25
    profile_qcchla='D';
  elseif lengood/lennot9 > .0
    profile_qcchla='E';
  else
    profile_qcchla='F';
  end

  varid=netcdf.inqVarID(fid,'PROFILE_CHLA_QC');
  netcdf.putVar(fid, varid, [1], [1], profile_qcchla);
end

end


% set PROFILE_BBP700_QC ------

if(exist('bbpdatamode','var')==1)

if(bbpdatamode=='A'|bbpdatamode=='D')
  qcbbp=bbp700_adj_qc;
else
  qcbbp=bbp700_qc;
end

lennot9=length(find(qcbbp~='9'));
lengood=length(find(qcbbp=='1'|qcbbp=='2'|qcbbp=='5'|qcbbp=='8'));
if(lennot9~=0)
  if lengood/lennot9 == 1
    profile_qcbbp='A';
  elseif lengood/lennot9 >= .75
    profile_qcbbp='B';
  elseif lengood/lennot9 >= .50
    profile_qcbbp='C';
  elseif lengood/lennot9 >= .25
    profile_qcbbp='D';
  elseif lengood/lennot9 > .0
    profile_qcbbp='E';
  else
    profile_qcbbp='F';
  end

  varid=netcdf.inqVarID(fid,'PROFILE_BBP700_QC');
  netcdf.putVar(fid, varid, [1], [1], profile_qcbbp);
end

end


% set PROFILE_PH_IN_SITU_TOTAL_QC ------

if(exist('phdatamode','var')==1)

if(phdatamode=='A'|phdatamode=='D')
  qcph=ph_in_situ_total_adj_qc;
else
  qcph=ph_in_situ_total_qc;
end

lennot9=length(find(qcph~='9'));
lengood=length(find(qcph=='1'|qcph=='2'|qcph=='5'|qcph=='8'));
if(lennot9~=0)
  if lengood/lennot9 == 1
    profile_qcph='A';
  elseif lengood/lennot9 >= .75
    profile_qcph='B';
  elseif lengood/lennot9 >= .50
    profile_qcph='C';
  elseif lengood/lennot9 >= .25
    profile_qcph='D';
  elseif lengood/lennot9 > .0
    profile_qcph='E';
  else
    profile_qcph='F';
  end

  varid=netcdf.inqVarID(fid,'PROFILE_PH_IN_SITU_TOTAL_QC');
  netcdf.putVar(fid, varid, [1], [1], profile_qcph);
end

end


% set PROFILE_NITRATE_QC ------

if(exist('nidatamode','var')==1)

if(nidatamode=='A'|nidatamode=='D')
  qcni=nitrate_adj_qc;
else
  qcni=nitrate_qc;
end

lennot9=length(find(qcni~='9'));
lengood=length(find(qcni=='1'|qcni=='2'|qcni=='5'|qcni=='8'));
if(lennot9~=0)
  if lengood/lennot9 == 1
    profile_qcni='A';
  elseif lengood/lennot9 >= .75
    profile_qcni='B';
  elseif lengood/lennot9 >= .50
    profile_qcni='C';
  elseif lengood/lennot9 >= .25
    profile_qcni='D';
  elseif lengood/lennot9 > .0
    profile_qcni='E';
  else
    profile_qcni='F';
  end

  varid=netcdf.inqVarID(fid,'PROFILE_NITRATE_QC');
  netcdf.putVar(fid, varid, [1], [1], profile_qcni);
end

end


% close the BR-file ------

netcdf.close(fid);


