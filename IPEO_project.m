% IMAGE PROCESSING FOR EARTH PROJECT, November 2019
% Project: Palm Oil Plantation detection in Kalimatan Region 
% Written by Leona Repnik & Michael Perna
close all 
clc
%% Set the data directory
directory = './Data';

%% 0. Upload image 
% used double differences
[images, ~, REFMAT, BBOX] = uploadTiff(directory);

%% 1. Histogram matching 
[cdf, cdf_ref, images_new] = Histogram_matching(images, REFMAT);

%% 1.1 Plot
close all
time = 2;
plotHistMatch(cdf_ref, cdf, images, images_new, REFMAT,  time, 'B05')

%% 2. Bands indices --> vendredi
img = trueColor(images);
img = doNDVI(images, img);
img = doNDMI(images, img);

%% Plot results
plotIndices(img, REFMAT);
 
%% 4. Difference Image Analysis

SVM_classification(img) 

%% 6. Accuracy Assesement 





