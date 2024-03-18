%% MATLAB scripts - Paraná Project

% This script is a compilation of TAK (Topographic Analysis Kit) functions.
% The student will first generate the DEM, Flow Direction (FD), Flow
% Accumulation (A), e Stream Network (S) with the MakeStream function.

% Then, one will select the basin (or basins) of interest via BasinPicker.
% By doing so, it is possible to run the ProcessRiverBasins and, if it is
% necessary, the SubDivideBigBasins. Both functions calculates different
% geomorphic variables (drainage area, slope, ksn, ...). All this data will 
% be used to create a Shapefile to work on at Arcgis or Qgis. 

% Finally, one must compile all this data in a txt file via CompileBasinsStats function. 

%% 1) Generating DEM, FD, A, S (function: MakeStreams)

dem = "filepath"
[DEM,FD,A,S]=MakeStreams(dem,1e6); 

imageschs(DEM);

% Save the outputs ('Home'>'Save Workspace'). You will use them to run other times for the
% different basin groups.

%% 2) BasinPicker

% BasinPicker
[Outlets]=BasinPicker(DEM,FD,A,S); % the output 'Outlets' will be used on the following function

%% 3) ProcessRiverBasins and SubDivideBigBasins

% ProcessRiverBasins:

% IMPORTANT: Use the month, day, and year to modify 'MM_DD_YYYY'
% IMPORTANT: Indicate the capture number ('Capture_XXX')

ProcessRiverBasins(DEM,FD,A,S,Outlets,'Capture_XXX_MM_DD_YYYY_Parana_Project','write_arc_files',true,'calc_relief',true,'relief_radii',[1000 2500 5000]);

% Now, go to the folder and create a 'SubBasins'folder. This is necessary
% for the next function ('SubDivideBigBasins').

% SubDivideBigBasins:

SubDivideBigBasins('Capture_XXX_MM_DD_YYYY_Parana_Project',100,'order','s_order',1,'ref_concavity',.45,'threshold_area',1e5); % First Order SubBasins
[MS]=Basin2Shape(DEM,'MM_DD_YYYY_Parana_Project_Group_X','uncertainty','both','include','all'); 


shapewrite(MS,'Capture_XXX_Basins_SubBasins_S_MM_DD_YYYY.shp') % XXX - index number of the capture

%% 4) CompileBasinStats

[T]=CompileBasinStats('/Users/You/basin_files'); % 'MM_DD_YYYY_Parana_Project_Group_X' folder