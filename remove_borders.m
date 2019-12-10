function image_without_borders = remove_borders(image, show)
% DESING PORJECT, Spring 2018
% Project: Semantic Segmentation
% Written by Laura Ducret (Bissel) &  adapted by Michael Perna


% The function find the black borders due to alignment and create a mask on
% the segmented image.
% 
% INPUT: 
% 'show' = 1    allows to visualise the filtered mask, otherwise 0
%  image_type = 'grey' or 'RGB'  image_type of the segmented image


image = double(image);
colors = 1;

% find the black pixels in image_alignement => mask
mask = ismember(image, colors);

% Filter : remove the isolated points -> clean the mask
mask_filt = bwareaopen(mask, 100000);

% Visula chek if needed
if show
    figure
    subplot(1,2,1)
    spy(mask)
    subplot(1,2,2)
    spy(mask_filt)
end

% Remove the borders in image_segmented
image(image.*mask_filt == 1) = NaN;
image_without_borders = image;

end