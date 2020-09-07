% add release library to path
addpath /home/chidi/repos/CFN/SurfaceFormat/library/gifti-release

load mri
D = squeeze(D);
Ds = smooth3(D);
g = gifti(isosurface(Ds,5))
  
h = plot(g);
daspect([1,1,.4]); view(45,30); axis tight
lightangle(45,30);
set(h,'SpecularColorReflectance',0,'SpecularExponent',50)
   
save(g,'mri.surf.gii','Base64Binary');

gmri = gifti('mri.surf.gii');
figure; plot(gmri)
