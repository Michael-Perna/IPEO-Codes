% IMAGE PROCESSING FOR EARTH PROJECT, November 2019
% Project: Palm Oil Plantation detection in Kalimatan Region 
% Written by Leona Repnik & Michael Perna

%% Set the data directory
directory = './Data';

%% 0. Upload image 
% used double differences
[bands, ~, REFMAT, ~] = uploadTiff(directory);

%% 1. Histogram matching 

Histogram_matching(bands);

%% 2. Bands indices --> vendredi
img = trueColor(bands);
img = doNDVI(bands, img);
img = doNDMI(bands, img);

%% Plot results
plotIndices(img, REFMAT);

%% 3. Morphology 

%% 4. Difference Image Analysis

%% 6. Accuracy Assesement 





