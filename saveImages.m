function saveImages(images, CMAP, REFMAT, class_svm, R, heigthWidth, svm_filename)

fn = fieldnames(images); 

cd 'results'       

%=========================================================================
%% save Classification
%=========================================================================
class_svm = label2rgb(reshape(class_svm, heigthWidth(1), heigthWidth(2)),'jet');
filename = strcat(svm_filename, '.tif');
imwrite( class_svm, filename, 'tiff');  
% geotiffwrite(filename, class_svm, R) 

%=========================================================================
%% save images
%=========================================================================

    % Loop for every no-reference images
    for t = 1:length(images) 
        % Loop for every no-reference 
        for b = 2:numel(fn)  
            filename = strcat(images(t).date, '_', fn{b}, '.tif');
            imwrite( images(t).(fn{b}), filename, 'tiff');  
%             geotiffwrite(filename, images(t).(fn{b}), CMAP(t).(fn{b}), REFMAT(t).(fn{b})) 
        end 
    end
    
    cd ..

end