% MY_MORLET_FILTER_BANK_3D_PYRAMID Compute a bank of Morlet wavelet filters in
% the spatial domain.
%
% Usage
%	filters = MY_MORLET_FILTER_BANK_3D_PYRAMID(options)
%
% Input
%    options (structure): Options of the bank of filters. Optional, with
%    fields:
%       Q (numeric): number of scale per octave
%       L (numeric): number of orientations
%       size_filter (numeric): size of the filter
%       sigma_phi (numeric): standard deviation of the low pass phi_0
%       sigma_psi (numeric): standard deviation of the envelope of the
%       high-pass psi_0
%       xi_psi (numeric): the frequency peak of the high-pass psi_0
%       slant_psi (numeric): excentricity of the elliptic enveloppe of the
%       high-pass psi_0 (the smaller slant, the larger orientation
%       resolution)
%       precision (string): 'single' or 'double'
%
% Output
%    filters (struct):  filters, with the fields
%        g (struct): high-pass filter g, with the following fields:
%            filter (cell): cell of structure containing the coefficients
%            type (string): takes the value 'spatial_support'
%        h (struct): low-pass filter h
%            filter (cell): cell of structure containing the coefficients
%            type (string): takes the value 'spatial_support'
%        meta (struct): contains meta-information on (g,h)
%
% Description
%    Compute the Morlet filter bank in the spatial domain. 

function [filters, options] = my_morlet_filter_bank_3d_pyramid(options)
    if(nargin<1)
		options = struct;
    end
    
    white_list = {'Q', 'L1', 'L2', 'size_filter', 'sigma_phi', 'sigma_psi', ...
        'xi_psi', 'slant_psi', 'precision'};
    check_options_white_list(options, white_list);
    
    % Options
    options = fill_struct(options, 'Q', 1);	
    options = fill_struct(options, 'L1', 1);
    options = fill_struct(options, 'L2', 1);
    Q = options.Q;
    L1 = options.L1;
    L2 = options.L2;
    options = fill_struct(options, 'size_filter',  [7, 7, 7]);	
	options = fill_struct(options, 'sigma_phi',  0.8);	
    options = fill_struct(options, 'sigma_psi',  0.8);	
    options = fill_struct(options, 'xi_psi',  1/2*(2^(-1/Q)+1)*pi);	
    options = fill_struct(options, 'slant_psi',  [4/L1,4/L2]);	
    options = fill_struct(options, 'precision', 'single');	
    
    size_filter = options.size_filter;
	sigma_phi = options.sigma_phi;
    sigma_psi = options.sigma_psi;
    xi_psi = options.xi_psi;
    slant_psi = options.slant_psi;
    precision = options.precision;
    
    switch options.precision
        case 'single'
            cast = @single;
        case 'double'
            cast = @double;
        otherwise
            error('precision must be either double or single');
    end
    
    N = size_filter(1);
    M = size_filter(2);
    K = size_filter(3);
    offset = [floor(N/2), floor(M/2), floor(K/2)];
    
	% low pass filter h
	h.filter.coefft = my_gaussian_3d(N,...
		M,...
        K,...
		sigma_phi,...
		precision,...
        offset);
    h.filter.coefft = cast(h.filter.coefft./sum(h.filter.coefft(:)));
	h.filter.type = 'spatial_support';
	
	angles1 = (0:L1-1)  * pi / L1;
    angles2 = (0:L2-1)  * pi / L2;
	p = 1;
	
	% high pass filters g
	for q = 0:Q-1
		for theta1 = 1:numel(angles1)
            for theta2 = 1:numel(angles2)

                angle = [angles1(theta1),angles2(theta2)];
                scale = 2^(q/Q);

                g.filter{p}.coefft = cast(my_morlet_3d_pyramid(N,...
                    M, ...
                    K, ...
                    sigma_psi*scale,...
                    slant_psi,...
                    xi_psi/scale,...
                    angle,...
                    offset)) ;
                g.filter{p}.type = 'spatial_support';

                g.meta.q(p) = q;
                g.meta.theta1(p) = theta1;
                g.meta.theta2(p) = theta2;
                p = p + 1;
            end
		end
	end
	
	filters.h = h;
	filters.g = g;
	
	filters.meta.Q = Q;
	filters.meta.L1 = L1;
    filters.meta.L2 = L2;
    filters.meta.size_filter = size_filter;
	filters.meta.sigma_phi = sigma_phi;
	filters.meta.sigma_psi = sigma_psi;
	filters.meta.xi_psi = xi_psi;
	filters.meta.slant_psi = slant_psi;
    filters.meta.offset = offset;
	
	
end
