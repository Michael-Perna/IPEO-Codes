function plotIndices(images)
% This function plot the differents indices for allimagent

    p = 1;  % initialization for subplot
    
    % Loop for every date
    for t = 1:length(images)
         
        figure(t)
        hold on 
        
%         subplot(1,3,p)
%         H = imshow(images(t).RGB, 'InitialMagnification', 10000);
%         set(H, 'AlphaData', ~isnan(images(t).RGB));
%         title([' RGB image at the period of ', images(t).date])
%         p = p + 1;
        
        subplot(1,2,p)
        H = imshow(images(t).NDVI, 'InitialMagnification', 10000);
        set(H, 'AlphaData', ~isnan(images(t).NDVI));
        title([' NDVI at the period of ', images(t).date])
        p = p + 1;
        
        subplot(1,2,p)
        H = imshow(images(t).NDMI, 'InitialMagnification', 10000 );
        set(H, 'AlphaData', ~isnan(images(t).NDMI));
        title([' NDMI at the period of ', images(t).date])        
        p = 1;
        
        hold off
        
    end

end 