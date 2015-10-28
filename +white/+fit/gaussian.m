function [params, too_short] = gaussian(results, nrepeats, invert)

import white.*

if nargin < 2
  nrepeats = 10;
end

angles = results(:, 5);
unique_angles = unique(angles);

too_long = zeros(length(unique_angles), 1);
for i=1:length(angles)
    
    trial_response = results(i, 1);
    angle = angles(i);
    ind = find(unique_angles == angle);
    too_long(ind) = too_long(ind) + trial_response;

end

too_short = nrepeats - too_long;
too_short = too_short / nrepeats;

guess = [mean(unique_angles), std(unique_angles)];
if invert
    params = lsqcurvefit(@fit.invert_residuals_gauss, guess, unique_angles, ...
        too_short);
else
    params = lsqcurvefit(@fit.residuals_gauss, guess, unique_angles, too_short);
end

end