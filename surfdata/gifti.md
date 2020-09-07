# Gifti





## Gifti Library
This library is matlab based and in addition to standard Gifti files with extension `.gii` can read in and export to a range of surface file formats like freesurfer `.pial`, `.sphere`, `.white`, `.surf`, `.curv` etc, as well as matlab `.mat` files, `.vtk` files and several others. This library is integrated into `SPM`.

You can download a release version `gifti-zip`from [here](https://www.artefact.tk/software/matlab/gifti/)

In linux command shell you can do:

    cd library
    wget https://github.com/gllmflndn/gifti/archive/master.zip
    unzip master.zip
    rm master.zip
    mv gifti-master gifti-release


For development updates, usage and to get latest code go to [github](https://github.com/gllmflndn/gifti.git) page.

    cd library
    git clone https://github.com/gllmflndn/gifti.git
    mv gifti gifti-latest
    
### Open Gifti File example

    % add release library to path
    addpath /home/chidi/repos/CFN/SurfaceFormat/library/gifti-release
    
    % read and view the GIFTI surface mesh
    surfacemesh='./exampleData/BV_GIFTI/GzipBase64/sujet01_Lwhite.surf.gii'
    gmesh = gifti(surfacemesh);
    figure; plot(gmesh)
    
    %read the curvature and display on mesh
    curvature='./exampleData/BV_GIFTI/GzipBase64/sujet01_Lwhite.shape.gii';
    gcurv = gifti(curvature);
    
    % plot mesh with curvature
    figure; plot(gmesh,gcurv)


### Create Gifti File example

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

### Viewing the XML header
The gifti file itself is basically a large xml file that describes th metadata and data contained for the surface. In ASCII format then it is simple enough to just open it in a text editor and peruse the contents. In some cases the data is encoded as Base64 binary and compressed which the gifti library can manage. In order to see the xml header for files that are not ascii then you can simple open the gifti and then resave it as an ascii gifti as follows

    surfacemesh='./exampleData/BV_GIFTI/GzipBase64/sujet01_Lwhite.surf.gii'
    gmesh = gifti(surfacemesh);
    save(gmesh,'asAscii.gii','ASCII');

    