% IPEO Project (Autumn 2019) 
clc
clear 
close all

%% Band information (sentinel-2)
% B2: blue (10m) 490nm 
% B3: green (10m) 560nm 
% B4: red (10m) 665 nm
% B5: VRE (vegetation red edge) (20m)705nm 
% B6: VRE (20m) 740nm 
% B7: VRE (20m) 783nm 
% B8: NIR (10m) 842nm 
% B8A: VRE (20m) 865 nm
% B11: SWIR (20m) 1610 nm
% B12: SWIR (20m) 2190 nm 

%% read images 

%band 2
filepath = 'Imagery/New/2018-03-12, Sentinel-2A L1C, B02.tiff';
[ima_2, cmap1, refmat1, bbox1] = geotiffread(filepath);
info1 = geotiffinfo(filepath);
refmat = info1.RefMatrix;
% To double
ima_2 = im2double(ima_2);

% band 3
filepath = 'Imagery/New/2018-03-12, Sentinel-2A L1C, B03.tiff';
[ima_3, cmap1, refmat1, bbox1] = geotiffread(filepath);
info1 = geotiffinfo(filepath);
% To double
ima_3 = im2double(ima_3);

%band 4
filepath = 'Imagery/New/2018-03-12, Sentinel-2A L1C, B04.tiff';
[ima_4, cmap1, refmat1, bbox1] = geotiffread(filepath);
info1 = geotiffinfo(filepath);
% To double
ima_4 = im2double(ima_4);

%band 8 
filepath = 'Imagery/New/2018-03-12, Sentinel-2A L1C, B08.tiff';
[ima_8, cmap1, refmat1, bbox1] = geotiffread(filepath);
info1 = geotiffinfo(filepath);
% To double
ima_8 = im2double(ima_8);

%band 11 
filepath = 'Imagery/New/2018-03-12, Sentinel-2A L1C, B11.tiff';
[ima_11, cmap1, refmat1, bbox1] = geotiffread(filepath);
info1 = geotiffinfo(filepath);
% To double
ima_11 = im2double(ima_11);

%band 12 
filepath = 'Imagery/New/2018-03-12, Sentinel-2A L1C, B12.tiff';
[ima_12, cmap1, refmat1, bbox1] = geotiffread(filepath);
info1 = geotiffinfo(filepath);
% To double
ima_12 = im2double(ima_12);

%% To upload (using the function) 
ima_12 = bands(1).B12;
ima_12 = im2double(ima_12); %to double (potentially add to 'uploadTiff.m')


%% True color image
Im_rgb(:,:,1) = (ima_4);
Im_rgb(:,:,2) = (ima_3);
Im_rgb(:,:,3) = (ima_2);

% Show the image
figure
mapshow(Im_rgb, refmat1, 'DisplayType', 'image')
axis equal tight
title('True-color (RGB)')
print('True-color', '-dpng')

%% NDVI 

% NDVI (NIR - R) / (NIR + R)
Im_ndvi = (ima_8 - ima_4 + eps)./(ima_8 + ima_4 + eps);

% Show the image
figure
mapshow(Im_ndvi, refmat1, 'DisplayType', 'image')
axis equal tight
title('NDVI')
print('NDVI', '-dpng')

%% NDMI 

% (NIR - SWIR) / (NIR + SWIR)
Im_ndmi_11 = (ima_8 - ima_11)./(ima_8 + ima_11);

% Show the image
figure
mapshow(Im_ndmi_11, refmat1, 'DisplayType', 'image')
axis equal tight
title('NDMI with B11')
print('True-color', '-dpng')
print('NDMI (with SWIR B11)', '-dpng')

% (NIR - SWIR) / (NIR + SWIR)
Im_ndmi_12 = (ima_8 - ima_12)./(ima_8 + ima_12);

% Show the image
figure
mapshow(Im_ndmi_12, refmat1, 'DisplayType', 'image')
axis equal tight
title('NDMI with B12')
print('NDMI (with SWIR B12)', '-dpng')

