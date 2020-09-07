% hcp stable
addpath /home/chidi/repos/CFN/SurfaceFormat/library/cifti-hcp
% add release library to path
addpath /home/chidi/repos/CFN/SurfaceFormat/library/gifti-release

% commandline
DATA='/home/chidi/repos/CFN/DATA';
FILE='/MNINonLinear/100307.sulc.164k_fs_LR.dscalar.nii';
WBCMD='/home/chidi/workbench/bin_linux64/wb_command';
LOC=strcat(DATA,FILE);
cii_scalar1 = ciftiopen(LOC,WBCMD);
CIFTIdata_scalar1 = cii_scalar1.cdata;

%Open another CIFTI
FILE='/MNINonLinear/100307.SmoothedMyelinMap.164k_fs_LR.dscalar.nii';
WBCMD='/home/chidi/workbench/bin_linux64/wb_command';
LOC=strcat(DATA,FILE);
cii_scalar2 = ciftiopen(LOC,WBCMD);
CIFTIdata_scalar2 = cii_scalar2.cdata;

%simply save another scalar, half the value
newcii = cii_scalar2;
newcii.cdata = CIFTIdata_scalar2*0.5
FILE='100307.changedscalar.dscalar.nii';
WBCMD='/home/chidi/workbench/bin_linux64/wb_command';
ciftisave(newcii,FILE,WBCMD)

%write out a new CIFTI time series file from scalar to timeseries
newcii = cii_scalar1;
% 1200 timepoints
newcii.cdata = repmat(CIFTIdata_scalar1,1,1200);
FILE='100307.changedfromscalartotime.dtseries.nii';
WBCMD='/home/chidi/workbench/bin_linux64/wb_command';
ciftisavereset(newcii,FILE,WBCMD);

%Open another CIFTI
FILE='/MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas.dtseries.nii';
WBCMD='/home/chidi/workbench/bin_linux64/wb_command';
LOC=strcat(DATA,FILE);
%Open CIFTI file using Docker image
cii_ts = ciftiopen(LOC,WBCMD);
CIFTIdata_ts = cii_ts.cdata;

%write out a new CIFTI time series file from scalar to timeseries
newcii = cii_ts;
newcii.cdata = cii_ts.cdata(:,1);
FILE='100307.changedfromtimetoscalar.dscalar.nii';
LOC=strcat(DATA,FILE);
%write out a new CIFTI time series file from timeseries to scalar
ciftisavereset(newcii,FILE,WBCMD);


