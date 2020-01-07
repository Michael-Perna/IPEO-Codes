function [ images, CMAP, REFMAT, BBOX ] = uploadTiff(directory)
% This function upload all .TIFF image with the matlab function geotiffread()  
% present in the given "directory" path. Additionaly it converted the images
% it into double precision. Moreover it gives all CMPA, REFMAT and BBOX,
% please refer to documentation of geotiffread. ("help geotiffread").
%
% The folder should be structure as follows:
%       DIRECTORY: -data/
%                   |__
%     SUBDFOLDERS:      15-02-2019      16-02-2019
% DIFFERENTS BANDS:           |__ 2018-03-12, Sentinel-2A L1C, B03.tiff
%
%
% /!\ this code work properly for the images names downloded from EO XX
%     the last three digit of the bands should given the bands name, as 
%     B04, otherwise this code is still not adapted to encode the bands
%     with the rigth name. 

subfolders = dir(directory);    % List all files and folders in directory 
subfolders(1:2) = [];           % delete the folders '.' and '..'

% Loop for all date directory
for n = 1:length(subfolders)    % For all documents in directory
    if subfolders(n).isdir      % Basicly Ingore the .gejson file (only directory counts)
        abs_path = strcat(subfolders(n).folder,'/', subfolders(n).name);
        files = dir(abs_path);  % All geotiff image of a date should be here
        
        % Gives the date for bands from the same date
        images(n).date = subfolders(n).name; 
        
        % loop over al tiff images
        for k = 1:length(files)
            if ~files(k).isdir
                
                % path to single .tiff image
                abs_path = strcat(files(k).folder,'/', files(k).name);
                
                % Name of the band (last three digit of the path)
                BandsName = files(k).name(end-7:end-5);
                
                % read .TIFF and add bands to the structure bands
                [ images(n).(BandsName), CMAP(n).(BandsName),...
                  REFMAT(n).(BandsName), BBOX(n).(BandsName) ] ...
                    = geotiffread(abs_path); 
                
                % Convert image to double precision
                images(n).(BandsName) = im2double(images(n).(BandsName));
            end
        end        
    end
end

%=========================================================================
%% Remotion of the black borders
%=========================================================================

fn = fieldnames(images); 

% Loop for every no-reference images
for t = 1:length(images) 
    % Loop for every no-reference 
    for b = 2:numel(fn) 
        show = 0;
        images(t).(fn{b}) = remove_borders(images(t).(fn{b}), show);
    end
end
end