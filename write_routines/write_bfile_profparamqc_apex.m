
% use qc character strings that are edited and carried over from write_mbaridata_apextypes & write_bfile_qcandhistory ------

% open BR-file ------

fid=netcdf.open(filenameBR,'write');


% set PROFILE_DOXY_QC ------
if(exist('doxydatamode','var')==1)
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
        netcdf.putVar(fid, varid, [1], [1], profile_qcchlaF);
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

%--------------------------------------------------------------------------
% TM Jan2022: Now insert the datamode checks for irradiance variables!
% Variable names are currently hard-wired to the wavelengths used...
% Could be made more generic, but then the wavelengths are buried in a
% single variable (less explicit).  Plus, the Argo variables need to be
% explicitly defined...think more about how best to make this flexible
% (without heavy use of 'eval' function??)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% ***   OCR380   ***
if(exist('irr380datamode','var')==1)
    
    if(irr380datamode=='A'|irr380datamode=='D')
        qcocr380=ocr380_adj_qc;
    else
        qcocr380=ocr380_qc;
    end
    lenzero=length(find(qcocr380=='0')); %ocr only...as we begin, no QC!  All qc set to '0'=no qc performed.
    lennot9=length(find(qcocr380~='9'));
    lengood=length(find(qcocr380=='1'|qcocr380=='2'|qcocr380=='5'|qcocr380=='8'));
    if lenzero == length(qcocr380)
        profile_qcocr380 = ' ';
    else
        if(lennot9~=0)
            if lengood/lennot9 == 1
                profile_qcocr380='A';
            elseif lengood/lennot9 >= .75
                profile_qcocr380='B';
            elseif lengood/lennot9 >= .50
                profile_qcocr380='C';
            elseif lengood/lennot9 >= .25
                profile_qcocr380='D';
            elseif lengood/lennot9 > .0
                profile_qcocr380='E';
            else
                profile_qcocr380='F';
            end
            
            varid=netcdf.inqVarID(fid,'PROFILE_DOWN_IRRADIANCE380_QC');
            netcdf.putVar(fid, varid, [1], [1], profile_qcocr380);
        end
    end
end

% ***   OCR412   ***
if(exist('irr412datamode','var')==1)
    
    if(irr412datamode=='A'|irr412datamode=='D')
        qcocr412=ocr412_adj_qc;
    else
        qcocr412=ocr412_qc;
    end
    
    lenzero=length(find(qcocr412=='0')); %ocr only...as we begin, no QC!  All qc set to '0'=no qc performed.
    lennot9=length(find(qcocr412~='9'));
    lengood=length(find(qcocr412=='1'|qcocr412=='2'|qcocr412=='5'|qcocr412=='8'));
    if lenzero == length(qcocr412)
        profile_qcocr412 = ' ';
    else
        if(lennot9~=0)
            if lengood/lennot9 == 1
                profile_qcocr412='A';
            elseif lengood/lennot9 >= .75
                profile_qcocr412='B';
            elseif lengood/lennot9 >= .50
                profile_qcocr412='C';
            elseif lengood/lennot9 >= .25
                profile_qcocr412='D';
            elseif lengood/lennot9 > .0
                profile_qcocr412='E';
            else
                profile_qcocr412='F';
            end
            
            varid=netcdf.inqVarID(fid,'PROFILE_DOWN_IRRADIANCE412_QC');
            netcdf.putVar(fid, varid, [1], [1], profile_qcocr412);
        end
    end
end

% ***   OCR443   ***
if(exist('irr443datamode','var')==1)
    
    if(irr443datamode=='A'|irr443datamode=='D')
        qcocr443=ocr443_adj_qc;
    else
        qcocr443=ocr443_qc;
    end
    
    lenzero=length(find(qcocr443=='0')); %ocr only...as we begin, no QC!  All qc set to '0'=no qc performed.
    lennot9=length(find(qcocr443~='9'));
    lengood=length(find(qcocr443=='1'|qcocr443=='2'|qcocr443=='5'|qcocr443=='8'));
    if lenzero == length(qcocr443)
        profile_qcocr443 = ' ';
    else
        if(lennot9~=0)
            if lengood/lennot9 == 1
                profile_qcocr443='A';
            elseif lengood/lennot9 >= .75
                profile_qcocr443='B';
            elseif lengood/lennot9 >= .50
                profile_qcocr443='C';
            elseif lengood/lennot9 >= .25
                profile_qcocr443='D';
            elseif lengood/lennot9 > .0
                profile_qcocr443='E';
            else
                profile_qcocr443='F';
            end
            
            varid=netcdf.inqVarID(fid,'PROFILE_DOWN_IRRADIANCE443_QC');
            netcdf.putVar(fid, varid, [1], [1], profile_qcocr443);
        end
    end
end

% ***   OCR490   ***
if(exist('irr490datamode','var')==1)
    
    if(irr490datamode=='A'|irr490datamode=='D')
        qcocr490=ocr490_adj_qc;
    else
        qcocr490=ocr490_qc;
    end
    
    lenzero=length(find(qcocr490=='0')); %ocr only...as we begin, no QC!  All qc set to '0'=no qc performed.
    lennot9=length(find(qcocr490~='9'));
    lengood=length(find(qcocr490=='1'|qcocr490=='2'|qcocr490=='5'|qcocr490=='8'));
    if lenzero == length(qcocr490)
        profile_qcocr490 = ' ';
    else
        if(lennot9~=0)
            if lengood/lennot9 == 1
                profile_qcocr490='A';
            elseif lengood/lennot9 >= .75
                profile_qcocr490='B';
            elseif lengood/lennot9 >= .50
                profile_qcocr490='C';
            elseif lengood/lennot9 >= .25
                profile_qcocr490='D';
            elseif lengood/lennot9 > .0
                profile_qcocr490='E';
            else
                profile_qcocr490='F';
            end
            
            varid=netcdf.inqVarID(fid,'PROFILE_DOWN_IRRADIANCE490_QC');
            netcdf.putVar(fid, varid, [1], [1], profile_qcocr490);
        end
    end
end

% ***   OCRPAR   ***
if(exist('pardatamode','var')==1)
    
    if(pardatamode=='A'|pardatamode=='D')
        qcocrpar=ocrpar_adj_qc;
    else
        qcocrpar=ocrpar_qc;
    end
    
    lenzero=length(find(qcocrpar=='0')); %ocr only...as we begin, no QC!  All qc set to '0'=no qc performed.
    lennot9=length(find(qcocrpar~='9'));
    lengood=length(find(qcocrpar=='1'|qcocrpar=='2'|qcocrpar=='5'|qcocrpar=='8'));
    if lenzero == length(qcocrpar)
        profile_qcocrpar = ' ';
    else
        if(lennot9~=0)
            if lengood/lennot9 == 1
                profile_qcocrpar='A';
            elseif lengood/lennot9 >= .75
                profile_qcocrpar='B';
            elseif lengood/lennot9 >= .50
                profile_qcocrpar='C';
            elseif lengood/lennot9 >= .25
                profile_qcocrpar='D';
            elseif lengood/lennot9 > .0
                profile_qcocrpar='E';
            else
                profile_qcocrpar='F';
            end
            
            varid=netcdf.inqVarID(fid,'PROFILE_DOWNWELLING_PAR_QC');
            netcdf.putVar(fid, varid, [1], [1], profile_qcocrpar);
        end
    end
end

% close the BR-file ------

netcdf.close(fid);


