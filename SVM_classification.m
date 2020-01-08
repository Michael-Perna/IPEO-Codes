function [class_svm, accuracy] = SVM_classification(training, img) 
% Exercise 4B - Supervised classification
% Version: adapted version of the Exercice 4B October 31, 2017
% Author(s): Matthew Parkan, Pinar Akyazi, Frank de Morsier

%==========================================================================
%% INPUT
%==========================================================================
    model_svm_cv = training.model_svm_cv;
    dataMax = training.dataMax;
    dataMin = training.dataMin;
    label_valid = training.label_valid;
    data_valid_sc = training.data_valid_sc;
    
%==========================================================================
%% Classification
%==========================================================================
    % Reshape the data into a 2d matri
    data = reshape(img,size(img,1)*size(img,2),size(img,3));    
    
    % Rescale accordingly all image pixels
    % note: the parameters used on the training pixels are given as arguments in the
    % function to rescale accordingly the rest of the pixels
    typeNorm = 'minmax'; % use 'std' to rescale to a unit variance and zero mean
    data_sc = classificationScaling(double(data), dataMax, dataMin, typeNorm);

    % Classifying entire image
    class_svm = predict(model_svm_cv.Trained{1}, data_sc);

%==========================================================================
%% Compute accuracy measures
%==========================================================================

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
    

%==========================================================================
%% OUTPUt
%==========================================================================
    accuracy.CT_svm = CT_svm;
    accuracy.OA_svm = OA_svm;
    accuracy.Ka_svm = Ka_svm;