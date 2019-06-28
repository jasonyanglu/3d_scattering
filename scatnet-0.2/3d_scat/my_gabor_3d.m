% GABOR_2D computes the 2-D elliptic Gabor wavelet given a set of 
% parameters
%
% Usage
%    gab = GABOR_2D(N, M, sigma0, slant, xi, theta, offset, precision)
%
% Input
%    N (numeric): width of the filter
%    M (numeric): height of the filter
%    sigma0 (numeric): standard deviation of the envelope
%    slant (numeric): excentricity of the elliptic envelope
%            (the smaller slant, the larger angular resolution)
%    xi (numeric):  the frequency peak
%    theta (numeric): orientation in radians of the filter
%    offset (numeric): 2-D vector reprensting the offset location.
%    Optional
%    precision (string): precision of the computation. Optional
% 
% Output
%    gab(numeric) : N-by-M matrix representing the gabor filter in spatial
%    domain
%
% Description
%    Compute a Gabor wavelet. When used with xi = 0, and slant = 1, this 
%    implements a gaussian
%
%    Gabor wavelets have a non-negligeable DC component which is
%    removed for scattering computation. To avoid this problem, one can use
%    MORLET_2D_NODC.
%
% See also
%    MORLET_2D_NODC, MORLET_2D_PYRAMID

function gab = my_gabor_3d(N, M, K, sigma0, slant, xi, theta, offset, precision)
	
	if ~exist('offset','var')
		offset = [0,0,0];
	end
	if ~exist('precision', 'var')
		precision = 'double';
	end
	
	[x , y , z] = meshgrid(1:M,1:N,1:K);
	x = x - ceil(M/2) - 1;
	y = y - ceil(N/2) - 1;
    z = z - ceil(K/2) - 1;
	x = x - offset(1);
	y = y - offset(2);
    z = z - offset(3);
	Rth = my_rotation_matrix_3d(theta);
	A = Rth \ [1/sigma0^2 0 0;0 slant^2/sigma0^2 0 ; 0 0 1/sigma0^2] * Rth;
%     A = Rth;
    x1 = A(1,1)*x + A(1,2)*y + A(1,3)*z;
    y1 = A(2,1)*x + A(2,2)*y + A(2,3)*z;
    z1 = A(3,1)*x + A(3,2)*y + A(3,3)*z;
    
	s = x.* x1 + y.*y1 + z.*z1;
	% Normalization
	gabc = exp( - s/2 + 1i*(x*xi*Rth(1,1) + y*xi*Rth(1,2) + z*xi*Rth(1,3)));
	gab = 1/(2*pi*sigma0*sigma0/slant)*fftshift(gabc);
	
	if (strcmp(precision, 'single'))
		gab = single(gab);
	end
	
end
