function [] = Histogram_matching(bands, edit, REFMAT)
% This function does a histogram matching 
% The 2018 image is used as the reference histogram 

%NEED TO CHANGE CODE TO ONLY INCLUDE PIXELS THAT DO NOT HAVE A VALUE OF 1
%(THE BORDERS) SO USE ~ SYMBOL (we did this in the classification exercise)
%--> so it only uses the pixels we want to include (not the 1s)

% edit                 %if "edit"=0 no figures
                       %if "edit"=1 show figures


                
fn = fieldnames(bands); 

%=========================================================================
%% Remotion of the black borders
%=========================================================================

% Loop for every no-reference images
for t = 1:length(bands) 
    % Loop for every no-reference 
    for b = 2:numel(fn) 
        show = 0;
        bands(t).(fn{b}) = remove_borders(bands(t).(fn{b}), show);
    end
end

%=========================================================================
%% Histogram Matching
%=========================================================================
bands_ref = bands(1);

% Loop for every no-reference images
for t = 2:length(bands) 
    % Loop for every no-reference 
    for b = 2:numel(fn)  
        img_ref = bands_ref.(fn{b}); % reference image
        img_new = bands(t).(fn{b});  % new image that will get equalized 
        
        % Compute the histogram and CDF of the reference 
        [counts_ref,~] = imhist(img_ref(~isnan(img_ref)),65535); 
        cdf_ref = cumsum(counts_ref,1) / sum(counts_ref,1);
        
        % plot the CDF function of the reference
        if edit
            figure
            plot(cdf_ref)
            xlabel('Graylevel values')
            ylabel('CDF')
        end 
        
        % Compute the histogram and CDF of the image to be equalized  
        [counts_new,~] = imhist(img_new(~isnan(img_new)),65535); 
        cdf_new = cumsum(counts_new,1) / sum(counts_new,1);
        
        % plot the CDF function of the image to be equalized 
        if edit
            figure
            plot(cdf_new)
            xlabel('Graylevel values')
            ylabel('CDF')
        end 

        % Build a look-up table between the two CDFs using interp1() function. 
        % /!\ careful you need to first remove duplicates in the CDF in interp1 function
        [cdf_ref_unique,id_unique] = unique(cdf_ref);
        LUT = interp1(cdf_ref_unique,id_unique,cdf_new(id_unique)); %compares reference image with equalized image
        LUT2 = interp1(id_unique, LUT, 0:65535); %transforms it into 16-bit; id_unique is x and LUT is y 

        % Apply the LUT to the new image
        % Be careful with the image data format range (8-bit = 256 or 16 bit = 65536)
        new = uint8(img_new / 65535);
        new_matched = uint8(LUT2(new(:)+1));
        new_matched = reshape(new_matched, size(new,1),size(new,2));


        
    end 
end
                     % Display equalized image
        if edit
            figure
            subplot(1,2,1)
            mapshow(new, REFMAT(t).(fn{b}))
            axis equal tight
            xlabel('col')
            ylabel('row')
            title('2019')
            
            subplot(1,2,2)
            mapshow(new_matched, REFMAT(t).(fn{b}))
            axis equal tight
            xlabel('col')
            ylabel('row')
            title('2019 matched to 2018 equalized')
        end            
end 