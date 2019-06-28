% MORLET_2D_NODC computes the 2-D elliptic Morlet filter given a set of 
%    parameters in Fourier domain
%
% Usage
%    gab = MORLET_2D_NODC(N, M, sigma, slant, xi, theta, offset)
%
% Input
%    N (numeric): Width of the filter.
%    M (numeric): Height of the filter.
%    sigma (numeric): Standard deviation of the envelope.
%    slant (numeric): Eccentricity of the elliptic envelope.
%       (the smaller slant, the larger angular resolution).
%    xi (numeric): The frequency peak.
%    theta (numeric): Orientation in radians of the filter.
%    offset (numeric, optional): 2-D vector reprensting the offset location 
%       (default [0 0]).
% 
% Output
%    gab (numeric): N-by-M matrix representing the gabor filter in spatial
%       domain.
%
% Description
%    Compute a Morlet wavelet in Fourier domain. 
%
%    Morlet wavelets have a 0 DC component.
%
% See also
%    GABOR_2D, MORLET_2D_PYRAMID

function gab = my_morlet_3d_noDC(N, M, K, sigma, slant, xi, theta, offset)
	
	if ~exist('offset','var')
		offset = [0, 0, 0];
	end
	[x , y , z] = meshgrid(1:M,1:N,1:K);
	x = x - ceil(M/2) - 1;
	y = y - ceil(N/2) - 1;
    z = z - ceil(K/3) - 1;
	x = x - offset(1);
	y = y - offset(2);
    z = z - offset(3);
	Rth = my_rotation_matrix_3d(theta);
	A = Rth \ [1/sigma^2 0 0;0 slant(2)^2/sigma^2 0 ; 0 0 slant(1)^2/sigma^2] * Rth;
    x1 = A(1,1)*x + A(1,2)*y + A(1,3)*z;
    y1 = A(2,1)*x + A(2,2)*y + A(2,3)*z;
    z1 = A(3,1)*x + A(3,2)*y + A(3,3)*z;
    
	s = x.* x1 + y.*y1 + z.*z1;
	
	%normalize sucht that the maximum of fourier modulus is 1
	
	gaussian_envelope = exp(-s/2);
	oscilating_part = gaussian_envelope .* exp(1i*(x*xi*Rth(1,1) + y*xi*Rth(1,2) + z*xi*Rth(1,3)));
	K = sum(oscilating_part(:)) ./ sum(gaussian_envelope(:));
	gabc = oscilating_part - K.*gaussian_envelope;
	
	gab=1/(2*pi*sigma^2/(slant(1)*slant(2))^2)*fftshift(gabc);
	
end
