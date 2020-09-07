mni_orig_info = niftiinfo('/home/chidi/repos/CFN/DATA/Nifti/sub-219/ses-itbs/anat/sub-219_ses-itbs_T1w.nii.gz');
I1=mni_orig_info.raw;
RS=[ I1.srow_x(1:3); I1.srow_y(1:3); I1.srow_z(1:3)]


b=I1.quatern_b;
c=I1.quatern_c;
d=I1.quatern_d;
a=sqrt(1.0-(b*b+c*c+d*d));

R11=a*a+b*b-c*c-d*d;
R21=2*b*c+2*a*d;
R31=2*b*d-2*a*c;
R12=2*b*c-2*a*d;
R22= a*a+c*c-b*b-d*d;
R32=2*c*d+2*a*b;
R13=2*b*d+2*a*c;
R23=2*c*d-2*a*b;
R33=a*a+d*d-c*c-b*b;
qfac=I1.pixdim(1); % if not 1 or -1 then force to 1

R = [ R11 R12 R13; R21 R22 R23; qfac*R31 qfac*R32 qfac*R33 ]

qx=I1.qoffset_x;
qy=I1.qoffset_y;
qz=I1.qoffset_z;


% To transform from voxel space to world space - we use the following
T=[ I1.srow_x; I1.srow_y; I1.srow_z;  0 0 0 1]

V = [10, 20, 15 1]';
Ws = T*V;

% using qform
Wq=R*V(1:3).*[I1.pixdim(2);I1.pixdim(3);I1.pixdim(4)]+[qx;qy;qz]



