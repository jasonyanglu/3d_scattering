% MY_MORLET_3D_PYRAMID computes the 3-D elliptic Morlet filter given a set of 
%    parameters in spatial domain
%
% Usage
%    gab = MY_MORLET_3D_PYRAMID(N, M, K, sigma, slant, xi, theta, offset)
%
% Input
%    N (numeric): width of the filter
%    M (numeric): height of the filter
%    sigma (numeric): standard deviation of the envelope
%    slant (numeric): excentricity of the elliptic envelope
%            (the smaller slant, the larger angular resolution)
%    xi (numeric):  the frequency peak
%    theta (numeric): orientation in radians of the filter
%    offset (numeric): 3-by-1 Vvector index of the row and column of the
%       center of the filter (if offset is [0,0,0] the filter is centered in
%       [1,1,1])
%
% Output
%    gab (numeric): N-by-M-by-K matrix representing the gabor filter in spatial
%       domain.
%
% Description
%    Compute a Morlet wavelet in spatial domain. 
%
%    Morlet wavelets have a 0 DC component.
%
% See also
%    GABOR_2D, MORLET_2D_NODC


function gab = my_morlet_3d_pyramid(N, M, K, sigma, slant, xi, theta, offset)

	if ~exist('offset', 'var')
		offset = [floor(N/2), floor(M/2), floor(K/2)];
	end
	
	[x , y , z] = meshgrid(1:M, 1:N, 1:K);

	x = x - offset(2) - 1;
	y = y - offset(1) - 1;
    z = z - offset(3) - 1;
	
	Rth = my_rotation_matrix_3d(theta);

    A = Rth \ [1/sigma^2 0 0;0 slant(2)^2/sigma^2 0 ; 0 0 slant(1)^2/sigma^2] * Rth;
    
    
%     A = Rth;

    x1 = A(1,1)*x + A(1,2)*y + A(1,3)*z;
    y1 = A(2,1)*x + A(2,2)*y + A(2,3)*z;
    z1 = A(3,1)*x + A(3,2)*y + A(3,3)*z;
    
	s = x.* x1 + y.*y1 + z.*z1;
    
	%normalize sucht that the maximum of fourier modulus is 1
	gaussian_envelope = exp( - s/2);
	oscilating_part = gaussian_envelope .* exp(1i*(x*xi*Rth(1,1) + y*xi*Rth(1,2) + z*xi*Rth(1,3)));
	K = sum(oscilating_part(:)) ./ sum(gaussian_envelope(:));
	gabc = oscilating_part - K.*gaussian_envelope;
	
	gab=1/(2*pi*sigma^2/(slant(1)*slant(2))^2)*(gabc);
	
end
