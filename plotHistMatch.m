function plotHistMatch(cdf_ref, cdf, images_ref, images, band)
%=========================================================================
%% Remotion of the black borders
%=========================================================================
                

    show = 0;
    images_ref(1).(band) = remove_borders(images_ref(1).(band), show);
    images_ref(2).(band) = remove_borders(images_ref(2).(band), show);
    images(1).(band) = remove_borders(images(1).(band), show);
    images(2).(band) = remove_borders(images(2).(band), show);
    
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
        H = imshow(images_ref(1).(band), 'InitialMagnification', 10000);
        set(H, 'AlphaData', ~isnan(images_ref(1).(band)))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title(['Band ', band, ' of reference'])
        
        subplot(1,2,2)
        H = imshow(images(2).(band), 'InitialMagnification', 10000);
        set(H, 'AlphaData', ~isnan(images(2).(band)))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title([' Band ', band, ' after histogram matching '])        
        
        
        figure
        subplot(1,2,1)
        H = imshow(images_ref(2).(band), 'InitialMagnification', 10000);
        set(H, 'AlphaData', ~isnan(images_ref(2).(band)))
        axis equal tight
        xlabel('col')
        ylabel('row')
        title([' Band ', band, ' before histogram matching '])
        
        subplot(1,2,2)
        H = imshow(images(2).(band), 'InitialMagnification', 10000);
        set(H, 'AlphaData', ~isnan(images(1).(band)));
        axis equal tight
        xlabel('col')
        ylabel('row')
        title([' Band ', band, ' after histogram matching '])   
        


    end  