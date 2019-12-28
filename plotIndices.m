function plotIndices(images, REFMAT)
% This function plot the differents indices for allimagent

    p = 1;  % initialization for subplot
    
    % Loop for every date
    for t = 1:length(images)
         
        figure(t)
        hold on 
        
        subplot(1,3,p)
        mapshow(images(t).RGB, REFMAT(t).B02, 'DisplayType', 'image')
        title([' RGB image at the period of ', images(t).date])
        p = p + 1;
        
        subplot(1,3,p)
        mapshow(images(t).NDVI, REFMAT(t).B02, 'DisplayType', 'image')
        title([' NDVI at the period of ', images(t).date])
        p = p + 1;
        
        subplot(1,3,p)
        mapshow(images(t).NDMI, REFMAT(t).B02, 'DisplayType', 'image')
        title([' NDMI at the period of ', images(t).date])        
        p = 1;
        
        hold off
        
    end

end 