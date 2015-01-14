function out = residuals_gauss(p, x)	
	mu = p(1);
    sigma =  p(2);
	out = normcdf(x, mu, sigma);
end