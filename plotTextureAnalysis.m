function [] = plotTextureAnalysis(images, img, time)

%==========================================================================
%% Input 
%==========================================================================
    Im_std = images(time).std;
    Im_rg = images(time).rg;
    Im_contrast = images(time).contrast;
    Im_corr = images(time).corr;
    Im_energy = images(time).energy;
    Im_homogen = images(time).homogen;
    Im_entropy = images(time).entropy;
    winSize = images(time).winSize;

%==========================================================================
%% PLOT 1st order statistics: standard deviation and range min,max
%==========================================================================
 
    figure
    subplot(1,2,1);
    imagesc(Im_std); 
    axis equal tight
    title(['std ',int2str(winSize),'x',int2str(winSize)]);

    subplot(1,2,2);
    imagesc(Im_rg); 
    axis equal tight
    title(['range ',int2str(winSize),'x',int2str(winSize)]);

%==========================================================================
%% PLOT 2nd order statistics: co-occurence
%==========================================================================
    figure
    subplot(2,3,1);
    imshow(img);
    title('original band');

    subplot(2,3,2);
    imagesc(Im_contrast);
    title(['contrast ',int2str(winSize),'x',int2str(winSize)]);

    subplot(2,3,3);
    imagesc(Im_corr);
    title(['correlation',int2str(winSize),'x',int2str(winSize)]);

    subplot(2,3,4);
    imagesc(Im_energy);
    title(['energy',int2str(winSize),'x',int2str(winSize)]);

    subplot(2,3,5);
    imagesc(Im_homogen);
    title(['homogeneity',int2str(winSize),'x',int2str(winSize)]);

    subplot(2,3,6);
    imagesc(Im_entropy);
    title(['entropy',int2str(winSize),'x',int2str(winSize)]);
end