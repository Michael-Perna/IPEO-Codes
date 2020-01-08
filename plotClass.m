function plotClass(class_svm, img)

%==========================================================================
%% Visualizing classification map
%==========================================================================
    figure
    imagesc(label2rgb(reshape(class_svm,size(img,1),size(img,2)),'jet'))
    title('SVM classification ');
    axis equal tight
    xlabel('x')
    ylabel('y')

end
