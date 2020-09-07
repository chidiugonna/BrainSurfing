%% Fix Nifti
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read data from nifti with corrupted header
IMAGE='sub-HC051_ses-on_task-rest_bold-avg.nii';
fid = fopen(IMAGE);
hdr = fread(fid,352,'char');
data = int16(fread(fid,'int16'));
fclose(fid);

% reshape data into 3D matrix based on prior information
datar=reshape(data, 78,128,128);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% save corrected nifti after fixing wrong information in header
NEWIMAGE='sub-HC051_ses-on_task-rest_bold-avg_corrected.nii';
niinfod=niftiinfo(IMAGE);
niinfod.BitsPerPixel=16;
niinfod.Datatype='int16';
niinfod.raw.datatype=4;
niinfod.raw.bitpix=16;
niftiwrite(datar,NEWIMAGE,niinfod);

% test that the new file can be read correctly and that data has been
% stored correctly
V=niftiread(NEWIMAGE);
volumeViewer(V);