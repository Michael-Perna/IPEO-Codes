% IMAGE PROCESSING FOR EARTH PROJECT, November 2019
% Project: Palm Oil Plantation detection in Kalimatan Region 
% Written by Leona Repnik & Michael Perna

close all 
clear all

%==========================================================================
%% Input
%==========================================================================

% 
imagesOf_reference = load('imagesOf_reference.mat');
texture_analysis = load('texture_analysis.mat');

images_ref = imagesOf_reference.images_ref;

 
clear imagesOf_reference; texture_analysis; 

%==========================================================================
%% Settings
%==========================================================================
data_directory = './Data';
do_upload = 0;
do_train = 0;
do_texture_analysis = 0;
save_results = 1;
filename_training = 'training_reduced_4';
%==========================================================================
%% 0. Upload image 
%==========================================================================
% used double differences
if do_upload == 1
    [images_ref, CMAP, REFMAT, BBOX] = uploadTiff(data_directory);
    filename = 'imagesOf_reference_reduced.mat';
    save(filename, 'images_ref')
end
%==========================================================================
%% 0.1 Remove unneeded bands
%==========================================================================
% images_ref = rmv_bands(images_ref, {'B02', 'B03', 'B8A', 'B05', 'B07', 'B12'});
%==========================================================================
%% 0.2 Mask Bands bands
%==========================================================================
% mask = shaperead('./Data/Mask_reduced.shp');
% images_masked = maskImages(images_ref, mask); 

%==========================================================================
%% 1.0 Image Cut--> remove clouds
%==========================================================================
% Cut to reduce the effects of clouds on the adjustment of the image
% limits.y = [ 1442, 2526 ];
% limits.x = [ 1, size(images_ref(1).B11, 2) ];
% images_cut = imagesCut(images_ref, limits);

% plotImage(images_cut, 2, 'B11');
% plotCut(images_ref, 2, 'B11', limits);
% clear limits

%==========================================================================
%% 1.1 Image enhancement 
%==========================================================================
% Enancement of the contrast
images_en =  enhancement(images_ref);

%% 1.1 Plots
% close all
time = 1;
plotEnhancement(images_ref, images_en, time, 'B11')

%==========================================================================
%% 2.0 Histogram matching 
%==========================================================================

[cdf, cdf_ref, images] = Histogram_matching(images_en);

clear limits
%% 2.1 Plot

plotHistMatch(cdf_ref, cdf, images_en, images, 'B11')


%==========================================================================
%% 3.0. Bands indices
%==========================================================================
 
% images = trueColor(images);
images = doNDVI(images);
images = doNDMI(images);

%% 3.1 Plot results

% plotIndices(images);

%==========================================================================
%% 4.0 Morphology 
%==========================================================================

% [dilation, closing] = DarkMorphoAnalysis(badns);
% [erosion, opening] = LigthMorphoAnalysis(images);

%% 3.1 Morphology results 
% time = 1;
% %plotMorpho(dilation, closing,'B02', REFMAT, time)  

%==========================================================================
%%  Texture analysis
%==========================================================================
    time = 1;
    img_texture = images(2).B11;
    
if do_texture_analysis == 1
    [ texture_img ] = texture_analysis(img_texture, time);
    filename = 'texture_analysis';
    save(filename, 'texture')
end

% plotTextureAnalysis(texture_analysis, img_texture, time)           

%==========================================================================
%% 5.0 Classification - training set 
%==========================================================================
clear img
img(:,:,1) = images(2).NDMI;
img(:,:,2) = images(2).B11;
img(:,:,3) = images(2).NDVI;

% img(:,:,3) = images(1).B06;
% img(:,:,3) = images(2).B08;

% img(:,:,3) = images(1).B12;
% img(:,:,4) = images(1).B03;
% img(:,:,5) = images(1).B05;
% img(:,:,6) = images(1).B07;

% img(:,:,10) = images(1).corr;
% img(:,:,11) = images(1).energy;
% img(:,:,10) = images(1).homogen;

