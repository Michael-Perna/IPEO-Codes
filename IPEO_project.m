% IPEO Project (Autumn 2019) 
clc
clear 
close all



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

