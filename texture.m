% Exercise 4B - Supervised classification
% Version: October 31, 2017
% Author(s): Matthew Parkan, Pinar Akyazi, Frank de Morsier
function [ ] = texture(img)

%==========================================================================
% 1st order statistics: standard deviation and range min,max
%==========================================================================
    % Define a window size
    winSize = 3;
    % Compute standard dev and range on the red band
    Im_std = stdfilt(img, true(winSize));
    Im_rg = rangefilt(img(~isnan(img)), true(winSize));

    % Show the image
    figure
    subplot(1,2,1);
    imagesc(Im_std); 
    axis equal tight
    title(['std ',int2str(winSize),'x',int2str(winSize)]);

    subplot(1,2,2);
    imagesc(Im_rg); 
    axis equal tight
    title(['range ',int2str(winSize),'x',int2str(winSize)]);

%==========================================================================
%% 2nd order statistics: co-occurence
%==========================================================================
    % first define the GLCM distance d & directions theta
    d = 1;
    theta = [ 0, d; % Vertical
             -d, d; % diagonal 135degree
             -d, 0; % Horizontal              
             -d,-d]; % Diagonal 45degree

    % Add borders (padding) to the image (alternative to your code in TP3a!)
    padding_size = floor(winSize/2);
    Im_padded = padarray(img,[padding_size,padding_size],'both','replicate');

    % Transform the image into a set of window patches
    Im_p = im2col(Im_padded,[winSize winSize],'sliding'); % sliding

    % Compute the GLCM matrix on eaxch window patch    
    Im_stats = zeros(4,size(Im_p,2));
    % Prepare parallel computing

    for jj = 1:size(Im_p,2) % you can use parfor for parallel computations
        patch_tmp  = reshape(Im_p(:,jj),winSize,winSize);
        % use graycomatrix(Image,'Offset',theta,'Symmetric',true);
        GLCM = graycomatrix(patch_tmp,'Offset',theta,'Symmetric',true);

        % Compute the statistics from the GLCM matrix on patches
        % use graycoprops to get the contrast and some other statistics
        stats1 = graycoprops(GLCM,{'Contrast','Correlation','Energy','Homogeneity'});
        % Get the stats and average over the different directions
        Im_stats(:,jj) = [mean(stats1.Contrast); ...
                          mean(stats1.Correlation); ...
                          mean(stats1.Energy); ...
                          mean(stats1.Homogeneity)];  
    end

    % Reshape the matrix into separate images
    Im_contrast = reshape(Im_stats(1,:),size(img,1),size(img,2));
    Im_corr = reshape(Im_stats(2,:),size(img,1),size(img,2));
    Im_energy = reshape(Im_stats(3,:),size(img,1),size(img,2));
    Im_homogen = reshape(Im_stats(4,:),size(img,1),size(img,2));

    % Entropy is obtained from a filter on the image directly
    Im_entropy = entropyfilt(img(:,:,1), ones(winSize));

%% Display co-occurence results
figure
subplot(2,3,1);
imagesc(img);
title('original band');

subplot(2,3,2);
imagesc(Im_contrast);
title(['contrast ',int2str(winSize),'x',int2str(winSize)]);

subplot(2,3,3);
imagesc(Im_corr);
title(['correlation',int2str(winSize),'x',int2str(winSize)]);

subplot(2,3,4);
imagesc(Im_energy);
title(['energy',int2str(winSize),'x',int2str(winSize)]);

subplot(2,3,5);
imagesc(Im_homogen);
title(['homogeneity',int2str(winSize),'x',int2str(winSize)]);

subplot(2,3,6);
imagesc(Im_entropy);
title(['entropy',int2str(winSize),'x',int2str(winSize)]);

