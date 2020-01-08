function images = maskImages(images, shapefile) 

%==========================================================================
%% Mask
%==========================================================================
    % Get image info:
    R = geotiffinfo('./Data/2018-03-12/2018-03-12, Sentinel-2A L1C, B03.tiff');

    % Get x,y locations of pixels:
    [x,y] = pixcenters(R);
    % Convert x,y arrays to grid:
    [X,Y] = meshgrid(x,y);

    % Remove trailing nan from shapefile
    
    rx = shapefile.X(1:end-1);
    ry = shapefile.Y(1:end-1);
    mask = inpolygon(X,Y,rx,ry);
    
    % Get pixels from each class mask (polygons)
    
    %Extraction of all field names 
    fn = fieldnames(images); 

    % Loop for every "time"
for t = 1:length(images) 
    % Loop for bands (the first field is the date)

    for b = 2:numel(fn)  
        images(t).(fn{b}) = images(t).(fn{b})(mask==1);
    end

end 
    