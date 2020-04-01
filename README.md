# peeqMap
A MATLAB package for producing earthquake shake maps using very dense urban, dense urban and regional seismic networks

TERMS OF USE
   If you use peeqMap or any function(s) of it, you need to acknowledge 
   peeqMap by citing the following article:

   Sadeghi-Bagherabadi, A., Sadeghi, H., Fatemi Aghda, S.M., Sinaeian, F., Mirzaei Alavijeh, H., Farzanegan, E., Hosseini, S.K., Babaei, P., (2013). Real-time mapping of PGA distribution in tehran using TRRNet and peeqMap. Seismol. Res. Lett., 84(6):1004–13. https://doi.org/10.1785/0220120165.   

There are 2 subfolders:
1.	input_folder
2.	output_folder
input_folder contains another subfolder called BA08 including 4 tables of BA08 NGA. 
The contents of the other 3 folders in input_folder are sample input files for running peeqMap. 
	INPUT FILES:
1.	reg_station_info.txt or urb_station_info.txt or Vurb_station_info.txt: This file comprises 5 columns:
-	The first column: longitudes of the recording stations
-	The second column: latitudes of the recording stations 
-	The third column: Peak Ground Motion Parameter (PGP) in L component of the recording stations
-	The fourth column: PGP in T component of the recording stations
-	The fifth column: Vs30 beneath each station
Note:
For producing VERY DENSE URBAN shakemaps the first 5 characters of the name of the input file must be:
Vurb_ 
For producing URBAN shakemaps the first 4 characters of the name of the input file must be:
urb_ 
For producing REGIONAL shakemaps the first 4 characters of the name of the input file must be:
reg_ 
            
 (The number of rows in the input file is equal to number of recording stations)

2.	mag_loc.txt: This file comprises 1 row and 3 columns:
-	The first column: Longitude of the epicenter
-	The second column: Latitude of the epicenter
-	The third column: Moment magnitude of the occurred earthquake

3.	Win_lim.txt: There are 4 numbers in this file:
-	The first and second numbers in the first row are the minimum and maximum latitudes respectively that you want to plot Shaking map between them.
-	The first and second numbers in the second row are the minimum and maximum longitudes respectively that you want to plot Shaking map between them

4.	Scattered_V30.txt: This file comprises 3 columns:
-	The first column: longitudes of the scattered points that their Vs30 is defined
-	The second column: latitudes of the scattered points that their Vs30 is defined
-	The third column: Vs30 beneath each point
(The number of rows in Scattered_V30.txt is equal to number of the scattered points that their Vs30 is defined)
For producing PGA shaking maps at least reg_station_info.txt   and Scattered_V30.txt must be available.
For producing PGV or PSA shaking maps at least reg_station_info.txt, Scattered_V30.txt and mag_loc.txt must be available.
	WHERE SHOULD INPUT FILES BE LOCATED?
The above-mentioned input files apart from 4 tables of BA08 must be in input_folder. So, if you are interested in using presented sample input files you have to copy them from their folder to input_folder.
	INPUT VARIABLES:
Before running peeqMap following 3 variables must be assigned by users:

1.	     M_Map_tag : M_Map_tag = 1 if you are interested in using M_Map (https://www.eoas.ubc.ca/~rich/map.html) for plotting Results
                  : M_Map_tag = 0 if you do not

2.	       pgp_tag : pgp_tag = 'PGA' For estimation of PGA
            	         : pgp_tag = 'PGV' For estimation of PGV
       	         : pgp_tag = The desired period for estimation of PSA

3.	     FaultType : FaultType = 1 For unspecified fault type
            	   : FaultType = 2 For strike slip fault
                  : FaultType = 3 For normal fault
            	   : FaultType = 4 For reverse, thrust fault


After preparing the input files you have to assign the input variables in the MATLAB environment. The following commands is just an example for producing PGA shaking map of an earthquake with UNSPECIFIED FAULT TYPE while, M_Map is not installed on our computer:
pgp_tag = 'PGA';
FaultType = 1;
 M_Map_tag = 0;
Now, if the peqMap folder is the Current Folder in MATLAB you just need to run peeqMap.m by this command:
eval peeqMap;

Note:
Please, consider the progress of the algorithm and messages that peeqMap will display in MATLAB Command Window.

	OUTPUT FILES:
output_folder is containing 2 subfolders:

1.	txt_outputs
2.	visual_outputs

.txt results could be found in output_folder\txt_outputs\
.tif results could be found in output_folder\visual_outputs\

Note:
peeqMap after running will delete all of the previous .txt and .tif outputs from its 2 subfolders (output_folder\txt_outputs\ and output_folder\visual_outputs\).

peeqMap will save output files with .tif and .txt extensions. 

Considering the used algorithm and scale of the produced shakemap (VERY DENSE URBAN, URBAN and REGIONAL) a number of files will be produced. 

Amplified_Values.txt is the final shakemap data with .txt extension. 
