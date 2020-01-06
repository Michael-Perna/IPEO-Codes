% IMAGE PROCESSING FOR EARTH PROJECT, November 2019
% Project: Palm Oil Plantation detection in Kalimatan Region 
% Written by Leona Repnik & Michael Perna
close all 

%==========================================================================
%% Settings
%==========================================================================
data = './Data';

%==========================================================================
%% 0. Upload image 
%==========================================================================
% used double differences
[images_ref, ~, REFMAT, BBOX] = uploadTiff(data);

%==========================================================================
%% 1.0 Image enhancement 
%==========================================================================

% Cut to reduce the effects of clouds on the adjustment of the image
limits.x = [ 1504, 2526 ];
limits.y = [ 242, 2066 ];

plotCut(images_ref, 2, 'B05', limits);

% Enancement of the contrast
images =  enhancement(images_ref, limits);

%% 1.1 Plots
time = 1;
plotEnhancement(images_ref, images, time, 'B8A')

%==========================================================================
%% 2.0 Histogram matching 
%==========================================================================

[cdf, cdf_ref, images_new] = Histogram_matching(images, limits);

%% 2.1 Plot
plotHistMatch(cdf_ref, cdf, images, images_new, REFMAT,  'B03')

%==========================================================================
%% 3.0. Bands indices
%==========================================================================
 
images = trueColor(images);
images = doNDVI(images);
images = doNDMI(images);

%% 3.1 Plot results
plotIndices(images, REFMAT);

%==========================================================================
%% 4.0 Morphology 
%==========================================================================

% [dilation, closing] = DarkMorphoAnalysis(badns);
% [erosion, opening] = LigthMorphoAnalysis(images);

%% 3.1 Morphology results 
time = 1;
%plotMorpho(dilation, closing,'B02', REFMAT, time)  
           
%==========================================================================
%% 5.0 Difference Image Analysis
%==========================================================================
img(:,:,1) = images(1).NDMI;
% img(:,:,2) = images(1).NDVI;
% img(:,:,3) = images(1).B02;
% img(:,:,4) = images(1).B03;
% img(:,:,5) = images(1).B04;
%read shape file
roi{1,1} = shaperead('./Deforestation/Clouds_2018.shp');
roi{2,1} = shaperead('./Deforestation/Forest_2018.shp');
roi{3,1} = shaperead('./Deforestation/Deforestation_2018.shp');
labels = [1;2;3];
SVM_classification(img, roi, labels);
%==========================================================================
%% 6.0 Accuracy Assesement 
%==========================================================================



