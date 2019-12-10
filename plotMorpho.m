function plotMorpho(dilation, closing, band, REFMAT, time)  
    
    figure()
    subplot(1,2,1)
    mapshow(dilation(time).(band), REFMAT(time).(band));
    xlabel('easting [m]')
    ylabel('northing [m]')
    title(['Morphological erosion ', band]);
    
    subplot(1,2,2)
    mapshow(closing(time).(band), REFMAT(time).(band));
    xlabel('easting [m]')
    ylabel('northing [m]')
    title(['Morphological cloosing ', band]);

    end