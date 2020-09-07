% FieldTrip
addpath /home/chidi/repos/neurobase/doanalysis/SurfaceFormat/library/cifti-matlab/ft_cifti
IMAGE1='/home/chidi/repos/neurobase/DATA/MNINonLinear/100307.sulc.164k_fs_LR.dscalar.nii';

% ft_read_nifti2 was written by CPU and doesn't come with the ft library
newhdr = ft_read_nifti2(IMAGE1);
ciiall= ft_read_cifti(IMAGE1,'debug','true');


%load cifti file and directly change cifti at location (LEFT CORTEX) and save

ciftifile='/media/chidi/NTFS-SHARE/Parcellation/pilotfMRISurface/sub-01/correlationGradient/fmcpr.up_correlation_gradient_final.dscalar.nii';
ciiall= ft_read_cifti(ciftifile,'debug','true');

% we can identify CORTEX_LEFT
ciiall.brainstructurelabel %(1) = CORTEX_LEFT

%This is the first 32492
sum(ciiall.brainstructure==1)

% CIFTI is referenced starting from 0 in wb_view, and from 1 in matlab
% an index of 121 in CIFTI is therefore 122 in matlab

ciiall.up_correlation_gradient_final(adj)=1;
%adj =    17680   17681   17711   17713   17742   17743

%must change nan to 0!!! otherwise Python cannot read indexes using mem
%maybe can do this using wb_command
ciiall.up_correlation_gradient_final(isnan(ciiall.up_correlation_gradient_final))=0;

ft_write_cifti('/media/chidi/NTFS-SHARE/Parcellation/pilotfMRISurface/sub-01/correlationGradient/fmcpr.up_correlation_gradient_final_change',ciiall,'parameter', 'up_correlation_gradient_final');

ciftifile1='/media/chidi/NTFS-SHARE/Parcellation/pilotfMRISurface/sub-01/correlation/fmcpr.up_correlation_final.dconn.nii';
ciiall1= ft_read_cifti(ciftifile1,'debug','true');

ciftifile2='/media/chidi/NTFS-SHARE/Parcellation/pilotfMRISurface/sub-01/denseTimeSeries/fmcpr.up_final.dtseries.nii';
ciiall2= ft_read_cifti(ciftifile2,'debug','true');

%nanindex=find(isnan(ciiall.up_correlation_gradient_final))
%oneindex=find(ciiall.up_correlation_gradient_final==1)

