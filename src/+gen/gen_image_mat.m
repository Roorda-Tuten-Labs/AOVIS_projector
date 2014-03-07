function [img] = gen_image_mat(params)

import gen.imcircle

shape = params.stimulus_shape;

mid_width = floor(params.pixel_width / 2) + params.img_offset_width;
mid_height = floor(params.pixel_height / 2) + params.img_offset_height;

img = zeros(params.pixel_height, params.pixel_width, 3);

if strcmp(shape, 'annulus')
    % 20 px / mm, 25 cm viewing distance = 2 deg of vis angle.
    radius = params.img_width - 50;
    radius2 = radius + 124;
    img2 = zeros(radius2, radius2, 3);
    img1 = zeros(radius2, radius2, 3);
    ind = ceil((radius2 - radius) / 2);
    %disp(ind)
    for k=1:3
        %disp(size(img1(ind+1:end-ind, ind+1:end-ind, k))); disp(size(imcircle(radius)));
        img1(ind+1:end-ind, ind+1:end-ind, k) = imcircle(radius);
        img2(:, :, k) = imcircle(radius2);
    end
    wid = ceil(radius2 / 2);
    hei = ceil(radius2 / 2);
    img0 = img2 - img1;

elseif strcmp(shape, 'circle')
    
    radius = params.img_width;
    img0 = zeros(radius, radius, 3);
    ind = size(img0, 1) / 2 - (radius / 2); % index to center circle
    for k=1:3
        img0(ind+1:end-ind, ind+1:end-ind, k) = imcircle(radius);
    end
    wid = ceil(radius / 2);
    hei = ceil(radius / 2);

elseif strcmp(shape, 'rectangle')    
    wid = ceil(params.img_width / 2);
    hei = ceil(params.img_height / 2);
    img0 = ones(wid * 2, hei * 2, 3); 
    
end

% --- place the annulus in the center of the image
img(mid_height - wid : mid_height + wid - 1, mid_width - hei : ...
    mid_width + hei - 1, :) = img0;

end
