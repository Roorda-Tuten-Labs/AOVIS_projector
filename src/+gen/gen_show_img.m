function [showimg] = gen_show_img(img, color, params)

showimg = zeros(size(img));
[h, ~, ~] = size(showimg);
c = h / 2;

for k = 1:3

    % color
    showimg(:, :, k) = color(k) * img(:, :, k);
    % fixation
    if strcmp(params.stimulus_shape, 'annulus')
        % center of 6 deg annulus, i.e. 3 deg in each direction.
        showimg(c-1:c+1, c-1:c+1, k) = 0.5 * 0;
    else
        % 3 degs from edge of 2 deg circle
        showimg(c:c+2, c+250:c+252, k) = 0.5 * 255;
    end
end