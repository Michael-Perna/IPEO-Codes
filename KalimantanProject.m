% IMAGE PROCESSING FOR EARTH PROJECT, November 2019
% Project: Palm Oil Plantation detection in Kalimatan Region 
% Written by Leona Repnik & Michael Perna

%% Set the data directory
directory = './Data';

%% Upload image 
% used double differences
[bands, ~, REFMAT, ~] = uploadTiff(directory);

%%
img = trueColor(bands);

Some changes test


