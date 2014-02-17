function [img] = gen_image_mat(annulus)

import gen.imcircle

if annulus
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
else
    radius = 88; % 2 deg of visual angle.
    img = zeros(radius * 4, radius * 4, 3);
    ind = size(img, 1) / 2 - (radius / 2); % index to center circle
    for k=1:3
        img(ind+1:end-ind, ind+1:end-ind, k) = imcircle(radius);
    end
end
