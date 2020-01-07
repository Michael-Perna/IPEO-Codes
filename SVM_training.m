function [model_svm_cv, label_valid, data_valid_sc, dataMax, dataMin] = SVM_training(img, roi, labels) 
% Exercise 4B - Supervised classification
% Version: adapted version of the Exercice 4B October 31, 2017
% Author(s): Matthew Parkan, Pinar Akyazi, Frank de Morsier
%==========================================================================
%% Input
%==========================================================================
labels = 1:length(labels);

%==========================================================================
%% Upload polygonal regions of interest (roi) 
%==========================================================================
    % Get image info:
    R = geotiffinfo('./Data/2018-03-12/2018-03-12, Sentinel-2A L1C, B03.tiff');

    % Get x,y locations of pixels:
    [x,y] = pixcenters(R);
    % Convert x,y arrays to grid:
    [X,Y] = meshgrid(x,y);

    % Remove trailing nan from shapefile
    mask = zeros(size(X,1),size(X,2), length(roi));
    mask_new = zeros(size(X,1),size(X,2),length(roi));

    for r = 1:length(roi)
            for p = 1:length(roi{r})
                rx = roi{r}(p).X(1:end-1);
                ry = roi{r}(p).Y(1:end-1);
                mask_new(:,:,r) = inpolygon(X,Y,rx,ry);
                mask(:,:,r) = mask(:,:,r) + mask_new(:,:,r);
            end
    end
    
    mask_tot = sum(mask(:,:,:),3);

%==========================================================================
%% supervised classification
%==========================================================================
    % Reshape the data into a 2d matrix
     data = reshape(img,size(img,1)*size(img,2),size(img,3));
    % data = reshape(images.B03,size(images.B03,1)*size(images.B03,2),1);

    % Get pixels from each class mask (polygons)
    index = find(mask_tot);
    data_roi = data(index,:);


    % concatenate the vector of labels
    label_roi = [];

    for r = 1:length(labels) % for each polygon

        % Create a vector with the label of the polygon class
        label_roi = [label_roi; repmat(labels(r),size(mask(:,:,r),1),1)];

    end

    % Split into training and testing samples to evaluate performances
    trainID = 1:10:length(label_roi);
    testID = setdiff(1:length(label_roi),trainID);

    % Subsample the training and the validation (test) data + labels
    data_train = data_roi(trainID,:);
    label_train = label_roi(trainID);

    data_valid = data_roi(testID,:);
    label_valid = label_roi(testID);


%==========================================================================
%%  Rescale the training data using this function classificationScaling
%==========================================================================
    % The following function can rescale the data between [0,1] or that it has
    % a unit variance and zero mean
    typeNorm = 'minmax'; % use 'std' to rescale to a unit variance and zero mean
    [data_train_sc, dataMax, dataMin] = classificationScaling(double(data_train), [], [], typeNorm);

%     % Rescale accordingly all image pixels
%     % note: the parameters used on the training pixels are given as arguments in the
%     % function to rescale accordingly the rest of the pixels
%     data_sc = classificationScaling(double(data), dataMax, dataMin, typeNorm);
% 
    % The same for the validation pixels
    data_valid_sc = classificationScaling(double(data_valid), dataMax, dataMin, typeNorm);

%==========================================================================
%% Training model
%==========================================================================
    % Train a SVM model (fitcecoc() function is for multi-class problems)
    model_svm = fitcecoc(data_train_sc,label_train);

    % Performs cross-validation to tune the parameters: crossval() function
    % (split the training data in order to train and test on different samples and tune correctly the parameters) 
    model_svm_cv = crossval(model_svm);

end 