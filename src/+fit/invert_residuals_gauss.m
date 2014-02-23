function out = invert_residuals_gauss(p, x)	
	mu = p(1);
    sigma =  p(2);
	out = 1 - normcdf(x, mu, sigma);
end