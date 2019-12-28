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

% Cut to reduce the effects of clouds on the first image
limits.x = [ 1504, 2526 ];
limits.y = [ 242, 2066 ];

plotCut(images, time, 'B05', limits);

%% Enancement of the contrast
images =  enhancement(images_ref, limits);

%% Plots
time = 1;
plotEnhancement(images_ref, images, time, 'B8A')

%==========================================================================
%% 2.0 Histogram matching 
%==========================================================================

[cdf, cdf_ref, images_new] = Histogram_matching(images, limits);

%% 1.1 Plot
plotHistMatch(cdf_ref, cdf, images, images_new, REFMAT,  'B03')

%==========================================================================
%% 3.0. Bands indices
%==========================================================================
 
images = trueColor(images);
images = doNDVI(images);
images = doNDMI(images);

%% Plot results
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

%==========================================================================
%% 60. Accuracy Assesement 
%==========================================================================







