function bands = uploadTiff(directory)
% This function upload all .TIFF image in the directory path

subfolders = dir(directory);    % List all files and folders in directory 
subfolders(1:2) = [];           % delete the folders '.' and '..'

% Loop for all date directory
for n = 1:length(subfolders)    % For all documents in directory
    if subfolders(n).isdir      % Basicly Ingore the .gejson file (only directory counts)
        abs_path = strcat(subfolders(n).folder,'/', subfolders(n).name);
        files = dir(abs_path);  % All geotiff image of a date should be here
        
        % Gives the date for bands from the same date
        bands(n).date = subfolders(n).name; 
        
        % loop over al tiff images
        for k = 1:length(files)
            if ~files(k).isdir
                
                % path to single .tiff image
                abs_path = strcat(files(k).folder,'/', files(k).name);
                
                % Name of the band (last three digit of the path)
                BandsName = files(k).name(end-7:end-5);
                
                % Add bands to the structure bands
                bands(n).(BandsName) = geotiffread(abs_path); 
                
            end
        end        
    end
end
end