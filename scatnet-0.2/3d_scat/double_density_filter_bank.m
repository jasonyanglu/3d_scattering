function [ filters, options ] = double_density_filter_bank( options )
%DOUBEL_DENSITY_FILTER_BANK Summary of this function goes here
%   Detailed explanation goes here
    if(nargin<1)
		options = struct;
    end
    
    fc = options.filter_choose;
%     white_list = {'Q', 'L', 'size_filter', 'sigma_phi', 'sigma_psi', ...
%         'xi_psi', 'slant_psi', 'precision'};
%     check_options_white_list(options, white_list);
    
    % Options
    options = fill_struct(options, 'Q', 1);	
    options = fill_struct(options, 'L', 8);
    Q = options.Q;
    L = options.L;
    options = fill_struct(options, 'size_filter',  [14, 14]);	
% 	options = fill_struct(options, 'sigma_phi',  0.8);	
%     options = fill_struct(options, 'sigma_psi',  0.8);	
%     options = fill_struct(options, 'xi_psi',  1/2*(2^(-1/Q)+1)*pi);	
%     options = fill_struct(options, 'slant_psi',  4/L);	
    options = fill_struct(options, 'precision', 'single');	
    
    size_filter = options.size_filter;
% 	sigma_phi = options.sigma_phi;
%     sigma_psi = options.sigma_psi;
%     xi_psi = options.xi_psi;
%     slant_psi = options.slant_psi;
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
    offset = [floor(N/2), floor(M/2)];
    
        
    [Faf, Fsf] = FSdoubledualfilt;
    [af, sf] = doubledualfilt;
        
	% low pass filter h
	h.filter.coefft = conv2(Faf{fc}(:,1)',Faf{fc}(:,1));
    h.filter.coefft2 = conv2(af{fc}(:,1)',af{fc}(:,1));
	h.filter.type = 'spatial_support';
	
	
	p = 1;
	
	% high pass filters g
	for i = 1:3
		for j = 1:3
			if i==1 && j==1
                continue;
            end
			
			g.filter{p}.coefft = conv2(Faf{fc}(:,i)',Faf{fc}(:,j));
            g.filter{p}.coefft2 = conv2(af{fc}(:,i)',af{fc}(:,j));
			g.filter{p}.type = 'spatial_support';
			
			g.meta.q(p) = 0;
			g.meta.theta(p) = (i-1)*3+j-1;
			p = p + 1;
			
		end
	end
	
	filters.h = h;
	filters.g = g;
	
	filters.meta.Q = Q;
	filters.meta.L = L;
    filters.meta.size_filter = size_filter;
% 	filters.meta.sigma_phi = sigma_phi;
% 	filters.meta.sigma_psi = sigma_psi;
% 	filters.meta.xi_psi = xi_psi;
% 	filters.meta.slant_psi = slant_psi;
    filters.meta.offset = offset;
	
	

end

