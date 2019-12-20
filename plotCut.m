function limits =  plotCut(images, time, band)

%fn = fieldnames(images_new); 

    
    % Display equalized image
    
        figure
        imshow(images(time).(band))
        axis equal tight
        xlim([ 1504, 2526 ])
        ylim([ 242, 2066 ])
        xlabel('col')
        ylabel('row')
        title(['Band ', band, ' of reference'])
        
        limits.x = [ 1504, 2526 ];
        limits.y = [ 242, 2066 ];
        
                
       
    end  