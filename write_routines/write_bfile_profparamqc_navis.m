
% use qc character strings that are edited and carried over from write_mbaridata_navistypes & write_bfile_qcandhistory ------

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
  netcdf.putVar(fid, varid, [0], [1], profile_qcdoxy);
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
  netcdf.putVar(fid, varid, [0], [1], profile_qcchla);
end

end

% set PROFILE_CHLA_FLUORESCENCE_QC ------

if(exist('chlaFdatamode','var')==1)

if(chlaFdatamode=='A'|chlaFdatamode=='D')
  qcchlaF=chlaF_adj_qc;
else
  qcchlaF=chlaF_qc;
end

lennot9=length(find(qcchlaF~='9'));
lengood=length(find(qcchlaF=='1'|qcchlaF=='2'|qcchlaF=='5'|qcchlaF=='8'));
if(lennot9~=0)
  if lengood/lennot9 == 1
    profile_qcchlaF='A';
  elseif lengood/lennot9 >= .75
    profile_qcchlaF='B';
  elseif lengood/lennot9 >= .50
    profile_qcchlaF='C';
  elseif lengood/lennot9 >= .25
    profile_qcchlaF='D';
  elseif lengood/lennot9 > .0
    profile_qcchlaF='E';
  else
    profile_qcchlaF='F';
  end

  varid=netcdf.inqVarID(fid,'PROFILE_CHLA_FLUORESCENCE_QC');
  netcdf.putVar(fid, varid, [0], [1], profile_qcchlaF);
end

end

% set PROFILE_BBP700_QC ------

if(exist('bbp700datamode','var')==1)

if(bbp700datamode=='A'|bbp700datamode=='D')
  qcbbp700=bbp700_adj_qc;
else
  qcbbp700=bbp700_qc;
end

lennot9=length(find(qcbbp700~='9'));
lengood=length(find(qcbbp700=='1'|qcbbp700=='2'|qcbbp700=='5'|qcbbp700=='8'));
if(lennot9~=0)
  if lengood/lennot9 == 1
    profile_qcbbp700='A';
  elseif lengood/lennot9 >= .75
    profile_qcbbp700='B';
  elseif lengood/lennot9 >= .50
    profile_qcbbp700='C';
  elseif lengood/lennot9 >= .25
    profile_qcbbp700='D';
  elseif lengood/lennot9 > .0
    profile_qcbbp700='E';
  else
    profile_qcbbp700='F';
  end

  varid=netcdf.inqVarID(fid,'PROFILE_BBP700_QC');
  netcdf.putVar(fid, varid, [0], [1], profile_qcbbp700);
end

end


% set PROFILE_BBP532_QC ------

if(exist('bbp532datamode','var')==1)

if(bbp532datamode=='A'|bbp532datamode=='D')
  qcbbp532=bbp532_adj_qc;
else
  qcbbp532=bbp532_qc;
end

lennot9=length(find(qcbbp532~='9'));
lengood=length(find(qcbbp532=='1'|qcbbp532=='2'|qcbbp532=='5'|qcbbp532=='8'));
if(lennot9~=0)
  if lengood/lennot9 == 1
    profile_qcbbp532='A';
  elseif lengood/lennot9 >= .75
    profile_qcbbp532='B';
  elseif lengood/lennot9 >= .50
    profile_qcbbp532='C';
  elseif lengood/lennot9 >= .25
    profile_qcbbp532='D';
  elseif lengood/lennot9 > .0
    profile_qcbbp532='E';
  else
    profile_qcbbp532='F';
  end

  varid=netcdf.inqVarID(fid,'PROFILE_BBP532_QC');
  netcdf.putVar(fid, varid, [0], [1], profile_qcbbp532);
end

end


% set PROFILE_CDOM_QC ------

if(exist('cdomdatamode','var')==1)

if(cdomdatamode=='A'|cdomdatamode=='D')
  qccdom=cdom_adj_qc;
else
  qccdom=cdom_qc;
end

lennot9=length(find(qccdom~='9'));
lengood=length(find(qccdom=='1'|qccdom=='2'|qccdom=='5'|qccdom=='8'));
if(lennot9~=0)
  if lengood/lennot9 == 1
    profile_qccdom='A';
  elseif lengood/lennot9 >= .75
    profile_qccdom='B';
  elseif lengood/lennot9 >= .50
    profile_qccdom='C';
  elseif lengood/lennot9 >= .25
    profile_qccdom='D';
  elseif lengood/lennot9 > .0
    profile_qccdom='E';
  else
    profile_qccdom='F';
  end

  varid=netcdf.inqVarID(fid,'PROFILE_CDOM_QC');
  netcdf.putVar(fid, varid, [0], [1], profile_qccdom);
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
  netcdf.putVar(fid, varid, [0], [1], profile_qcph);
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


% ***   OCR   ***
for ichs = 1:4
    % keyboard
if(exist('irrCHdatamode','var')==1)
    if ~exist('ocrCH_qc','var') 
        profile_qcocr{ichs}=' ';
        varid=netcdf.inqVarID(fid,'PROFILE_DOWN_IRRADIANCE380_QC');
        netcdf.putVar(fid, varid, [0], [1], profile_qcocr{ichs});
    else

        if(irrCHdatamode{ichs}=='A'|irrCHdatamode{ichs}=='D')
            qcocr{ichs}=ocrCH_adj_qc{ichs};
        else
            qcocr{ichs}=ocrCH_qc{ichs};
        end
        lenzero=length(find(qcocr{ichs}=='0')); %ocr only...as we begin, no QC!  All qc set to '0'=no qc performed.
        lennot9=length(find(qcocr{ichs}~='9'));
        lengood=length(find(qcocr{ichs}=='1'|qcocr{ichs}=='2'|qcocr{ichs}=='5'|qcocr{ichs}=='8'));
        if lenzero == length(qcocr{ichs})
            profile_qcocr{ichs} = ' ';
        else
            if(lennot9~=0)
                if lengood/lennot9 == 1
                    profile_qcocr{ichs}='A';
                elseif lengood/lennot9 >= .75
                    profile_qcocr{ichs}='B';
                elseif lengood/lennot9 >= .50
                    profile_qcocr{ichs}='C';
                elseif lengood/lennot9 >= .25
                    profile_qcocr{ichs}='D';
                elseif lengood/lennot9 > .0
                    profile_qcocr{ichs}='E';
                else
                    profile_qcocr{ichs}='F';
                end

                varid=netcdf.inqVarID(fid,['PROFILE_',BPARAMS{ichs},'_QC']);
                netcdf.putVar(fid, varid, [0], [1], profile_qcocr{ichs});
            end
        end
        clear ocr_qc
    end
end
end

% close the BR-file ------

netcdf.close(fid);


