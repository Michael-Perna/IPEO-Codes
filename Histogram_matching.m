function [cdf_new, cdf_ref, images] = Histogram_matching(images, REFMAT)
% This function does a histogram matching 
% The 2018 image is used as the reference histogram 

%NEED TO CHANGE CODE TO ONLY INCLUDE PIXELS THAT DO NOT HAVE A VALUE OF 1
%(THE BORDERS) SO USE ~ SYMBOL (we did this in the classification exercise)
%--> so it only uses the pixels we want to include (not the 1s)

% edit                 %if "edit"=0 no figures
                       %if "edit"=1 show figures


                
fn = fieldnames(images); 

%=========================================================================
%% Remotion of the black borders
%=========================================================================

% Loop for every no-reference images
for t = 1:length(images) 
    % Loop for every no-reference 
    for b = 2:numel(fn) 
        show = 0;
        images(t).(fn{b}) = remove_borders(images(t).(fn{b}), show);
    end
end

%=========================================================================
%% Histogram Matching
%=========================================================================
bands_ref = images(1);

% Loop for every no-reference images
for t = 2:length(images) 
    % Loop for every no-reference 
    for b = 2:numel(fn)  
        img_ref = bands_ref.(fn{b}); % reference image
        img_new(t-1).(fn{b}) = images(t).(fn{b});  % new image that will get equalized 
        
        % Compute the histogram and CDF of the reference 
        [counts_ref,~] = imhist(img_ref(~isnan(img_ref)),65535); 
        cdf_ref = cumsum(counts_ref,1) / sum(counts_ref,1);
        
        
        % Compute the histogram and CDF of the image to be equalized  
        [counts_new,~] = imhist(img_new(t-1).(fn{b})(~isnan(img_new(t-1).(fn{b}))),65535); 
        cdf_new(t-1).(fn{b}) = cumsum(counts_new,1) / sum(counts_new,1);
        

        % Build a look-up table between the two CDFs using interp1() function. 
        % /!\ careful you need to first remove duplicates in the CDF in interp1 function
        [cdf_ref_unique,id_unique] = unique(cdf_ref);
        LUT = interp1(cdf_ref_unique,id_unique,cdf_new(t-1).(fn{b})(id_unique)); %compares reference image with equalized image
        LUT2 = interp1(id_unique, LUT, 0:65535); %transforms it into 16-bit; id_unique is x and LUT is y 

        % Apply the LUT to the new image
        % Be careful with the image data format range (8-bit = 256 or 16 bit = 65536)
        new = floor(img_new(t-1).(fn{b})(:)*65535);
        new_idx = ~isnan(new);
        new_match = new;
        new_match(new_idx) = uint16(LUT2(new(new_idx)  + 1));
        images(t-1).(fn{b}) = reshape(new_match, size(img_new(t-1).(fn{b}),1),size(img_new(t-1).(fn{b}),2));
        images(t-1).(fn{b}) = im2double(images(t-1).(fn{b})/65535);

        
    end 
end
          
end 