%read shape file
roi{1,1} = shaperead('./ROI_reduced/feauture_80.shp');
roi{2,1} = shaperead('./ROI_reduced/feauture_70.shp');
roi{3,1} = shaperead('./ROI_reduced/feauture_50.shp');
roi{4,1} = shaperead('./ROI_reduced/feauture_60.shp');
% roi{5,1} = shaperead('./ROI/feauture_20.shp');


% 80 --> forest 70 --> Palm Oil 60 --> Dark Forest --> Plantation
labels = { '60' ...
           '50' ...
           '70' ...
           '80'
           };

%==========================================================================
%% 5.1 SVM_training
%==========================================================================
if do_train == 1
    training = SVM_training(img, roi, labels); 
    save(filename, 'training')
end

%==========================================================================
%% 5.2 Classification
%==========================================================================

training = load('training_reduced_new.mat');
training = training.training;
img1(:,:,1) = images(1).NDMI;
img1(:,:,2) = images(1).B11;
img1(:,:,3) = images(1).NDVI;
[class_svm_1, acccuracy_2018] = SVM_classification(training, img1);
filename = '/results/acccuracy_2018';
save(filename, 'acccuracy_2018')

img2(:,:,1) = images(2).NDMI;
img2(:,:,2) = images(2).B11;
img2(:,:,3) = images(2).NDVI;
[class_svm_2, acccuracy_2019] = SVM_classification(training, img2);
filename = '/results/acccuracy_2019';
save(filename, 'acccuracy_2019')

diff = class_svm2 - class_svm1;
plotClass(class_svm_1, img1)
plotClass(class_svm_2, img2)
plotClass(diff, img2)
% 
% class_svm1_id = reshape(class_svm_1, size(img1,1), size(img1,2));
% class_svm2_id = reshape(class_svm_2, size(img2,1), size(img2,2));
% 
% class_svm1_id(class_svm1_id ~= 1) == 0;
% class_svm2_id(class_svm2_id ~= 1) == 0;

class_svm1 = label2rgb(reshape(class_svm_1, size(img1,1), size(img1,2)),'jet');
class_svm2 = label2rgb(reshape(class_svm_2, size(img2,1), size(img2,2)),'jet');
%==========================================================================
%% 6 Differences
%==========================================================================
class_svm1 = class_svm1(1:989, 1:1082, :);

diff = class_svm2 - class_svm1;
diff1 = class_svm2(:,:,1) - class_svm1(:,:,1);
diff2 = class_svm2(:,:,2) - class_svm1(:,:,2);
diff3 = class_svm2(:,:,3) - class_svm1(:,:,3);

imshow(diff)
imshow(diff1)
imshow(diff2)
imshow(diff3)
%==========================================================================
%% 6 Save Results
%==========================================================================
save_results = 0;
if save_results == 1
    filename1 = strcat('./results/', '2018_classification', '.tif');
    filename2 = strcat('./results/', '2019_classification', '.tif');
    filename3 = strcat('./results/', '2019_difference', '.png');
    filename4 = strcat('./results/', '2019_difference_cat1', '.tif');
    filename5 = strcat('./results/', '2019_difference_cat2', '.tif');
    filename6 = strcat('./results/', '2019_difference_cat3', '.tif');
    % filename3 = strcat('./results/', '2019_difference', '.tif');


    imwrite( class_svm1, filename1, 'tiff');  
    imwrite( class_svm2, filename2, 'tiff');  
    imwrite( diff, filename3, 'png'); 
    imwrite( diff1, filename4, 'tiff'); 
    imwrite( diff2, filename5, 'tiff'); 
    imwrite( diff3, filename6, 'tiff'); 
    % REF = geotiffinfo('./Data/2019-01-06/2019-01-06, Sentinel-2A L1C, B08');
    % 
    % saveImages(images, CMAP, REFMAT, class_svm_2, REF, size(img2),  svm2_filename)
    % saveImages(images, CMAP, REFMAT, class_svm_1, REF, size(img),  svm1_filename)
end
