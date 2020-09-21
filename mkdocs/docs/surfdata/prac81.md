# Practicum 8.1 -  Surface-Based Data Formats

## Synopsis
Surface-based data formats represent neuroimaging data in two main forms namely *meshes* and *overlays*. In both cases anatomical locations are represented by *vertices* which are arbitrary points in 3D space.

Surface *meshes* store 2 main types of information - the cartesian location (x, y, z) of each vertex in 3D space and the triplet of vertex indices that make up a triangular face on the mesh.   

Surface *overlays* store attributes for each vertex. These attributes could be single value scalars like the cortical thickness at a vertex or a series of values like a time series  from an fMRI or EEG experiment.

## Objectives
This practicum will introduce you to working with surface-based data using the GIFTI and CIFTI file formats. By the end of this practicum you should

* Be able to access the metadata of GIFTI and CIFTI files to determine the properties of the surface under study
* Be able to directly access the image data in a GIFTI and CIFTI file and work with it
* Be able to change the data in a GIFTI and CIFTI file and create a new file with your changes
* Visualize your GIFTI and CIFTI files using the workbench tool

## Downloads/Installation
This practicum requires the following materials/folder setup to work to complete:

* A reasonably recent version of [matlab](https://www.mathworks.com/). The practicum was tested on version R2020a (linux) and R2019a (windows)  but should work on older versions as well.
* A copy of the HCP's [Connectome workbench](https://www.humanconnectome.org/software/get-connectome-workbench). We will be using `wb_view` for viewing CIFTI and GIFTI files. The install is a zip file that you extract and the executable should be available after extraction. Depending on your platform you may need to double-click the `wb_view` icon or add it to your path to access via the command line. Copies of workbench have also been packaged up at the [Classhare](https://drive.google.com/drive/u/0/folders/1mMOCftWzKsa31LrVHa1PvJCEsRfmrmx2) for this lesson under the **Software** folder which you can access if you have trouble getting to the connectome site. There are 4 zip files with names that start with `workbench-..` for different OS platforms.
* The matlab practicum files, matlab libraries and data for this practicum are also all available at the [Classhare](https://drive.google.com/drive/u/0/folders/1mMOCftWzKsa31LrVHa1PvJCEsRfmrmx2) folder under the **practicum81** folder. Download this folder to your local computer and extract. This should create a new folder called `practicum81-YYYYMMDD`. Navigate further into the folder hierarchy into `practicum81` and extract `DATA.zip` and `matlab-library.zip`the same way.

Your folder structure should look like this after extraction.

    └── practicum81
        ├── DATA
        │   └── HCP
        ├── matlab-library
        │   ├── cifti-matlab
        │   ├── gifti-release
        │   └── xml2struct
        ├── read_nifti2_hdr.m
        ├── task_002_giftisurf.m
        ├── task_003_giftioverlay.m
        └── task_004_cifti.m


## Provenance

### Matlab libraries
The matlab libraries used in this practicum are described below:

* The HCP [cifti-matlab](https://github.com/Washington-University/cifti-matlab) library is in alpha-testing phase and so is liable to change in the future though hopefully not significantly. The version provided  had it's last commit `1e0ca9fbb0f9a8105d144ec6bc0de55b84d1b528` on `Wed Sep 2 15:42:55 2020 -0500`. Please refer to the [cifti-matlab](https://github.com/Washington-University/cifti-matlab) repository for announcements on when the alpha-testing is complete. In the meantime if you use this code for your own research then please appreciate that you do this at your won risk and there is a chance of errors.

* The [gifti](https://www.artefact.tk/software/matlab/gifti/)  library was downloaded as a zip file `gifti-master.zip`, extracted and renamed to `gifti-release`

* [xml2struct](https://www.mathworks.com/matlabcentral/fileexchange/28518-xml2struct) was downloaded directly from the mathworks fileexchange.

### Data
We will be using a subset of data from the Human Connectome Project's Young Adult (YA) [1200 Subject Release](https://db.humanconnectome.org/data/projects/HCP_1200). Specifically data from subject 100307. The HCP has terms of reference for using their data. To use HCP data please sign on to the [HCP website](https://db.humanconnectome.org) and register for free. 

## Task 1: Use wb_view to visualize GIFTI surfaces

* Open wb_view either by double-clicking the `wb_view` or `wb_view.exe`  icon in your windows manager or by entering this in the command line if you have set up your paths in the the command line interface correctly.
* When **wb_view** opens click the  `skip` button in the dialog to get to the main screen
* From the top menu choose `File` > `Open File` and change the dropdown on `Files of type:` to `Surface Files (*.surf.gii)`
* Now navigate to `../Practicum81/DATA/HCP/100307/MNINonLinear/Native/`
* You will be presented with a host of files
* with the left mouse button click on `100307.L.pial.native.surf.gii`
* Now pressing the CTRL key (Command key on Mac) again click with the left mouse buton on `100307.R.pial.native.surf.gii` to select both surfaces. You should see that both files are reflected in the `File name` textbox. The **pial** that these surfaces refer to is the surface boundary between grey matter and CSF in the outer cortex.
* Now click `Open`, you should see the left and right pial surfaces displayed with lateral and medial views

![select surfaces](../img/task1_selectsurfs.png)

* At top of the application change from **(1) Montage** to  **(2) All** by clicking on the tab. You should see the left and right pial surfaces aligned on the screen. Use your mouse left button to rotate the brain around and your scroll wheel to zoom in and out

* We can get a quick overview of these surfaces by choosing `Surface` > `Information`. We can see that there are 130879 vertices and 261754 faces in the left hemisphere pial surface.

![select all vertices](../img/task1_information.png)

* For the rest of this  exercise we just want to work with left hemisphere so we will uncheck the display for the right cortex in the **(2) All** tab.

![select surfaces](../img/task1_justleft.png)

* Switch on edge view by clicking the `Surface` menu option. Choose  `Properties`  and change the `Drawing Type` to `Links (Edges)`. Zoom in a little closer to see the triangular tesselation.

* identify any vertex you like and click on it. For this example I have stumbled upon vertex `119115` which I have decided to probe. A dialog with title **Information** should pop up with vertex information. Notice also that the white vertex symbol icon is much larger than the width of the edges. 

![select vertex first](../img/task1_firstselect.png)

* Choose `Properties` in the **information** dialog (`Properties` is under `Contra ID` in the dialog) and change the `Symbol Diameter` and `Most Recent ID Symbol Diameter` to a suitable size. We chose `0.5mm` for our example. You can also change the `ID Symbol Color` to another value.

![select vertex small icon](../img/task1_secondselect.png)

* Once you have selected a vertex we can now try and identify it's neighbors. For the first pass through this practicum you should avoid chossing a vertex on the medial layer as this will cause difficulties in task 4 which will become clear. To be super safe then just replicate the vertex we have chosen or choose a vertex that is easilly accessible on the lateral surface.  

![select all vertices](../img/task1_mediallayer.png)


* Select all the neighbouring vertices (all vertices connected by an edge to your chosen vertex). These should show up in the information screen. You can select and copy the text from this screen and place it in a text file. We will need this information for the next Task.

![select all vertices](../img/task1_allselected.png)

## Task 2: Use Matlab to manipulate GIFTI Surfaces
* In this task we will be loading in the GIFTI surface `100307.L.pial.native.surf.gii` which we visualized above and identifying the vertex and vertex neighbours we located in task 2 above. We will then nudge these vertices by a random 3D translation and then save a new copy of the surface which we will visualize again using **wb_view**.

* Open matlab and navigate to your the  `practicum81`  folder containing `task_002_giftisurf.m`

* We will run individual sections by right clicking on the section and selecting `Evaluate Current Section`. Select the 1st section and change the path to point to the location of the Gifti library ( you only need to do this if you decide to change the folder structure from the default ) and choose `Evaluate Current Selection` to run.

![select all vertices](../img/task2_01_matlab_addlib.png)

If you don't have the right path to your library you will see an error like this:

    Warning: Name is nonexistent or not a directory /home/chidi/Downloads/Practicum81/../matlab-library/gifti-release

* Now ensure thart `mysurf` in the section `A. Open HCP Native lh pial mesh` is pointing to the correct location for the data and then right click and run.

![select all vertices](../img/task2_02_matlab_loadgifti.png)

* This section also plots a 3D model of the surface which can be rotated with the mouse.

![select all vertices](../img/task2_03_giftiplot.png)


* you should see that the expected number of faces and vertices are also printed to the screen. This information has been obtained using the `gifti-release` libraries `gifti()` function. The information is stored in the structure `mysurfleft_mesh`

         mysurfleft_mesh = 
     
           struct with fields:
     
                faces: [261754×3 int32]
                mat: [4×4 double]
            vertices: [130879×3 single]

* Now run the next section to find the neighbours of the vertex you located in task 1 above. Remember to change the vertex on line 21 `ciftivind=` to point to your vertex. If all goes well then you should see the same vertices you observed in `wb_view` noticing the fact that `wb_view` starts indexing vertices from 0 while matlab starts indexing from 1.

![select all vertices](../img/task2_findvertices.png)

* The code logic looks at all the columns of the faces matrix and picks out the lines that include our vertex and then does a union to create a set of vertices without duplication. The faces matrix contains a row for every triangular face. So below for example the vertices 119116, 119106 and 119115 are connected as a face.

Find 119116 in column 1:

           119116   119106   119115
           119116   119128   119129
           119116   119129   119117

Find 119116 in column 2:

           118448   119116   119115
           119106   119116   119107

Find 119116 in column 3:

           118448   118449   119116
           118449   119128   119116
           119117   119107   119116

* Now we will run section C to peturb each neighbouring vertex by a random number between 2 and -2 mm. 

![select all vertices](../img/task2_nudge.png)

* this code goes through a loop and for each vertex obtains the x, y and z anatomical location information and perturbs it by a random number. The anatomical location is stored in `mysurfleft_mesh.vertices`. Each row is the x,y and z location in mm for the indexed vertex.

        mysurfleft_mesh.vertices(119116:119120,:)
        
        ans =
        
          5×3 single matrix
        
              -42.452       43.473       26.122
              -41.256       40.121       24.459
              -45.818       41.722       26.039
              -6.5523       39.976       19.625
              -7.8963       39.518       18.662

* This section will create a file called `amended.100307.L.pial.native.surf.gii` in your current folder which we will look at next.

* Open your amended GIFTI surface `amended.100307.L.pial.native.surf.gii` in wb_view
* Now open the original `100307.L.pial.native.surf.gii` for comparison
* By default there are two tabs provided when you first open wb_view these are **(1) Montage** and **(2) All** 
* You can click on any of the tabs and change the View to **Surface** by clicking the corresponding radio button or create a new tab 
![select all vertices](../img/task2_newtab.png)

![select all vertices](../img/task2_choosesurface_RB.png)

* Notice that under `Brain Structure and Surface` that our `amended.100307.L.pial.native.surf.gii` is the selected surface because we loaded it in first.

* let's locate our original vertex from task 1.  Switch on vertex view by clicking the `Surface` menu option. Choose  `Properties`  and change the `Drawing Type` to `Vertices` and press Close

* Now click on `Window` and then `identify`and click on the `identify Surface Vertex` and enter the vertex Index. For my Task 1 example I used `119115` you can use this vertex or one that you selected for yourself.

* After clicking `apply` it will help to change the size and color of the vertex symbol to a larger value and more vivid color respectively. In the `Information` dialog, click on properties and change the vertex color and size again. You may also have to rotate the brain if you chose a vertex hidden from the lateral view. You should be able to spot your vertex.

![select surfaces](../img/task2_locatevertex.png)

* Change the Surface properties to `Link(Edges)` and zoom in closer to see how the pertubations you made to the neighboring vertices have changed the topology. You will probably need to change the symbol diameter to something smaller. You should notice that the topology of your vertices has changed.

![select surfaces](../img/task2_amendedsurface.png)


* You can contrast this with the original by clicking back and forth  on the dropdown in the tab (under `Brain Structure and Surface`) switching between the original and your amended or by clicking on a Montage window to see both surfaces side by side. You should confirm that you have successfully change the topology of your surface.

![select surfaces](../img/task2_leftpialoriginalview.png)

![select surfaces](../img/task2_montagecompare.png)

* We won't dwell too long on the next two sections but these give you more insight into the XML structure of the GIFTI structure so that you can compare that with the data provided by the `gifti-matlab` library. Essentially this library just reads this XML file to create the `faces` and `vertices` structures that you have just looked at.

* In **section D** you will return to the matlab file to view the GIFTI metadata in a browser to see exactly how the XML is used to represent the GIFTI format. If you are running a windows machine then comment out the first system call and uncomment the second one. if you don't have firefox installed on your machine then replace with your installed browser.  You will need to have the browser on your path.

        %system('firefox mygifti_allxml.gii')
        
        % Notice that data is read in column-major order
        % this means that columns are read before rows
                  
        % on windows
        system('firefox.exe mygifti_allxml.gii')

* if you don't have the browser on your path you will get a message like this:

    `'firefox.exe' is not recognized as an internal or external command. operable program or batch file.`

* You can also simply open the `mygifti_allxml.gii` file directly in your browser without running it from the command line.

* You can collapse and expand XML sections in the browser by clicking on the -/+ signs respectively. Notice that the vertex anatomical location information is represented as a **DataArray** with an **Intent** name of `NIFTI_INTENT_POINTSET`. The number of vertices is captured by **Dim0="130879"**. The triangular faces are represented in the second data array.

![select all vertices](../img/task2_optionalD.png)

* Expand the **Data** tag in the `NIFTI_INTENT_POINTSET` dataarray and then look at the surface mesh vertex information that is loaded in by the gifti library. Notice how the columns are loaded in first before the rows. This is known as Column Major Order and is specified also in the XML as a DataArray attribute as `<DataArray ArrayIndexingOrder="ColumnMajorOrder"..`  

![select all vertices](../img/task2_optionalD_col.png)
![select all vertices](../img/task2_optionalD_colmat.png)

* **Section E** accomplishes the same as Section D except that now the xml data is loaded into a matlab structure. You can skip this section as all it does is corroborate what you have already seen above. It is divided into 2 parts, **E1** and **E2**

* Run Section **E1** to fix the xml in the GIFTI. We need to do this as unfortunately there is a slight problem reading the XML file into matlab as the 2nd line which starts `<!DOCTYPE` causes problems with the parser. The line `sed 2d...` in the matlab file is written to delete this line on unix and save a new text file called `mygifti_xml.gii` which is then parsed. In windows you will have to use `powershell` if its available or alternatively manually open the xml file in a text processor and delete the 2nd line. In matlab you can invoke a powershell shell as follows:

        !powershell

After powershell loads enter the command below to remove the 2nd line:

        Get-Content mygifti_allxml.gii  | Where {$_ -notmatch 'DOCTYPE'} | Set-Content mygifti_xml.gii

Then return to matlab by typing `exit`

* Now run **Section E2** to load the XML into a matlab structure.

![select all vertices](../img/task2_optionalE.png)

## Task 3: Use Matlab to manipulate and visualize GIFTI overlays
We have been able to work with and manipulate GIFTI surface files. In this task we will now look at an example of a GIFTI overlay that map values onto these vertices and we will attempt to manipulate and visualize this overlay. For this task we will be looking at cortical thickness ovelay.

* Open wb_view as previously and load in the surface `100307.L.pial.native.surf.gii`. Click on **Surface View** to view the Left hemisphere. Now load in the cortical thickness overlay `100307.L.thickness.native.shape.gii`. You will need to change the `Files of type` field to  `Metric Files (*.func.gii *.shape.gii)` or `Any File (*)` to be able to select the thickness overlay. Activate the layer by clicking on the checkbox alongside it. Also click on the color bar to see the range of cortical thicknesses across the brain and their associated colors.

![select surfaces](../img/task3_loadOverlay.png)

* Now locate the vertices you looked at previously (using `Window` > `identify`) and find their cortical thicknesses by looking at the information dialog. Notice that for our central vertex (119115 in this case)  has a cortical thickness of 3.54125 mm.

![select surfaces](../img/task3_viewThickness.png)

* We will now open this overlay in Matlab, change the cortical thickness of our target vertex and its neighbors and visualize the changed ovelay in wb_view

* As before run each section in matlab separately to follow along with what is happening in the code. First run the `addpath ..` section to ensure that the gifti library is accessible.

* In  section A we load in the surface as before and now also load inthe cortical thickness overlay. Notice that the overlay and the surface match as the number of vertices is equal to the number of thickness values.

        Reading Surface ./DATA/HCP/100307/MNINonLinear/Native/100307.L.pial.native.surf.gii
        Surface has 261754 faces
        Surface has 130879 vertices
        Reading Overlay ./DATA/HCP/100307/MNINonLinear/Native/100307.L.thickness.native.shape.gii
        Overlay has 130879 values

* The overlay has all its thickness values for each vertex stored in a `cdata` matrix:


        myoverlayleft = 
        
          struct with fields:
        
            cdata: [130879×1 single]

* Using the gifti library's overloaded `plot` command we now visualize the surface in one window and also plots the overlay over the surface in another.

![select surfaces](../img/task3_overlaymesh.png)

* In **section B** we see a print out of the cortical thickness values at our neighbouring vertices. In **Section C** we set all the thicknesses to a uniform value of 2mm and then save a copy called 
`amended.100307.L.thickness.native.shape.gii`. Open this file after opening the `100307.L.pial.native.surf.gii` surface and confirm that the 9 vertices have a thickness value of 2mm.

![select surfaces](../img/task3_changeThickness.png)

* In section D and E you can again study the XML structure of the overlay to see how it corresponds to the gifti structure loaded into matlab.


## Task 4: Use Matlab to manipulate and visualize CIFTI files

So far we have learned to work with GIFTI files. In this last task we are going to work with CIFTI files which combine both volume data for subcortical structures and surface data for cortical structures. Unfortunately the HCP's matlab library is still in [Alpha testing](https://github.com/Washington-University/cifti-matlab) and so we need to be aware that there is a slight chance that the coding conventions used here may change however the overal conceptual approach should remain the same.

We will work with HCP data again and this time with CIFTI cortical thickness data `100307.thickness.native.dscalar.nii` from the left and right cortex and with CIFTI fMRI data `rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii` from both Left and Right cortex as well as from 19 other subcortical structures that are stored as volumes in a CIFTI file.

To visualize CIFTI data in `wb_view` we need a GIFTI surface file that is associated with the CIFTI data.

* open `wb_view` and load in GIFTI surface `100307.L.midthickness.native.surf.gii` - this surface is midway between the `pial` surface we used previously and the `white` surface. Now load in the midthickness surface for the right hemisphere `100307.R.midthickness.native.surf.gii`. Click on **All** view to see both hemispheres aligned in the view. You can rotate the whole brain to a perspective that works for you.

![select surfaces](../img/task4_alignedsurface.png)

* Now open `100307.thickness.native.dscalar.nii` - you will need to specify **Files of type: (*.dscalar.nii)** to be able to select this file. Activate the layer by clicking on the checkbox and notice that this CIFTI file has cortical thickness information for both hemispheres. 

![select surfaces](../img/task4_ciftithickness.png)


* lets return to matlab and open the matlab file `task004_cifti.m` and execute the prelim section to load in the matlab libraries that we need.

* In **Section A** we will briefly explore the overlay `100307.thickness.native.dscalar.nii` as a NIFTI-2 file. We will use a private function  `read_nifti2_hdr.m` which is packaged as part of the `FieldTrip` Matlab library. The diagram below shows how a NIFTI-2 file is used to package up this CIFTI.

![select surfaces](../img/Cifti_format.png)

* We can confirm that the size of the CIFTI file in bytes is equal to the size of the voxel offset field plus the data size in bytes:

        >> filesize = 
             2525056
        
        >> nii2.vox_offset
           1531104
        
        >> nii2.dim
           6   1  1  1  1  1  248488  1
        

* where the value of `nii2.dim[7] = 248488` is the data size in floats which is equal to `4*248488=993952` in bytes. The XML is thus embedded in the extent section between the header and the data. It is this section that the cifti-matlab library reads to determine exactly how the surface and volume models are set up.

* Run **Section B** to explore the CIFTI XML file in a matlab structure and in a browser. Notice that like the gifti overlay this cifti overlay has data for both cortices in a `cdata` structure.

        >> ciiall
        
        ciiall = 
        
          struct with fields:
        
            metadata: [1×3 struct]
             diminfo: {[1×1 struct]  [1×1 struct]}
               cdata: [248488×1 single]

* The xml data has also been stored in a CIFTI structure

        >> ciixml
        
        ciixml = 
        
          struct with fields:
        
            CIFTI: [1×1 struct]
        
* The information stored in the above two structures matches the XML data that can be visualized in the browser. Notice that the first dimension is `CIFTI_INDEX_TYPE_SCALARS` which means that each vertex/voxel has a single scalar value which in this file is the cortical thickness. Also notice that the second dimenions is `CIFTI_INDEX_TYPE_BRAIN_MODELS` which is used to map every voxel/vertex in a cortical or subcortical structure. Just the  left cortex `CIFTI_STRUCTURE_CORTEX_LEFT` and the right cortex `CIFTI_STRUCTURE_CORTEX_RIGHT` are represented in this file.


![select surfaces](../img/task4_ciftixmlscalar.png)

* As already mentioned, the data structure `ciiall` contains all the cortical thickness data for both hemispheres in `ciiall.cdata` indexed starting from 1 to 125197 for the left cortex and from 125198 to 24848.

![select surfaces](../img/task4_ciftiscalardata.png)

* This is seen in the XML output in the browser and in the ciixml structure. It can also be confirmed by querying `ciiall` which has all the required information. Here we look at the model for the CORTEX_LEFT

         >> ciiall.diminfo{1}.models{1}
         
         ans = 
         
           struct with fields:
         
                start: 1
                count: 125197
               struct: 'CORTEX_LEFT'
                 type: 'surf'
              numvert: 130879
             vertlist: [1×125197 double]


* There however appears to be an inconsistency. In the last task we had 130879 vertices in the left hemisphere but here we have about 5000 vertices fewer. What's going on? 

* Essentially the HCP CIFTI files do not store data for the medial layer of each cortex. We will identify these medial vertices and visualize a few of them on the left cortex.

* Run **section CS** to print out all the vertices that are missing from the left cortex. These are the medial vertices. There should be `5682` vertices in the medial layer displayed to screen. Select one or a few of them and usin the `udentify` tool in`wb_view` try to see where they are. You will need to use the surface view and visualize the left cortex only so you can see these vertices. Some of these are easier to see than others.

![select surfaces](../img/task4_mediallayer.png)

* In **section D** and **E** we do what we did in task 3 and will now go ahead and change the value of a vertex and its neighbors to a constant value of 2mm cortical thickness. The code uses a vertex value of 119115 but of course you should use any vertex you like except for the medial vertices which the CIFTI file does not track. Open the `amended.100307.thickness.native.dscalar.nii` that is created in your current directory in wb_view and navigate to the vertex to confirm that changes have been made.

![select surfaces](../img/task4_changethickness.png)

## Task 5: Use Matlab to manipulate and visualize CIFTI files with volumes and surfaces combined

* We now look at a slightly more complexCIFTI file which stores fMRI data for a combination of Surface and Volume structures. We will be working in a standard space for this and so will close all the files in wb_view and then load in the surface which we will be using for this exploration.

![select surfaces](../img/task4_closefiles.png)

* Now open `100307.R.midthickness.32k_fs_LR.surf.gii` and `100307.L.midthickness.32k_fs_LR.surf.gii`, select the **All** view and then load in the fMRI `dtseries.nii` CIFTI file `rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii`. Switch on the overlay and change the file from `dynconn - rfMRI_REST1_LR_Atlas_hp2000_clean.dynconn` to the dtseries and rotate the brain. Notice that their are values in both the cortex and in free floating voxels which represent the subcortex.

![select surfaces](../img/task4_ciftifmri.png)

* to navigate the volume data more conveniently you can click on the **Volume** view to access the traditional volume viewing interface.

![select surfaces](../img/task4_ciftivolume.png)

* in both the voxel and surface view individual fmri instances at each TR can be viewed by clicking on the **map** drop down and selecting the time instance of interest.

![select surfaces](../img/task4_changetime.png)

* One nice application within `wb_view` is the ability to interactively view functional connectivity. To see this in action we can load in Freesurfers Destrieux atlas which has been converted to gifti file. The left and right hemisphere atlases are called `100307.L.aparc.a2009s.32k_fs_LR.label.gii` and `100307.R.aparc.a2009s.32k_fs_LR.label.gii`. When you click on any bran area then you see the areas of the brain that are correlated.

![select surfaces](../img/task4_dynconn.png)

* for the above we used a different color map which is accessible from the little spanner symbol.

![select surfaces](../img/task4_changecolors.png)

* Back to `matlab` now so we can explore a little more how the CIFTI file stores both volumes and surfaces in the same NIFTI-2 file. Run section E to se how the CIFTI XML has different sections fro surfaces and for voxels. Note that each volume struture has an individual label e.g CITFI_STRUCTURE_ACCUMBENS_LEFT 

* In section F1, we will now take an arbitrary vertex 17617 in the Right hemisphere and plot the fmri data in that vertex along with its closest neighbors. Observe that we have to check for existence in the available list of vertices because one of the neighbors might actually be in the medial laer.

    `neighindex=ismember(visverts,allverts);`

Notice also how we have to pinpoint the vertex within the data by using an offset because the data starts with values in the left cortex first.

    `findRHneighbors=findneighbors + ciiall.diminfo{1}.models{2}.start`

![select surfaces](../img/task4_timeseries.png)

* In section F2, we do the same for another arbitrary point on the Right cortex, vertex 8470

* In section G, we identfy an arbitrary voxel within the Left Hippocampus and identify its potential 26 neighbors. Again as with the vertices we check the `voxlist` for existence as some of these voxels might be in other structures and thus not accessible within the Left Hippocampus.In fact we find that there are 10 neighbors to voxel 

*  In Section H we simulate an fMRI signal and place identical copies of it in vertex 17617 and its 6 neighbors, vertex 8470 and its 6 neighbours and voxel 56,56,25 and its 26 neighbors. And finally in section I we save a copy of the cifti called `amended.rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii`

* Open wb_view and load in `amended.rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii` and the right surface `100307.R.midthickness.native.surf.gii` and `100307.L.midthickness.native.surf.gii`. After that load in `100307.R.aparc.a2009s.32k_fs_LR.label.gii` and `aparc.a2009s+aseg.nii.gz`.

* Select **Volume** View and activate the `amended.rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii` layer. In the **SLice Indices/Coords** section enter in the voxel coordinates of the left hippocampal voxel `56,56,25`. The cross-hairs should center on that voxel. Zoom in to the voxel by using the mouse scroll wheel.

![select surfaces](../img/task4_hippovox1.png)


* Now activate the `aparc.a2009s+aseg.nii.gz` layer and click on the crosshairs to confirm that indeed voxel is `56,56,25` is in the Left Hippocampus. Also notice that the voxels around it have the same value as we would expect. 

![select surfaces](../img/task4_hippovox2.png)

* Deactivate the `aparc.a2009s+aseg.nii.gz` layer and now change the `amended.rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii` layer. to `dynconn - rfMRI_REST1_LR_Atlas_hp2000_clean.dynconn`

![select surfaces](../img/task4_hippodyncon.png)

* Now change the view to **Surface** and activate the `dynconn - rfMRI_REST1_LR_Atlas_hp2000_clean.dynconn` layer. You should be able to identify that the vertices 8470 and 17617 are functionally connected to the hippocampus

![select surfaces](../img/task4_surfdynconn.png)

* You may want to experiment with different color palette settings and/or views to get a more dramatic effect. Shown below is the `magma` color palette with a range defined from `0.2` to `-0.2` used in the **All** view with the voxel settings set at `56,56,25`.

![select surfaces](../img/task4_colorpalette.png)

* Clicking on the right hemisphere outside of vertices 8470 or 17617 will reduce the functional connectivity of the hippocampal voxels. 


![select surfaces](../img/task4_nosurfdynconn_magma.png)

* And clicking on those vertices will reestablish the functional connectivity with the hippocampus.

![select surfaces](../img/task4_surfdynconn_magma.png)

* This concludes this introduction to the GIFTI and CIFTI formats.

## Final words

This practicum is just the beginning of your journey to working with surface-based formats. The hope is that you will feel comfortable using data if it is presented to you in either a GIFTI or CIFTI format. Please provide any corrections and suggestions by [email](mailto:chidiugonna@arizona.edu) or as issues on [GitHub](https://github.com/chidiugonna/BrainSurfing)