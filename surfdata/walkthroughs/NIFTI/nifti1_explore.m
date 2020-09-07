%%
% quick visualization of T1w image 
IMAGE1='/home/chidi/repos/CFN/DATA/Nifti/sub-219/ses-itbs/anat/sub-219_ses-itbs_T1w.nii.gz';
niinew=niftiread(IMAGE1);
niinfo=niftiinfo(IMAGE1);
%volumeViewer(niinew)

%%
% in order to read the header information correctly we need to decompress
% the file
tmpFilenameCell = gunzip(IMAGE1, tempdir);
IMAGETMP = tmpFilenameCell{1}

fid = fopen(IMAGETMP);
fseek(fid, 0, 'eof');
filesize = ftell(fid)
fclose(fid);

% FileSize is 23069024
% this matches what we expect 176*256*256*2+352
% i.e. 176*256*256 signed shorts(datatype=4) which is 16 bits (we thus
% multiply by 2 for bytes) and add the header

%%
% Details of header from https://brainder.org/2012/09/23/the-nifti-file-format/
% and https://brainder.org/2015/04/03/the-nifti-2-file-format/
%
% we use signed versions of all data types
% int = int32
% char = schar
% short = int16
% float = float32

% read in the header
fileID = fopen(IMAGETMP);
hdrsize = fread(fileID,4,'schar');
fclose(fileID);

hdr=zeros(1,4,'int8')
hdr(:)=hdrsize(:)
typecast(hdr,'int32')
%hdr is 348 bytes large so we have a nifti

% Probably abstract but on an opposite endian
typecast(flip(hdr),'int32')

% instead of flip try swapbytes
swapbytes(typecast(hdr,'int32'))

% wrong endianness gives us 1543569408

[str,maxsize,endian] = computer;
% ok we can proceed as normal now we have a nifti and our system is
% compatible in endianess!
fileID = fopen(IMAGETMP);
hdrsize = fread(fileID,1,'int32');
datatype = fread(fileID,10,'schar');
dbname = fread(fileID,18,'schar');
extents = fread(fileID,1,'int32');
sessionerror = fread(fileID,1,'int16');
regular = fread(fileID,1,'schar');
diminfo = fread(fileID,1,'schar');
dim = fread(fileID,8,'int16'); 
p1 = fread(fileID,1,'float');
p2 = fread(fileID,1,'float');
p3 = fread(fileID,1,'float');
intentcode = fread(fileID,1,'int16'); 
datatype = fread(fileID,1,'int16');
bitpix = fread(fileID,1,'int16');
slice_start = fread(fileID,1,'int16');
pixdim = fread(fileID,8,'float'); 
voxoffset = fread(fileID,1,'float');
scl_slope 		= fread(fileID,	1 ,  'float');
scl_inter 		= fread(fileID,	1 ,  'float');
slice_end 		= fread(fileID,	1 ,  'int16');
slice_code 		= fread(fileID,	1 ,  'schar') ;
xyzt_units 		= fread(fileID,	1 ,  'schar') ;
cal_max 		= fread(fileID,	1 ,  'float');
cal_min 		= fread(fileID,	1 ,  'float');
slice_duration	= fread(fileID,	1 ,  'float');
toffset 		= fread(fileID,	1 ,  'float');
glmax  			= fread(fileID,	1 ,  'int32') ;
glmin 	 		= fread(fileID,	1 ,  'int32'); 
descrip			= fread(fileID,	80,  'schar') ;
aux_file		= fread(fileID,	24,  'schar'); 
qform_code 		= fread(fileID,	1 ,  'int16');
sform_code 		= fread(fileID,	1 ,  'int16');
quatern_b 		= fread(fileID,	1 ,  'float');
quatern_c 		= fread(fileID,	1 ,  'float');
quatern_d 		= fread(fileID,	1 ,  'float');
qoffset_x 		= fread(fileID,	1 ,  'float');
qoffset_y 		= fread(fileID,	1 ,  'float');
qoffset_z 		= fread(fileID,	1 ,  'float');
srow_x			= fread(fileID,	4,  'float');
srow_y 			= fread(fileID,	4,  'float');
srow_z 			= fread(fileID,	4,  'float');
intent_name		= fread(fileID,	16,  'schar') ;
magic 			= fread(fileID,	4 ,  'schar');
extension       = fread(fileID,	4 ,  'schar');
data            = fread(fileID,176*256*256, 'int16');
fclose(fileID);

reshapedata=reshape(data,[176,256,256]);
volumeViewer(reshapedata)

% fe direction, pe direction, slice direction
de2bi(diminfo) % read 01 = (x),10 = 2 =  (y) and 11=  3 = (z)

%check magic
dec2hex(magic)
%'6E 2B 31 00'= nifti
% 6E 69 31 00'= analyze hdr/img pair

% view chars
char(descrip')




