function [x, y] = intersect(line1, line2)

    %fit linear
    p1 = polyfit(line1(:, 1), line1(:, 2), 1);
    p2 = polyfit(line2(:, 1), line2(:, 2), 1);

    %calculate intersection
    x = fzero(@(x) polyval(p1 - p2, x), 3);
    y = polyval(p1, x);

end