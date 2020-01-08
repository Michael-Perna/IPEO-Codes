% Exercise 4B - Supervised classification
% Version: October 31, 2017
% Author(s): Matthew Parkan, Pinar Akyazi, Frank de Morsier
function [ texture ] = texture_analysis(img, time)

%==========================================================================
% 1st order statistics: standard deviation and range min,max
%==========================================================================
    % Define a window size
    winSize = 3;
    % Compute standard dev and range on the red band
    Im_std = stdfilt(img, true(winSize));
    Im_rg = rangefilt(img(~isnan(img)), true(winSize));



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
    delete(gcp) % stop any parallel pool started
    parpool % start parallel pool
    parfor jj = 1:size(Im_p,2) % you can use parfor for parallel computations
    
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

%==========================================================================
%% Output
%==========================================================================
    texture(time).std = Im_std;
    texture(time).rg = Im_rg;
    texture(time).contrast = Im_contrast;
    texture(time).corr = Im_corr;
    texture(time).energy = Im_energy;
    texture(time).homogen = Im_homogen;
    texture(time).entropy = Im_entropy;
    texture(time).winSize = winSize;



end


