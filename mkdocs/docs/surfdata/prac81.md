# Practicum 8.1 -  Surface-Based Data Formats

## Synopsis
Surface-based data formats represent neuroimaging data as surface maps where anatomical locations are represented by vertices joined together in a mesh by edges to form triangles. 

### Objectives
This practicum will introduce you to working with the GIFTI, NIFTI-2 and CIFTI file formats. By the end of this practicum you should

* Be able to access the metadata of GIFTI and CIFTI files to determine their properties
* Be able to directly access the image data in a GIFTI and CIFTI file and work with it
* Be able to change the data in a GIFTI and CIFTI file and create a new file with your changes
* Visualize your GIFTI and CIFTI files using the workbench tool


### Prior Experience 
This practicum uses the connectome workbench, matlab and python in jupyter notebooks. 


### Workbench
For this practicum, download and install the HCP's [Connectome workbench](https://www.humanconnectome.org/software/get-connectome-workbench). We will be using `wb_view` for viewing CIFTI and GIFTI files.

You are not expected to have any experience of using workbench we will be using it mostly as a basic visualization tool. If you want to go further with the connectome workbench then you can register at [Connectome db](https://db.humanconnectome.org/) and access the guide and tutorial data online.

### Data
We will be using data from the Human Connectome Project - specifically data from subject 100307. We will also be using anonymized data from the U of A. You can download the data from here.


### Repository
You can clone the [repository](https://github.com/chidiugonna/BrainSurfing) by using the command `git clone or https://github.com/chidiugonna/BrainSurfing`.


## Task 1: Use wb_view to visualize GIFTI surfaces

* Open wb_view either by double-clicking the `wb_view` icon in windows or by entering `wb_view` in the command line
* When **wb_view** opens click the middle `skip` button to get to the main screen
* From the top menu choose `File` > `Open File` and change the dropdown on `Files of type:` to filter instead on `Surface Files (*.surf.gii)`
* Now navigate to `../DATA/HCP/100307/MNINonLinear/Native/`
* You will be presented with a host of files
* with the left mouse button click on `100307.L.pial.native.surf.gii`
* Now pressing the CTRL key again click with the left mouse buton on `100307.R.pial.native.surf.gii`. You should see that both files are reflected in the `File name` textbox.
* Now click `open`, you should see the left and right pial surfaces displayed with lateral and medial views

![select surfaces](../img/task1_selectsurfs.png)

* At top of the application change from **(1) Montage** to  **(2) All** by clicking on the tab. You should see the left and right pial surfaces aligned on the screen. Use your mouse left button to rotate the brain around and your scroll wheel to zoom in and out

* For the rest of this  exercise we just want to work with left hemisphere so we will uncheck the display for the right cortex in the **(2) All** tab.

![select surfaces](../img/task1_justleft.png)

* Switch on edge view by clicking the `Surface` menu option. Choose  `Properties`  and change the `Drawing Type` to `Links`. Zoom in a little closer to see the triangular tesselation.

* identify any vertex you like and click on it.  Notice that the vertex symbol icon is much larger than the size of the edges. For this example I have stumbled upon vertex `119115` which I have decided to probe.

![select vertex first](../img/task1_firstselect.png)

* Choose `Properties` in the **information** window and change the `Symbol Diameter` and `Most Recent ID Symbol Diameter` to a suitable size. We chose `0.5mm` for our example. You can also change the `ID Symbol Color` to anothe value.

![select vertex small icon](../img/task1_secondselect.png)

* Select all the neighbouring vertices. These should show up in the information screen. You can select and copy the text from this screen and place it in a text file. We will need this information for the next Task.

![select all vertices](../img/task1_allselected.png)

## Task 2: Use Matlab to manipulate GIFTI Surfaces
** in this task we will be loading in the `100307.L.pial.native.surf.gii` surface and identifying the vertex and vertex neighbours we located in task 2 above. We will then nudge these vertices by a random 3D translation and then save a new copy of the surface which we will visualize again wb_view.

* To complete this task you will need to download the GIFTI matlab library `gifti-zip` from [here](https://www.artefact.tk/software/matlab/gifti/) and extract it to a folder location.

* Open matlab and navigate to the folder containing `task_002_giftisurf.m`

* We will run individual sections by right clicking on the section and selecting `Evaluate Current Section`. Select the 1st section and change the path to point to the location of the Gifti library and choose `Evaluate Current Selection to run`

![select all vertices](../img/task2_01_matlab_addlib.png)

* Now ensure thart `mysurf` in the section `A. Open HCP Native lh pial mesh` is pointing to the correct location for the data and then right click and run.

![select all vertices](../img/task2_02_matlab_loadgifti.png)

* This section also plots a 3D model of the surface which can be rotated with the mouse.

![select all vertices](../img/task2_03_giftiplot.png)

* Now run the next section to find the neignbours of the vertex you located in task 1 above. Remember to change the vertex on line 20 `ciftivind=` to point to your vertex. If all goes well then you should see the same vertices you observed in `wb_view` noticing the fact that `wb_view` starts indexing vertices from 0 while matlab starts indexing from 1.

![select all vertices](../img/task2_findvertices.png)

* Now we will run section C to peturb each neighbouring vertex by a random number between 2 and -2 mm. Just right click on the section and run it and it should create a file called `amended.100307.L.pial.native.surf.gii` in your current folder.

![select all vertices](../img/task2_nudge.png)

* The next two sections can be skipped and performed later if you want. Section D allows you to view the GIFTI metadata in a browser to see how XML is used to manage the data used in the GIFTI format. Section E accomplishes the same as Section D except that now the xml data is loaded into a structure.

![select all vertices](../img/task2_optionalD.png)

![select all vertices](../img/task2_optionalE.png)

* Open your amended GIFTI surface `amended.100307.L.pial.native.surf.gii` in wb_view
* Now open the original `100307.L.pial.native.surf.gii` for comparison
* By default there are two tabs provided when you first open wb_view these are **(1) Montage** and **(2) All** 
* You can click on any of the tabs and change the View to **Surface** by clicking the corresponding radio button or create a new tab 
![select all vertices](../img/task2_newtab.png)

![select all vertices](../img/task2_choosesurface_RB.png)

* Notice that under `Brain Structure and Surface` that our `amended.100307.L.pial.native.surf.gii` is the selected surface because we loaded it in first.

* let's locate our original vertex from task 1.  Switch on vertex view by clicking the `Surface` menu option. Choose  `Properties`  and change the `Drawing Type` to `Vertices` and press Close

* Now click on `Window` and then `identify`and click on the `identify Surface Vertex` and enter the vertex Index. For my Task 1 example I used `119115` you can use this vertex or one that you selected for yourself. **Remember** that the wb_view index starts from zero, while the matlab index starts from 1 and so my vertex `119115` in wb_view is actually indexed as `119116` in matlab. Because we are in wb_view I am going to use `119115`.

* After clicking `apply` it will help to change the size and color of the vertex symbol to a larger value and more vivid color respectively. In the `Information` dialog, click on properties and change the vertex color and size again. You may also have to rotate the brain if you chose a vertex hidden from the lateral view. You should be able to spot your vertex.

![select surfaces](../img/task2_locatevertex.png)

* Change the Surface properties to `Link(Edges)` and zoom in closer to see how the pertubations you made to the neighboring vertices have changed the topology. You will probably need to change the symbol diameter to something smaller. You should notice that the topology of your vertices has changed.

![select surfaces](../img/task2_amendedsurface.png)


* You can contrast this with the original by clicking back and forth  on the dropdown in the tab switching between the original and your amended or by clicking on a Montage window to see both surfaces side by side.

![select surfaces](../img/task2_leftpialoriginalview.png)

![select surfaces](../img/task2_montagecompare.png)

## Task 3: Use Matlab to manipulate and visualize GIFTI overlays
We have been able to work with and maniulate GIFTI surface files. In this task we will now look at the overlays that map values onto these vertices and attempt to manipulate and visualize them. For this task we will be looking at cortical thickness.

* Open wb_view as previously and load in the surface `100307.L.pial.native.surf.gii`. Click on Surface View to view the Left hemisphere. Now load in the cortical thickness overlay `100307.L.thickness.native.shape.gii`. You will need to filter on `Metric Files (*.func.gii *.shape.gii)` or `Any File (*)` to be able to select the thickness overlay. Activate the layer by clicking on the checkbox alongside it. Also click on the color bar to see the range of cortical thicknesses across the brain and their associated colors.

![select surfaces](../img/task3_loadOverlay.png)

* Now locate the vertices you looked at previously and identify their cortical thicknesses by looking at the information dialog. Notice that for our central vertex (119115 in this case) it has a cortical thickness of 3.54125 mm.

![select surfaces](../img/task3_viewThickness.png)

* We will now open this overlay in Matlab, change the cortical thickness and visualize the changed ovelay in wb_view

* as before run each section separately to follow along with what is happening in the code. The first unmarked section adds the path to the gifti matlab library.

* in the next section A we load in the surface and the cortical thickness overlay. Notice that these match as the number of vertices is equal to the number of thickness values. This code then plots the surface in one window and also plots the overlay over the surface in another. 

![select surfaces](../img/task3_overlaymesh.png)

* In section B we see a print out of the cortical thickness values at our neighbouring vertices. In Section C we set all the thicknesses to a uniform value of 2mm and then save a copy called 
`amended.100307.L.thickness.native.shape.gii`. Open this file after opening the `100307.L.pial.native.surf.gii` surface and confirm that the 9 vertices have a thickness value of 2mm.

![select surfaces](../img/task3_changeThickness.png)


## Task 4: Use Matlab to manipulate and visualize CIFTI files

So far we have learned to work with GIFTI files. In this last task we are going to work with CIFTI files which combine both volume data for subcortical structures and surface data for cortical structures. Unfortunately the HCP's matlab library is still in [Alpha testing](https://github.com/Washington-University/cifti-matlab) and so we need to be aware that the coding conventions may change however the overal conceptual approach should remain the same.

We will work with HCP data again and this time with CIFTI cortical thickness data `100307.thickness.native.dscalar.nii` from the left and right cortex and with CIFTI fMRI data `rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii` from both Left and Right cortex as well as from 19 other subcortical structures that are stored as volumes in a CIFTI file.

To visualize CIFTI data in `wb_view` we need a GIFTI surface file that is associated with the CIFTI data.

* open `wb_view` and load in GIFTI surface `100307.L.midthickness.native.surf.gii` - this surface is midway between the `pial` surface we used previously and the `white` surface. Now load in the midthickness surface for the right hemisphere `100307.R.midthickness.native.surf.gii`. Click on **All** view to see both hemospheres aligned in the view. You can rotate the whole brain to a perspective that works for you.

![select surfaces](../img/task4_alignedsurface.png)

* Now open `100307.thickness.native.dscalar.nii` - you will need to filteron **Files of type: (*.dscalar.nii)** to be able to select this file. Activate the layer by clicking on the checkbox and notice that this CIFTI file has cortical thickness information for both hemispheres. 

![select surfaces](../img/task4_ciftithickness.png)


* lets return to matlab and open the matlab file `task004_cifti.m` and execute the prelim section to load in the matlab libraries that mwe need. Make sure the paths to these libraries are correct. if they are not you will get an error message similar to that below

![select surfaces](../img/task4_wrongpath.png)

* Run section A to explore the CIFTI XML file in a matlab structure and in a browser. Notice that the first dimension is `CIFTI_INDEX_TYPE_SCALARS` which means that each vertex/voxel has a single scalar value which in this file is the cortical thickness. Also notce that the second dimenions is `CIFTI_INDEX_TYPE_BRAIN_MODELS` which is used to map every voxel/vertex in a cortical or subcortical structure. Just the  left cortex `CIFTI_STRUCTURE_CORTEX_LEFT` and the right cortex `CIFTI_STRUCTURE_CORTEX_RIGHT` are represented in this file.


![select surfaces](../img/task4_ciftixmlscalar.png)

The data structure `ciiall` contains all the cortical thickness data for both hemispheres in `ciiall.cdata` indexed starting from 1 to 125197 for the left cortex and from 125198 to 24848.

![select surfaces](../img/task4_ciftiscalardata.png)


But there appears to be an inconsistency. In the last task we had 130879 vertices in the left hemisphere but here we have about 5000 vertices fewer. What's going on? 

Essentially the HCP team do not store data for the medial layer of each cortex. We will identify these medial vertices and visualize a few of them on the left cortex.

* Run section B to print out all the vertices that are missing from the left cortex. These are the medial vertices. There should be `5682` vertices in the medial layer displayed to screen. Select one or a few of them and usin the `udentify` tool in`wb_view` try to see where they are. You will need to use the surface view and visualize the left cortex only so you can see these vertices. Some of these are easier to see than others.

![select surfaces](../img/task4_mediallayer.png)

* In section C and D we do what we did in task 3 and will now go ahead and change the value of a vertex and its neighbors to a constant value of 2mm cortical thickness. The code uses a vertex value of 119115 but of course you should use any vertex you like except for the medial vertices which the CIFTI file does not track. Open the `amended.100307.thickness.native.dscalar.nii` that is created in your current directory in wb_view and navigate to the vertex to confirm that changes have been made.

![select surfaces](../img/task4_changethickness.png)

* We now look at a slightly more complicated CIFTI file which stores fMRI data for a combination of Surface and Volume structures. We will be working in a standard space for this and so will close all the files in wb_view and then load in the surface which we will be using for this exploration.

![select surfaces](../img/task4_closefiles.png)

* Now open `100307.R.midthickness.32k_fs_LR.surf.gii` and `100307.L.midthickness.32k_fs_LR.surf.gii`, select the **All** view and then load in the fMRI `dtsereis.nii` CIFTI file `rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii`. Switch on the overlay and change the file from `dynconn - rfMRI_REST1_LR_Atlas_hp2000_clean.dynconn` to the dtseries and rotate the brain. Notice that their are values in both the cortex and in free floating voxels which represent the subcortex.

![select surfaces](../img/task4_ciftifmri.png)

* to navigate the volume data more conveniently you can click on the **Volume** view to access the traditional volume viewing interface.

![select surfaces](../img/task4_ciftivolume.png)

* in both the voxel and surface view individual fmri instances at each TR can be viewed by clicking on the **map** drop down and selecting the time instance of interest.

![select surfaces](../img/task4_changetime.png)

* One nice application within `wb_view` is the ability to interactively view functional connectivity. To see this in action we can load in Freesurfers Destrieux atklas which has been converted to gifti file. The left and right hemosphere atlases are called `100307.L.aparc.a2009s.32k_fs_LR.label.gii` and `100307.R.aparc.a2009s.32k_fs_LR.label.gii`. When you click on any bran area then you see the areas of the brain that are correlated.

![select surfaces](../img/task4_dynconn.png)

* for the above we used a different color map which is accessible from the little spanner symbol.

![select surfaces](../img/task4_changecolors.png)

* Back to `matlab` now so we can explore a little more how the CIFTI file stores both volumes and surfaces in the same NIFTI-2 file. Run section E to se how the CIFTI XML has different sections fro surfaces and for voxels. Note that each volume struture has an individual label e.g CITFI_STRUCTURE_ACCUMBENS_LEFT 

* We will now take an arbitrary vertex 17617 in the Right hemisphere and plot the fmri data in that vertex along with its closest neighbors. Notice how we have to pinpoint the vertex within the data by using an offset because the data starts with values in the left cortex first.

    `findRHneighbors=findneighbors + ciiall.diminfo{1}.models{2}.start`

![select surfaces](../img/task4_timeseries.png)





