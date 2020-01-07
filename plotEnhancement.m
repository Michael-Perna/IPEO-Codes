function plotEnhancement(images_old, images_new, time, band)


    figure
    subplot(1,2,1)
    H = imshow(images_old(time).(band), 'InitialMagnification', 10000);
    set(H, 'AlphaData', ~isnan(images_old(time).(band)))
    colorbar
    axis equal tight
    title(['Band ', band, ' before Enhancement'])
    
    subplot(1,2,2)
    H = imshow(images_new(time).(band), 'InitialMagnification', 10000);
    set(H, 'AlphaData', ~isnan(images_new(time).(band)))
    colorbar
    axis equal tight
    title(['Band ', band, ' after Enhancement'])
    
    % histogram of images
    figure 
    subplot(2,1,1)
    imhist(images_old(time).(band));
    title(['Histogram of ', band, ' before Enhancement'])
    
    subplot(2,1,2)
    imhist(images_new(time).(band));
    title(['Histogram of ', band, ' after Enhancement'])
    
end