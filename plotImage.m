function plotImage(images, time, band)

%fn = fieldnames(images_new); 

    
    % Display equalized image
    
        figure
        imshow(images(time).(band))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title(['Band ', band, ' of reference'])  
       
    end  