% IMAGE PROCESSING FOR EARTH PROJECT, November 2019
% Project: Palm Oil Plantation detection in Kalimatan Region 
% Written by Leona Repnik & Michael Perna



directory = './Data';

bands = uploadTiff(directory);
%%
img = trueColor(bands);

figure
mapshow(img(1).RGB, 'DisplayType', 'image')
axis equal tight
title('True-color (RGB)')
print('True-color', '-dpng')

Au revoir 