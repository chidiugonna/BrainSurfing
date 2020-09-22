%  add GIFTI release library to path
clear
close all
clc
addpath ./matlab-library/gifti-release

%% A. Open HCP Native lh pial mesh and cortical thickness overlay
% read and view the GIFTI surface mesh
mysurf='./DATA/HCP/100307/MNINonLinear/Native/100307.L.pial.native.surf.gii';
fprintf('Reading Surface %s\n',mysurf);
mysurfleft_mesh = gifti(mysurf);
fprintf('Surface has %d faces\n',size(mysurfleft_mesh.faces,1));
fprintf('Surface has %d vertices\n',size(mysurfleft_mesh.vertices,1));
% view the right surface
figure; plot(mysurfleft_mesh)

myoverlay='./DATA/HCP/100307/MNINonLinear/Native/100307.L.thickness.native.shape.gii';
fprintf('Reading Overlay %s\n',myoverlay);
myoverlayleft = gifti(myoverlay);
fprintf('Overlay has %d values\n',size(myoverlayleft.cdata,1));
figure; plot(mysurfleft_mesh, myoverlayleft)


%% B find all the vertices connected and their cortical thickness values
% to a particular vertex 119115

% IMPORTANT - unfortunately matlab starts indexing from 1 while wb_view
% indexes from 0!
% so our vertex that was numbered 119115 is actually 119116 in matlab
% so make sure you add 1 to the vertex numbers you get from wb_view
ciftivind=119115;

matlabvind=ciftivind + 1;
% find all triplets where vertex is 1st triangle
faces = mysurfleft_mesh.faces;

%combine instead as follows [ind, vol] = find((faces(:,1)==matlabvind));
% if so will need to swap ind and vol ????
C=(faces(:,1)==matlabvind);
[ind, vol] = find((C) > 0);
ind1=faces(ind,:);
ind1=ind1(:);

C=(faces(:,2)==matlabvind);
[ind, vol] = find((C) > 0);
ind2=faces(ind,:);
ind2=ind2(:);

C=(faces(:,3)==matlabvind);
[ind, vol] = find((C) > 0);
ind3=faces(ind,1:2);
ind3=ind3(:);

allVerticesMatlab=union(ind1,union(ind2,ind3));
neighborsMatlab=allVerticesMatlab(allVerticesMatlab ~= matlabvind);
fprintf('The vertices (using Matlab indices) neighboring %d are:\n', matlabvind);
fprintf('%d ',neighborsMatlab);
fprintf('\n');

allVerticesCifti=allVerticesMatlab - 1;
neighborsCifti=neighborsMatlab - 1;
fprintf('The vertices (using wb_view indices) neighboring %d are:\n', ciftivind);
fprintf('%d ',neighborsCifti);
fprintf('\n');

format longG
overlaydata=zeros(size(allVerticesMatlab,1),3);
overlaydata(:,1)=allVerticesCifti;
overlaydata(:,2)=allVerticesMatlab;
overlaydata(:,3)= myoverlayleft.cdata(allVerticesMatlab);

fprintf('The vertices have the following cortical thickness values:\n')
fprintf('\twb_view Index\tMatlab Index\tCortical Thickness\n')
fprintf('\t%d\t\t%d\t\t%d\n',overlaydata')

%% C set all the vertices to a uniform cortical thickness and  create a new GIFTI file
% Note we will need to use the Matlab indices

for verts=1:size(allVerticesMatlab,1)
   vind=allVerticesMatlab(verts);
   
   %translate x,y,z in random direction between -2 and 2mm
   newthickness=2;
   myoverlayleft.cdata(vind)=newthickness;

end

%Let's save our new gifti - we will save it in Compressed Base 64 binary
%for efficiency
%once saved you can try and open it up in wb_view
save(myoverlayleft,'amended.100307.L.thickness.native.shape.gii','GZipBase64Binary');
fprintf('Successfully saved amended GIFTI overlay\n')



%% D
% View the XML Metadata of GIFTI using a browser 
% A bit of a long-winded way to see the GIFTI header because xmlread cannot cope with !DOCTYPE
%  save the gifti in ascii format then we can open it in Chrome, Firefox
save(myoverlayleft,'mygiftioverlay_allxml.gii','ASCII');
% using firefox to look at the XML (firefox will need to be
% on your path); If you dont have firefox then replace with your browser type - if below doesn't work then just open a broser and open
% the file in it.
system('firefox mygiftioverlay_allxml.gii &')
fprintf('Look in browser to see Gifti XML or open mygiftioverlay_allxml.gii directly in your browser\n')

%% OPTIONAL E1
% Load the XML into a structure for reading

% we will need the xml2struct library to read the xml which can 
% obtained from https://www.mathworks.com/matlabcentral/fileexchange/28518-xml2struct
addpath ./matlab-library/xml2struct

% To read XML we may need to remove the DOCTYPE line in the xml - this
% caused errors with my version of matlab 
% if on unix (Mac, Linux) then use sed command to remove 2nd line which is DOCTYPE 

system('sed 2d mygiftioverlay_allxml.gii > mygiftioverlay_xml.gii &')

% if on windows then will need to do this using powershell
%
% >> !powershell
% Get-Content mygifti_allxml.gii  | Where {$_ -notmatch 'DOCTYPE'} | Set-Content mygifti_xml.gii
% >> exit

%% OPTIONAL E2
myXML = xml2struct('mygiftioverlay_xml.gii')
fprintf('Gifti has %d datarrays\n',size(myXML.GIFTI.DataArray,2))
szarray=size(myXML.GIFTI.DataArray,2);

if szarray > 1
    for arraynum=1:szarray
        fprintf('Attributes of DataArray %d',arraynum)
        myXML.GIFTI.DataArray{arraynum}.Attributes
        fprintf('Data stored for DataArray %d',arraynum)    
        myXML.GIFTI.DataArray{arraynum}.Data
    end
else
     fprintf('Attributes of DataArray')
     myXML.GIFTI.DataArray.Attributes
     fprintf('Data stored for DataArray %d',arraynum)    
     myXML.GIFTI.DataArray.Data
end







