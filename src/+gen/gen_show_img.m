function [showimg] = gen_show_img(img, color, params)

showimg = zeros(size(img));
[h, ~, ~] = size(showimg);
center = (h / 2);
x_loc = center + params.fixation_offset_x;
y_loc = center + params.fixation_offset_y;

for k = 1:3

    % color
    showimg(:, :, k) = color(k) * img(:, :, k);
    % fixation
    if strcmp(params.stimulus_shape, 'annulus')
        % center of 6 deg annulus, i.e. 3 deg in each direction.
        showimg(center-1:center+1, center-1:center+1, k) = 0.5 * 0;
    else
        % 3 degs from edge of 2 deg circle
        showimg(y_loc:y_loc+5, x_loc:x_loc+5, k) = 0.65 * 255;
    end
end