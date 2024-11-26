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
% UPDATES: 8/30/21 TM added code to explicitly modify the pres matchtest
%           threshold for older floats (breaks with more stringent threshold.  See
%           correspondence with Annie Wong).  Easiest way to do this was to
%           add a list of affected WMOs (all old floats...).
% NOTES: 
% ************************************************************************
%
% ************************************************************************
%

% TM 8/30/21--------------------------------------------------------------
FLT_OldPresThresh = [5904655 5904680 5904094 5904124 5903741 5904128 5904035,...
                     5903893 5903892 5904021 5904127 5904125 5903611 5904104,...
                     5904105 5904107 5904108 5903714 5903753 5903887 5903754,...
                     5903592 5903711 5903755 5903593 5903712 5904034 5903377,...
                     5903594 5903405 5903718 5903612 5903742 5903272 5903891,...
                     5903385 1901379 5903274 1901378 5903586 5902112 5901492,...
                     5901468 5902128 5904479 5903890 5903717]; 
                 
mywmoid = str2num(MB.INFO.WMO_ID);
xfind = find(FLT_OldPresThresh == mywmoid);
if ~isempty(xfind)
    PRESthresh = 0.06;
else
    PRESthresh = 0.006;
end
% end TM 8/30/21-----------------------------------------------------------
                 

% assemble P/T/S from mbari mat file ------
if(isempty(MB.HR.PRES)==0) % assemble NPROF=1 from MBARI mat files
    maxhp=max(MB.HR.PRES);
    myvar = MB.INFO;
    %MB.INFO.CpActivationP.  No CpActivationP for the solos.
    if isfield(myvar,'CpActivationP')
        cpACT = MB.INFO.CpActivationP;
        if ~isnan(cpACT) && (cpACT-maxhp)<1
            %         deepindex=find(MB.LR.PRES>maxhp);

            deepindex=find(MB.LR.PRES>cpACT);
            MBpres_nprof1=[MB.HR.PRES;MB.LR.PRES(deepindex)];
            MBtemp_nprof1=[MB.HR.TEMP;MB.LR.TEMP(deepindex)];
            MBsal_nprof1=[MB.HR.PSAL;MB.LR.PSAL(deepindex)];
        else
            deepindex=find(MB.LR.PRES>maxhp);
            MBpres_nprof1=[MB.HR.PRES;MB.LR.PRES(deepindex)];
            MBtemp_nprof1=[MB.HR.TEMP;MB.LR.TEMP(deepindex)];
            MBsal_nprof1=[MB.HR.PSAL;MB.LR.PSAL(deepindex)];
        end
    else
        deepindex=find(MB.LR.PRES>maxhp);
        MBpres_nprof1=[MB.HR.PRES;MB.LR.PRES(deepindex)];
        MBtemp_nprof1=[MB.HR.TEMP;MB.LR.TEMP(deepindex)];
        MBsal_nprof1=[MB.HR.PSAL;MB.LR.PSAL(deepindex)];
    end
else
    MBpres_nprof1=[];
    MBtemp_nprof1=[];
    MBsal_nprof1=[];
end
% keyboard
MBpres_nprof2=MB.LR.PRES;
MBtemp_nprof2=MB.LR.TEMP;
MBsal_nprof2=MB.LR.PSAL;

if isfield(MB,'OCR') == 1
	if (isempty(MB.OCR.PRES)==0) % for OCR only floats, the OCR axis becomes nprof=2
		MBpres_nprof2=MB.OCR.PRES; %just OCR!
		MBtemp_nprof2=NaN(length(MBpres_nprof2),1); %no temp on this axis!
		MBsal_nprof2=NaN(length(MBpres_nprof2),1); %no sal on this axis!
	end
end

% assemble P/T/S from aoml nc file ------

aomlpres_nprof1=AOML.aomlpres(:,1);
aomltemp_nprof1=AOML.aomltemp(:,1);
aomlsal_nprof1=AOML.aomlsal(:,1);

fillfloat=single(99999.);
ii=find(AOML.aomlpres(:,2)~=fillfloat);
aomlpres_nprof2=AOML.aomlpres(ii,2);
aomltemp_nprof2=AOML.aomltemp(ii,2);
aomlsal_nprof2=AOML.aomlsal(ii,2);


% compare data from MBARI and AOML ----------
if( isempty(find(aomlpres_nprof1~=fillfloat)) && isempty(MBpres_nprof1) && strcmp(AorN,'APEX')==1) 
    MT.statuss = 0;
    MT.notes = 'APEXnohires';  
    MT.checknlevels1=1; %allow to proceed without matchtest check. (ie float 0068, wmo 5903717)
else
    
% open MBpres_nprof1
% open aomlpres_nprof1
% % whos MBpres_nprof1 aomlpres_nprof1
% keyboard
% size(MBpres_nprof1)
% size(aomlpres_nprof1)

% 
    Pdiff1 = abs(MBpres_nprof1-aomlpres_nprof1);
    Tdiff1 = abs(MBtemp_nprof1-aomltemp_nprof1);
    Sdiff1 = abs(MBsal_nprof1-aomlsal_nprof1);
    if(AOML.nlevels~=length(MBpres_nprof1))
      MT.checknlevels1=0;
    else
      checkp1=find(Pdiff1>=PRESthresh); %from 0.06 to 0.006, 5/20/19, per Annie Wong.
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
  checkp2=find(Pdiff2>=PRESthresh); %from 0.06 to 0.006, 5/20/19, per Annie Wong.
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


