% Image processing for Earth Observation
% Largly inspired by Exercise 3A - Local enhancement
% Version: Ocotbre 2, 2019
% Author(s): Frank de Morsier, Matthew Parkan

function median_filter

%% Part 0: Let's apply some filters
hA = [0,-1,0;-1,4,-1;0,-1,0]
hB = [-10,-10,-10;-10,-10,-10;-10,-10,-10]
hC = [-1,2,-1;2,-4,2;-1,2,-1]
l8_mat_A = imfilter(l8_mat,hA);
l8_mat_B = imfilter(l8_mat,hB);
l8_mat_C = imfilter(l8_mat,hC);

%% plot outputs with map coordinate reference system
figure
subplot(1,3,1)
mapshow(imnorm(l8_mat_A(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Filter A - High pass')

% plot band 4 stretched by 1 std deviation
subplot(1,3,2)
mapshow(imnorm(l8_mat_B(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Filter B - Low pass (negative averaging)')

% plot band 4 stretched to 1% and 99% of CDF
subplot(1,3,3)
mapshow(imnorm(l8_mat_C(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Filter C - High pass')


%% Part 1: Low-pass filtering 
% Create the low-pass filters: 
sigma = 2
h3 = fspecial('gaussian', 3, sigma);
h5 = fspecial('gaussian', 5, sigma);
h7 = fspecial('gaussian', 7, sigma);
l8_mat_lp3 = imfilter(l8_mat,h3);
l8_mat_lp5 = imfilter(l8_mat,h5);
l8_mat_lp7 = imfilter(l8_mat,h7);

%% plot outputs with map coordinate reference system
figure
subplot(1,3,1)
mapshow(imnorm(l8_mat_lp3(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Low pass 3x3')

% plot band 4 stretched by 1 std deviation
subplot(1,3,2)
mapshow(imnorm(l8_mat_lp5(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Low pass 5x5')

% plot band 4 stretched to 1% and 99% of CDF
subplot(1,3,3)
mapshow(imnorm(l8_mat_lp7(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Low pass 7x7')


%% Part 2: High pass filtering
% Create the high-pass filters: 
sigma = 2
h3 = fspecial('log', 3, sigma);
h5 = fspecial('log', 5, sigma);
h7 = fspecial('log', 7, sigma);
l8_mat_hp3 = imfilter(l8_mat,h3);
l8_mat_hp5 = imfilter(l8_mat,h5);
l8_mat_hp7 = imfilter(l8_mat,h7);

%% plot outputs with map coordinate reference system
% Normalization for mapshow expecting [0,1]
figure
subplot(1,3,1)
mapshow(imnorm(l8_mat_hp3(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('High pass 3x3')

% plot band 4 stretched by 1 std deviation
subplot(1,3,2)
mapshow(imnorm(l8_mat_hp5(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('High pass 5x5')

% plot band 4 stretched to 1% and 99% of CDF
subplot(1,3,3)
mapshow(imnorm(l8_mat_hp7(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('High pass 7x7')


%% Part 3: Directional Sobel filtering
% Create the Sobel filter: 
hsobel = fspecial('sobel');
l8_mat_sobel = imfilter(l8_mat,hsobel);

% To detect in the other direction: transpose the filter
l8_mat_sobel_v = imfilter(l8_mat,hsobel');

% To combine directions: L2-norm of the two directions (use sqrt() and
% power())
l8_mat_sobel_iso = sqrt(power(l8_mat_sobel,2) + power(l8_mat_sobel_v,2));


%% plot outputs with map coordinate reference system
figure
subplot(1,3,1)
mapshow(imnorm(l8_mat_sobel(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Sobel Horizontal')

% plot band 4 stretched by 1 std deviation
subplot(1,3,2)
mapshow(imnorm(l8_mat_sobel_v(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Sobel Vertical')

% plot band 4 stretched to 1% and 99% of CDF
subplot(1,3,3)
mapshow(imnorm(l8_mat_sobel_iso(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Sobel isotropic')


%% Part 4: edge-preserving smoothing
l8_mat_gf = imguidedfilter(l8_mat);

%% Visualize the result
figure
subplot(121)
mapshow(imnorm(l8_mat(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Original image')
subplot(122)
mapshow(imnorm(l8_mat_gf(:,:,[4,3,2])), refmat)
axis equal tight
xlabel('easting [m]')
ylabel('northing [m]')
title('Anisotropic filtering')