% %% Get the ROI and rescale the training testing data again
% % Create data matrix with all these additional statistics
% data_rgb = reshape(double(img),size(img,1)*size(img,2),size(img,3));
% data_std = reshape(Im_std,size(img,1)*size(img,2),1);
% data_entropy = reshape(Im_entropy,size(img,1)*size(img,2),1);
% % Here you concatenate the 3 spectral bands R-G-B and the 1st order
% % statistic "std" and the 5 co-occurences statistics (contrast, corr,
% % energy, homog. and entropy)
% data_stats = [data_rgb data_std Im_stats' data_entropy];
% % Good results already with only:
% %data_stats = [data_rgb Im_stats(3:4,:)'];
% 
% % Checks NaNs
% sum(isnan(data_stats)) % correlation may have some nans
% % Replace NaNs by zeros
% data_stats(isnan(data_stats)) = 0;
% 
% % Get pixels from each class mask (polygons)
% data_roi = data_stats(cell2mat(index),:);
% 
% % Subsample the training and the validation (test) data + labels
% data_train = data_roi(trainID,:);
% label_train = label_roi(trainID);
% 
% data_valid = data_roi(testID,:);
% label_valid = label_roi(testID);
% 
% 
% %% Rescale the training data using this function classificationScaling
% % The following function can rescale the data between [0,1] or that it has
% % a unit variance and zero mean
% typeNorm = 'minmax'; % use 'std' to rescale to a unit variance and zero mean
% [data_train_sc, dataMax, dataMin] = classificationScaling(double(data_train), [], [], typeNorm);
% 
% % Rescale accordingly all image pixels
% data_sc = classificationScaling(double(data_stats), dataMax, dataMin, typeNorm);
% 
% % The same for the validation pixels
% data_valid_sc = classificationScaling(double(data_valid), dataMax, dataMin, typeNorm);
% 
% %% Training model
% % Train a GML model and classifying entire image
% class_gml = classify(data_sc, data_train_sc, label_train, 'linear');
% 
% % Train a k-NN model
% k_knn = 5;
% model_knn = fitcknn(data_train_sc,label_train,'NumNeighbors',k_knn);
% % Classifying entire image for k-NN:
% class_knn = predict(model_knn,data_sc);
% 
% % Train a SVM model (fitcecoc() function is for multi-class problems)
% model_svm = fitcecoc(data_train_sc,label_train);
% 
% % Performs cross-validation to tune the parameters: crossval() function
% model_svm_cv = crossval(model_svm);
% 
% % Classifying entire image
% class_svm = predict(model_svm_cv.Trained{1}, data_sc);
% 
% %% Compute accuracy measures
% % Run the trained classifier on the validation set
% class_gml_valid = classify(data_valid_sc, data_train_sc, label_train, 'linear');
% class_knn_valid = predict(model_knn,data_valid_sc);
% class_svm_valid = predict(model_svm_cv.Trained{1}, data_valid_sc);
% 
% % Get the Confusion tables
% CT_gml = confusionmat(label_valid, class_gml_valid); % build confusion matrix
% CT_knn = confusionmat(label_valid, class_knn_valid); % build confusion matrix
% CT_svm = confusionmat(label_valid, class_svm_valid); % build confusion matrix
% 
% % Get OVerall Accuracies
% OA_gml = trace(CT_gml)/sum(CT_gml(:));
% OA_knn = trace(CT_knn)/sum(CT_knn(:));
% OA_svm = trace(CT_svm)/sum(CT_svm(:));
% 
% % Get Kappa statistics
% CT_gml_percent=CT_gml./sum(sum(CT_gml));
% EA_gml = sum(sum(CT_gml_percent,1)*sum(CT_gml_percent,2));
% Ka_gml= (OA_gml - EA_gml)/(1-EA_gml);
% 
% CT_knn_percent=CT_knn./sum(sum(CT_knn));
% EA_knn = sum(sum(CT_knn_percent,1)*sum(CT_knn_percent,2));
% Ka_knn= (OA_knn - EA_knn)/(1-EA_knn);
% 
% CT_svm_percent=CT_svm./sum(sum(CT_svm));
% EA_svm = sum(sum(CT_svm_percent,1)*sum(CT_svm_percent,2));
% Ka_svm= (OA_svm - EA_svm)/(1-EA_svm);
% 
% 
% %% Visualizing classification map
% figure
% subplot(131);
% imagesc(label2rgb(reshape(class_gml,size(img,1),size(img,2)),'jet'))
% title(['GML classification (OA=',num2str(OA_gml),', kappa=',num2str(Ka_gml),')']);
% axis equal tight
% xlabel('x')
% ylabel('y')
% 
% subplot(132);
% imagesc(label2rgb(reshape(class_knn,size(img,1),size(img,2)),'jet'))
% title(['k-NN classification k=',num2str(k_knn),', (OA=',num2str(OA_knn),', kappa=',num2str(Ka_knn),')']);
% axis equal tight
% xlabel('x')
% ylabel('y')
% 
% subplot(133);
% imagesc(label2rgb(reshape(class_svm,size(img,1),size(img,2)),'jet'))
% title(['SVM classification (OA=',num2str(OA_svm),', kappa=',num2str(Ka_svm),')']);
% axis equal tight
% xlabel('x')
% ylabel('y')
% 
% % You can re-run the code after removing certain columns of "data_stats"
% % matrix, allowing you to test the different features and their impact on
% % the classification

end


