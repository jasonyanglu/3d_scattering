% MY_GAUSSIAN_3D computes a Gaussian function.
%
% Usage
%    gau = MY_GAUSSIAN_3D(N, M, K, sigma, precision, offset)
% 
% Input
%    N (numeric): width of the filter matrix
%    M (numeric): height of the filter matrix
%	 sigma (numeric): standard deviation of the Gaussian
%	 precision (string): 'single' or 'double'
%	 offset (numeric): 3-by-1 Vvector index of the row and column of the
%       center of the filter (if offset is [0,0,0] the filter is centered in
%       [1,1,1])
%
% Output
%    gau (numeric): N-by-M-by-K Gaussian function
%
% Description
%    Computes a Gaussian centered in offset and of standard deviation
%    sigma.

function gau = my_gaussian_3d(N, M, K, sigma, precision, offset)
    if ~exist('precision', 'var')
		precision = 'single';
	end

    if (~exist('offset', 'var'))
		offset = [floor(N/2), floor(M/2), floor(K/2)];
	end
	
	[x , y , z] = meshgrid(1:M, 1:N ,1:K);

	x = x - offset(2) - 1;
	y = y - offset(1) - 1;
    z = z - offset(3) - 1;
	
	gau = 1/(2*pi*sigma^2) * exp( -(x.^2+y.^2+z.^2)./(2*sigma^2) );
	
	if (strcmp(precision, 'single'))
		gau = single(gau);
	end
end
