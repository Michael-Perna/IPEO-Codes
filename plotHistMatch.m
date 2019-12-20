function plotHistMatch(cdf_ref, cdf, images, images_new, REFMAT,  time, band)

fn = fieldnames(images_new); 

    % plot the CDF function of the reference
    
        figure
        subplot(1,2,1)
        plot(cdf_ref)
        title('CDF of reference')
        xlabel('Graylevel values')
        ylabel('CDF')


    % plot the CDF function of the image to be equalized
   
        subplot(1,2,2)
        plot(cdf(time).(band))
        title(['CDF of the image to be equalized of the band ', band])
        xlabel('Graylevel values')
        ylabel('CDF')
 

    % Display equalized image
    
        figure
        subplot(1,3,1)
        mapshow(images(1).(band), REFMAT(1).(band))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title(['Band ', band, ' of reference'])
        
                
        subplot(1,3,2)
        mapshow(images(time).(band), REFMAT(time).(band))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title([' Band ', band, ' before histogram matching '])

        subplot(1,3,3)
        mapshow(images_new(time).(band), REFMAT(time).(band))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title([' Band ', band, ' after histogram matching '])
    end  