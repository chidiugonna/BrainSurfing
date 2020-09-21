
try 
ciftioverlay='../../DATA/HCP/100307/MNINonLinear/Native/100307.thickness.native.dscalar.nii';
niinew=niftiread(ciftioverlay);
niinfo=niftiinfo(ciftioverlay);
catch
   disp('This is not a valid nifti-1 file, I think it might be a nifti-2!') 
end


fid = fopen(ciftioverlay);
fseek(fid, 0, 'eof');
filesize = ftell(fid);
fclose(fid); 
% file size 3386416

% read in the header
fileID = fopen(ciftioverlay);
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

% wrong endianness gives us 469893120

%hdr is 540 bytes large so we have a nifti2484882
fid = fopen(IMAGE1);
sizeof_hdr 		= fread(fileID, 1, 'int32');
magic 	        = fread(fileID, 8,   'char'); 		
data_type 		= fread(fileID, 1,  'int16');
bitpix 			= fread(fileID, 1,  'int16');
dim 			= fread(fileID, 8,  'int64');
intent_p1 		= fread(fileID, 1,  'double'); 
intent_p2 		= fread(fileID, 1,  'double' );
intent_p3 		= fread(fileID, 1,     'double'); 	
pixdim 			= fread(fileID, 8,    'double')  ;	
vox_offset 		= fread(fileID, 1,   'int64') ;	
scl_slope 		= fread(fileID, 1, 'double' ) ;	
scl_inter 		= fread(fileID, 1, 'double' ) ;	
cal_max 		= fread(fileID, 1, 'double' ) ;	
cal_min 		= fread(fileID, 1, 'double' ) ;	
slice_duration 	= fread(fileID, 1, 'double' ) ;	
toffset 		= fread(fileID, 1, 'double' ) ;	
slice_start 	= fread(fileID, 1, 'int64' )	;
slice_end 		= fread(fileID, 1, 'int64') ;	
descrip 		= fread(fileID, 80, 'schar' );	 	
aux_file 		= fread(fileID, 24, 'schar' );	 	
qform_code 		= fread(fileID, 1, 'int32' );		
sform_code 		= fread(fileID, 1, 'int32' );			
quatern_b 		= fread(fileID, 1, 'double') ;	
quatern_c 		= fread(fileID, 1, 'double') ;		
quatern_d 		= fread(fileID, 1, 'double') ;	
qoffset_x 		= fread(fileID, 1, 'double') ;		
qoffset_y 		= fread(fileID, 1, 'double') ;
qoffset_z 		= fread(fileID, 1, 'double') ;	
srow_x 			= fread(fileID, 4, 'double') ;	
srow_y 			= fread(fileID, 4, 'double') ;	
srow_z 			= fread(fileID, 4, 'double') ;	
slice_code 		= fread(fileID, 1, 'int32' );	
xyzt_units 		= fread(fileID, 1, 'int32' );		
intent_code 	= fread(fileID, 1, 'int32' );			
intent_name 	= fread(fileID, 16, 'schar') ;	 	
dim_info 		= fread(fileID, 1, 'schar') ;	
unused_str	 	= fread(fileID, 1,   'schar') ;
fclose(fileID);


char(intent_name')

dec2hex(magic)

% Compare with nifti2 header reader from ft_cidti
%hdr = read_nifti2_hdr(IMAGE1);

% navigate the CIFTI

%Determine size of NIFTI2
fid = fopen(IMAGE1);
fseek(fid, 0, 'eof');
filesize = ftell(fid)
fclose(fid);
% filesize =3386416

% vox offset
%vox_offset is 2075680

% read extent codes
fid = fopen(IMAGE1);
hdr = fread(fileID,540,'char');
exts = fread(fileID,4,'char');
extent = fread(fileID,2,'int32');
fclose(fid);

%ext(1)=1 so we have extensions!
%extent(1) tells us the size of the extent is 2075136 bytes
% since this includes the extent code and extent type itself we have
% 2075136 - 8 = 2075128 bytes in this extent

%okay do we have another extent?
extent_len = 540 + 4 + 8 + 2075128
%=2075680
% now lets compare it to voxoffset = 2075680
% BINGO = have 1 extent

% so we can read the extent by fseeking to position 540 + 4 + 8 and then
% reading 2075128 bytes

% we can grab the data by fseeking to 2075680 and then reading to eof
% get the xml
fid = fopen(IMAGE1);
hdr = fread(fid,540,'char');
exts = fread(fid,4,'char');
extent = fread(fileID,2,'int32');
lenextent = (extent(1) - 8)
xml=fread(fileID,lenextent,'char');
data=fread(fileID,filesize,'float');
fclose(fid);

charxml=char(xml);
fidwrite=fopen('debug_test.xml','w');
fprintf(fid,'%s',charxml);
fclose(fidwrite);

%open xml and notice that 163842 on left and 163842 on right
% so total of 327684 vertices
%This matches with size(data) = 327684

%Lets compare with field trip

% Compare with nifti2 header reader from ft_cidti
IMAGE1='/home/chidi/repos/CFN/DATA/MNINonLinear/100307.sulc.164k_fs_LR.dscalar.nii';
% ft_read_nifti2 was written by CPU and doesn't come with the ft library
newhdr = ft_read_nifti2(IMAGE1);
ciiall= ft_read_cifti(IMAGE1,'debug','true');



