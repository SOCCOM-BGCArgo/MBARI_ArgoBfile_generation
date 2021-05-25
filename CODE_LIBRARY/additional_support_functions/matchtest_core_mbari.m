function MT = matchtest_core_mbari(MB,AOML,AorN)

% This routine assembles the primary profile (NPROF=1) with mixed sampling scheme
% from the MBARI mat files. Then it compares P,T,S in NPROF=1 and NPROF=2
% in the MBARI mat files and in the AOML R-files.
%
% e.g. wmo_id='5904188';
%
%
% USE AS: MT = matchtest_core_mbari(MB,AOML)
%
% INPUTS:
%    MB : Structure containing HR, LR, and INFO structures from MBARI
%         matfile
%    AOML: Structure containing parameters from loading AOML R or D nc file
%    AorN: 'APEX' or 'NAVIS'
%
% OUTPUTS:  
%    MT: structure containing fields
%           - statuss = 0,1 (matchtest routine completed?)
%           - checknlevels1 = 0,1 (HiRES match success?)
%           - checknlevels2 = 0,1 (LoRES match success?)
%           - notes = Hires_mismatch, Lores_mismatch, APEXnohires, AllGood
%
% SUPPORTING FUNCTIONS:
%    
%
%
% AUTHOR: 
%   Original Author: Annie Wong <apsw@uw.edu>
%   Script modified into function, and thresholds changed by:
%   Tanya Maurer
%   MBARI
%   tmaurer@mbari.org
%
% DATE: 4/25/2017
% UPDATES:
% NOTES: 
% ************************************************************************
%
% ************************************************************************
%


% assemble P/T/S from mbari mat file ------

if(isempty(MB.HR.PRES)==0) % assemble NPROF=1 from MBARI mat files
  maxhp=max(MB.HR.PRES);
  deepindex=find(MB.LR.PRES>maxhp);
  MBpres_nprof1=[MB.HR.PRES;MB.LR.PRES(deepindex)];
  MBtemp_nprof1=[MB.HR.TEMP;MB.LR.TEMP(deepindex)];
  MBsal_nprof1=[MB.HR.PSAL;MB.LR.PSAL(deepindex)];
else
  MBpres_nprof1=[];
  MBtemp_nprof1=[];
  MBsal_nprof1=[];
end

MBpres_nprof2=MB.LR.PRES;
MBtemp_nprof2=MB.LR.TEMP;
MBsal_nprof2=MB.LR.PSAL;


% assemble P/T/S from aoml nc file ------

aomlpres_nprof1=AOML.aomlpres(:,1);
aomltemp_nprof1=AOML.aomltemp(:,1);
aomlsal_nprof1=AOML.aomlsal(:,1);

fillfloat=single(99999.);
ii=find(AOML.aomlpres(:,2)~=fillfloat);
aomlpres_nprof2=AOML.aomlpres(ii,2);
aomltemp_nprof2=AOML.aomltemp(ii,2);
aomlsal_nprof2=AOML.aomlsal(ii,2);

% save('temptanya.mat')
% compare data from MBARI and AOML ----------
if( isempty(find(aomlpres_nprof1~=fillfloat)) && isempty(MBpres_nprof1) && strcmp(AorN,'APEX')==1) 
    MT.statuss = 0;
    MT.notes = 'APEXnohires';  
    MT.checknlevels1=1; %allow to proceed without matchtest check. (ie float 0068, wmo 5903717)
else
    Pdiff1 = abs(MBpres_nprof1-aomlpres_nprof1);
    Tdiff1 = abs(MBtemp_nprof1-aomltemp_nprof1);
    Sdiff1 = abs(MBsal_nprof1-aomlsal_nprof1);
    if(AOML.nlevels~=length(MBpres_nprof1))
      MT.checknlevels1=0;
    else
      checkp1=find(Pdiff1>=0.006); %from 0.06 to 0.006, 5/20/19, per Annie Wong.
      checkt1=find(Tdiff1>=0.0006);
      checks1=find(Sdiff1>=0.0006);
      if(isempty(checkp1)==0|| isempty(checkt1)==0|| isempty(checks1)==0)
        MT.checknlevels1=0;
        MT.notes = 'HiRES_mismatch';
      else
        MT.checknlevels1=1;
        MT.notes = 'AllGood';
      end
    end
end

% whos MBpres_nprof2 aomlpres_nprof2
Pdiff2 = abs(MBpres_nprof2-aomlpres_nprof2);
Tdiff2 = abs(MBtemp_nprof2-aomltemp_nprof2);
Sdiff2 = abs(MBsal_nprof2-aomlsal_nprof2);

if(length(aomlpres_nprof2)~=length(MBpres_nprof2))
  MT.checknlevels2=0;
else
  checkp2=find(Pdiff2>=0.006); %from 0.06 to 0.006, 5/20/19, per Annie Wong.
  checkt2=find(Tdiff2>=0.0006);
  checks2=find(Sdiff2>=0.0006);
  if(isempty(checkp2)==0|| isempty(checkt2)==0|| isempty(checks2)==0)
    MT.checknlevels2=0;
    MT.notes = 'LoRES_mismatch';
  else
    MT.checknlevels2=1;
    MT.notes = 'AllGood';
  end
end
MT.statuss=1;
% end


