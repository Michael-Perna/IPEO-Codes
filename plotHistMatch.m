function plotHistMatch(cdf_ref, cdf, images, images_new, REFMAT,  band)


    % plot the CDF function of the reference
    
        figure
        subplot(1,2,1)
        plot(cdf_ref.(band))
        title('CDF of reference')
        xlabel('Graylevel values')
        ylabel('CDF')


    % plot the CDF function of the image to be equalized
   
        subplot(1,2,2)
        plot(cdf.(band))
        title(['CDF of the image to be matched of the band ', band])
        xlabel('Graylevel values')
        ylabel('CDF')
 

    % Display equalized image
    
        figure
        subplot(1,2,1)
        mapshow(images(1).(band), REFMAT(1).(band))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title(['Band ', band, ' of reference'])
        
        subplot(1,2,2)
        mapshow(images_new(2).(band), REFMAT(2).(band))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title([' Band ', band, ' after histogram matching '])        
        
        
        figure
        subplot(1,2,1)
        mapshow(images(2).(band), REFMAT(2).(band))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title([' Band ', band, ' before histogram matching '])
        
        subplot(1,2,2)
        mapshow(images_new(2).(band), REFMAT(2).(band))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title([' Band ', band, ' after histogram matching '])   
        


    end  