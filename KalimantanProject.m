% IMAGE PROCESSING FOR EARTH PROJECT, November 2019
% Project: Palm Oil Plantation detection in Kalimatan Region 
% Written by Leona Repnik & Michael Perna
close all 

%==========================================================================
%% Settings
%==========================================================================
data_directory = './Data';
do_train = 1;

%==========================================================================
%% 0. Upload image 
%==========================================================================
% used double differences
[images_ref, ~, ~, ~] = uploadTiff(data_directory);

%==========================================================================
%% 1.0 Image enhancement 
%==========================================================================

% Cut to reduce the effects of clouds on the adjustment of the image
limits.x = [ 1504, 2526 ];
limits.y = [ 242, 2066 ];

% plotCut(images_ref, 2, 'B05', limits);

% Enancement of the contrast
images =  enhancement(images_ref);

%% 1.1 Plots
close all
time = 1;
plotEnhancement(images_ref, images, time, 'B11')
%% Normalization function
%imnorm = @(x) (x - min(x(:))) ./ (max(x(:)) - min(x(:)));
%==========================================================================
%% 2.0 Histogram matching 
%==========================================================================

[cdf, cdf_ref, images] = Histogram_matching(images_ref, limits);

%% 2.1 Plot
close all
plotHistMatch(cdf_ref, cdf, images_ref, images, 'B11')

%==========================================================================
%% 3.0. Bands indices
%==========================================================================
 
images = trueColor(images);
images = doNDVI(images);
images = doNDMI(images);

%% 3.1 Plot results
close all
plotIndices(images);

%==========================================================================
%% 4.0 Morphology 
%==========================================================================

% [dilation, closing] = DarkMorphoAnalysis(badns);
% [erosion, opening] = LigthMorphoAnalysis(images);

%% 3.1 Morphology results 
time = 1;
%plotMorpho(dilation, closing,'B02', REFMAT, time)  
           
%==========================================================================
%% 5.0 Classification - training set 
%==========================================================================
img(:,:,1) = images(1).NDMI;
img(:,:,2) = images(1).B11;
img(:,:,3) = images(1).B03;
img(:,:,4) = images(1).B03;
img(:,:,5) = images(1).B05;
img(:,:,6) = images(1).B07;
img(:,:,7) = images(1).B06;
img(:,:,8) = images(1).B12;

%read shape file
roi{1,1} = shaperead('./Deforestation/Clouds_2018.shp');
roi{2,1} = shaperead('./Deforestation/Forest_2018.shp');
roi{3,1} = shaperead('./Deforestation/Deforastation_reduced_2018.shp');
roi{4,1} = shaperead('./Deforestation/PalmOil.shp');
roi{5,1} = shaperead('./Deforestation/River_2018.shp');
labels = { 'Clouds' ...
           'Forest' ...
           'Deforastation' ...
           'Palm Tree' ...
           'River' };

%==========================================================================
%% 5.1 SVM_training
%==========================================================================
if do_train == 1
    [model_svm_cv, label_valid, data_valid_sc, dataMax, dataMin] = ...
        SVM_training(img, roi, labels); 
    filename = 'training';
    save(filename, 'model_svm_cv','label_valid', 'dataMax', ...
        'dataMin', 'data_valid_sc')
end
%==========================================================================
%% 5.1 Classification
%==========================================================================
training = load('training.mat');
[class_svm, acccuracy] = SVM_classification(training, img);

%==========================================================================
%%  Texture analysis
%==========================================================================
texture(images(1).B11)


