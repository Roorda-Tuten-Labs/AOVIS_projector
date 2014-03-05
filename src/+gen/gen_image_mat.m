function [img] = gen_image_mat(params)

import gen.imcircle

shape = params.stimulus_shape;

mid_width = floor(params.pixel_width / 2) + params.img_offset_width;
mid_height = floor(params.pixel_height / 2) + params.img_offset_height;

if strcmp(shape, 'annulus')
    % 20 px / mm, 25 cm viewing distance = 2 deg of vis angle.
    radius = 264; % radius 3 deg, 6 deg diameter.
    radius2 = 342; % 1 deg wide annulus
    img2 = zeros(radius2, radius2, 3);
    img1 = zeros(radius2, radius2, 3);
    ind = (radius2 - radius) / 2;
    for k=1:3
        img1(ind+1:end-ind, ind+1:end-ind, k) = imcircle(radius);
        img2(:, :, k) = imcircle(radius2);
    end
    img = img2 - img1;
    
elseif strcmp(shape, 'circle')
    radius = 88; % 2 deg of visual angle.
    img = zeros(radius * 4, radius * 4, 3);
    ind = size(img, 1) / 2 - (radius / 2); % index to center circle
    for k=1:3
        img(ind+1:end-ind, ind+1:end-ind, k) = imcircle(radius);
    end
    
elseif strcmp(shape, 'rectangle')
    
    img = zeros(params.pixel_height, params.pixel_width, 3);
    
    wid = ceil(params.img_width / 2);
    hei = ceil(params.img_height / 2);
    
    img(mid_height - wid : mid_height + wid - 1, mid_width - hei : ...
        mid_width + hei - 1, :) = ones(wid * 2, hei * 2, 3);
    
end
