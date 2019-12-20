% IMAGE PROCESSING FOR EARTH PROJECT, November 2019
% Project: Palm Oil Plantation detection in Kalimatan Region 
% Written by Leona Repnik & Michael Perna
close all 
%% Set the data directory
directory = './Data';

%% 0. Upload image 
% used double differences
[images, ~, REFMAT, BBOX] = uploadTiff(directory);

%% Image enhancement 



%% 1. Histogram matching 
time = 1;
limits = plotCut(images, time, 'B05');
[cdf, cdf_ref, images_new] = Histogram_matching(images, limits);

%% 1.1 Plot

plotHistMatch(cdf_ref, cdf, images, images_new, REFMAT,  'B03')

%% 2. Bands indices --> vendredi
img = trueColor(images);
img = doNDVI(images, img);
img = doNDMI(images, img);

%% Plot results
plotIndices(img, REFMAT);

%% 3. Morphology 
[dilation, closing] = DarkMorphoAnalysis(badns);
[erosion, opening] = LigthMorphoAnalysis(images);

%% 3.1 Morphology results 
time = 1;
%plotMorpho(dilation, closing,'B02', REFMAT, time)  
           
%% 4. Difference Image Analysis

%% 6. Accuracy Assesement 





