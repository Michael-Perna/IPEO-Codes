function [] = Histogram_matching(bands)
% This function does a histogram matching 
% The 2018 image is used as the reference histogram 

edit=1;                 %if "edit"=0 no figures
                        %if "edit"=1 show figures

bands_ref = bands(1);
                
fn = fieldnames(bands);
for t = 2:length(bands) 
    for b = 2:numel(fn) %Loop for every band 
        img_ref = bands_ref.(fn{b}); %reference image
        img_new = bands(t).(fn{b});  %new image that will get equalized 
        
        % Compute the histogram and CDF of the reference 
        [counts_ref,x] = imhist(img_ref,65535); 
        cdf_ref = cumsum(counts_ref,1) / sum(counts_ref,1);
        
        % plot the CDF function of the reference
        if edit
            figure
            plot(cdf_ref)
            xlabel('Graylevel values')
            ylabel('CDF')
        end 
        
        % Compute the histogram and CDF of the image to be equalized  
        [counts_new,x] = imhist(img_new,65535); 
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

        % Display equalized image
        if edit
            figure
            subplot(1,2,1)
            mapshow(new, refmat)
            axis equal tight
            xlabel('col')
            ylabel('row')
            title('2019')
            subplot(1,2,2)
            mapshow(new_matched, refmat)
            axis equal tight
            xlabel('col')
            ylabel('row')
            title('2019 matched to 2018 equalized')
        end 
        
    end 
end
                        
end 