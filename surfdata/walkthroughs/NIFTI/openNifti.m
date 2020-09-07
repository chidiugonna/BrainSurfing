addpath /usr/share/matlab/nifti2014
niinew=load_nii('wmparc.nii')

%matlab library below
niinew=load_nifti('wmparc.nii')

fid = fopen('wmparc.nii');
fseek(fid, 0, 'eof');
filesize = ftell(fid)
fclose(fid);



%step by step
fileID = fopen('wmparc.nii');
hdrsize = fread(fileID,1,'int');
datatype = fread(fileID,10,'char');
dbname = fread(fileID,18,'char');
extents = fread(fileID,1,'int');
sessionerror = fread(fileID,1,'int16');
regular = fread(fileID,1,'char');
diminfo = fread(fileID,1,'char');
dims = fread(fileID,8,'int16'); %short

p1 = fread(fileID,1,'float');
p2 = fread(fileID,1,'float');
p3 = fread(fileID,1,'float');
intentcode = fread(fileID,1,'int16'); %short

datatype = fread(fileID,1,'int16');
bitpix = fread(fileID,1,'int16');
slice_start = fread(fileID,1,'int16');
pixdim = fread(fileID,8,'float'); 
voxoffset = fread(fileID,1,'float'); 

fclose(fileID);

[str,maxsize,endian] = computer

%consider memmapfile for creating nifti
%https://www.mathworks.com/help/matlab/import_export/overview-of-memory-mapping.html