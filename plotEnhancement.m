function plotEnhancement(images_old, images_new, time, band)


    figure
    subplot(1,2,1)
    imshow(images_old(time).(band))
    axis equal tight
    title(['Band ', band, ' before Enhancement'])
    
    subplot(1,2,2)
    imshow(images_new(time).(band))
    axis equal tight
    title(['Band ', band, ' after Enhancement'])
    
end