function plotCut(images, time, band, limits)

%fn = fieldnames(images_new); 

    
    % Display equalized image
    
        figure
        imshow(images(time).(band))
        axis equal tight
        xlim( limits.x )
        ylim( limits.y )
        xlabel('col')
        ylabel('row')
        title(['Band ', band, ' of reference'])  
       
    end  