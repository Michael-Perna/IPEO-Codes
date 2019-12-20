function [] = SVM_classification(img) 
% This function runs an SVM classification 

%% trace polygonal regions of interest (roi) in the RGB composite

% The traceROI() function returns 3 arguments:
% labels: N x 1 vector containing the class label for each polygon
% polygons: N x 1 cell array containing the xy coordinates of each ROI polygon
% index: N x 1 cell array containing the corresponding pixel indices of each ROI polygon

traceROI(img(1).RGB);


%% supervised classification
% Reshape the data into a 2d matrix
data = img(1).RGB; %to update with specific bands 

% %if using more input data 
% data_rgb = reshape(double(img(1).RGB),size(img(1).RGB,1)*size(img(1).RGB,2),size(img(1).RGB,3));
% data_std = reshape(Im_std,size(img(1).RGB,1)*size(img(1).RGB,2),1);
% data_entropy = reshape(Im_entropy,size(img(1).RGB,1)*size(img(1).RGB,2),1);
% % Here you concatenate the 3 spectral bands R-G-B and the 1st order
% % statistic "std" and the 5 co-occurences statistics (contrast, corr,
% % energy, homog. and entropy)
% data_stats = [data_rgb data_std Im_stats' data_entropy]; % ' is because Im_stats is in rows, we want columns 

% Get pixels from each class mask (polygons)
data_roi = data(cell2mat(index),:);
 
% concatenate the vector of labels
label_roi = [];

for c = 1:length(polygons) % for each polygon
    
    % Create a vector with the label of the polygon class
    label_roi = [label_roi; repmat(labels(c),size(index{c},1),1)];
    
end

% Split into training and testing samples to evaluate performances
testID = 1:5:length(label_roi); %4/5 used for training, 1/5 for accuracy
trainID = setdiff(1:length(label_roi),testID);

% Subsample the training and the validation (test) data + labels
data_train = data_roi(trainID,:); 
label_train = label_roi(trainID);

% Validaton data from traced polygons
data_valid_1 = data_roi(testID,:); 
label_valid_1 = label_roi(testID);

% Validaton data from deforestation shapefile

% Get image info:
R = geotiffinfo('Data\2018-03-12\2018-03-12, Sentinel-2A L1C, B02.tif'); 
% Get x,y locations of pixels:
[x,y] = pixcenters(R);
% Convert x,y arrays to grid:
[X,Y] = meshgrid(x,y);
roi2 = shaperead('Deforestation\Deforestation_2018.shp');
% Remove trailing nan from shapefile
rx = roi2.X(1:end-1);
ry = roi2.Y(1:end-1);
mask = inpolygon(X,Y,rx,ry); %binary (0,1)

% Get index values (like we did previously): 
% Get pixels from each class mask (polygons)
data_valid_2 = data(find(mask==1),:); 
label_valid_2 = ones(size(data,1),1); %multiply in front of the ones the label value (for deforestation)

% Combine the two matrices to get one matrix for validation data
data_valid = [data_valid_1; data_valid_2]
label_valid = [data_valid_1 data_valid_2]


%% Rescale the training data using this function classificationScaling

% The following function can rescale the data between [0,1] or that it has
% a unit variance and zero mean
typeNorm = 'minmax'; % use 'std' to rescale to a unit variance and zero mean
[data_train_sc, dataMax, dataMin] = classificationScaling(double(data_train), [], [], typeNorm);

% Rescale accordingly all image pixels
% note: the parameters used on the training pixels are given as arguments in the
% function to rescale accordingly the rest of the pixels
data_sc = classificationScaling(double(data), dataMax, dataMin, typeNorm);

% The same for the validation pixels
data_valid_sc = classificationScaling(double(data_valid), dataMax, dataMin, typeNorm);

%% Training model

% Train a SVM model (fitcecoc() function is for multi-class problems)
model_svm = fitcecoc(data_train_sc,label_train);

% Performs cross-validation to tune the parameters: crossval() function
% (split the training data in order to train and test on different samples and tune correctly the parameters) 
model_svm_cv = crossval(model_svm);

% Classifying entire image
class_svm = predict(model_svm_cv.Trained{1}, data_sc);

%% Visualizing classification map

% figure
% subplot(131);
% imagesc(label2rgb(reshape(class_gml,size(img(1).RGB,1),size(img(1).RGB,2)),'jet'))
% title('GML classification');
% axis equal tight
% xlabel('x')
% ylabel('y')
% 
% subplot(132);
% imagesc(label2rgb(reshape(class_knn,size(img(1).RGB,1),size(img(1).RGB,2)),'jet'))
% title(['k-NN classification (k=',int2str(k_knn),')']);
% axis equal tight
% xlabel('x')
% ylabel('y')
% 
% subplot(133);
% imagesc(label2rgb(reshape(class_svm,size(img(1).RGB,1),size(img(1).RGB,2)),'jet'))
% title('SVM classification ');
% axis equal tight
% xlabel('x')
% ylabel('y')


%% Compute accuracy measures

% Use the test pixels (data_valid) and labels (label_valid) that have been taken out earlier as validation
% set of pixels from which we can measure accuracy

% Run the trained classifier on the validation set
class_svm_valid = predict(model_svm_cv.Trained{1}, data_valid_sc);

% Get the Confusion tables
CT_svm = confusionmat(label_valid, class_svm_valid); % build confusion matrix

% Get OVerall Accuracies
OA_svm = trace(CT_svm)/sum(CT_svm(:));

% Get Kappa statistics
CT_svm_percent=CT_svm./sum(sum(CT_svm));
EA_svm = sum(sum(CT_svm_percent,1)*sum(CT_svm_percent,2));
Ka_svm= (OA_svm - EA_svm)/(1-EA_svm);

end 