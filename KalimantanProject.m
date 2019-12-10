% IMAGE PROCESSING FOR EARTH PROJECT, November 2019
% Project: Palm Oil Plantation detection in Kalimatan Region 
% Written by Leona Repnik & Michael Perna
close all 
%% Set the data directory
directory = './Data';

%% 0. Upload image 
% used double differences
[bands, ~, REFMAT, BBOX] = uploadTiff(directory);

%% 0.1 Region of intrest
% refmat = makerefmat('RasterSize', size(bands(1).B02), ...
%     'LatitudeLimits',  [ 6.863818069469999e+04,-3.427046674042370e+04 ], ...
%     'LongitudeLimits', [ 1.284429739730507e+07,1.294529441923269e+07 ]);
% 
% coord.ZoomPalm = [ 1.284429739730507e+07,1.294529441923269e+07; ...
%                    6.863818069469999e+04,-3.427046674042370e+04 ];
% coord.ZoomForest = [ 1.284429739730507e+07,1.294529441923269e+07;
%                      6.863818069469999e+04,-3.427046674042370e+04] ;
% coord.ZoomDefor = [ 1.284429739730507e+07,1.294529441923269e+07; ...
%                     6.863818069469999e+04,-3.427046674042370e+04 ];


%% 1. Histogram matching 

% Histogram_matching(bands, edit);

%% 2. Bands indices --> vendredi
img = trueColor(bands);
img = doNDVI(bands, img);
img = doNDMI(bands, img);

%% Plot results
plotIndices(img, REFMAT);

%% 3. Morphology 
[dilation, closing] = DarkMorphoAnalysis(img);
[erosion, opening] = LigthMorphoAnalysis(img);

%% 3.1 Morphology results 
time = 1;
plotMorpho(dilation, closing,'B08', REFMAT, time)  
           
%% 4. Difference Image Analysis

%% 6. Accuracy Assesement 





