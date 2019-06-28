% compute scattering with non-default options
clear;clc;close;


image = double(imread('92AV3C.tif'));
clear stdimage
image(:,:,[104:108 150:163 220]) = [];
std = double(imread('92AV3GT.tif'));

% load paviaU.mat;
% image = double(paviaU);
% load paviaU_gt.mat;
% std = double(paviaU_gt);

% load pavia_right.mat;
% image = double(pavia);
% load pavia_gt_right.mat;
% std = double(pavia_gt);

% load Botswana.mat;
% image = double(Botswana);
% load Botswana_gt.mat;
% std = double(Botswana_gt);

% load KSC.mat;
% image = double(KSC);
% load KSC_gt.mat;
% std = double(KSC_gt);


filt_opt.J = 2;
filt_opt.L1 = 2;
filt_opt.L2 = 2;
scat_opt.oversampling = 3;
scat_opt.M = 2;

%%
% Wop = wavelet_factory_2d_pyramid(filt_opt, scat_opt);
% Wop = wavelet_factory_2d(size(image(:,:,1)),filt_opt, scat_opt);
% Sx = scat(image(:,:,1), Wop);
%%
% Wop = my_wavelet_factory_3d_hd(size(image),filt_opt, scat_opt);
Wop = my_wavelet_factory_3d(size(image),filt_opt, scat_opt);
%%
% Sx = scat_hd(image, Wop);
Sx = scat(image, Wop);
S = format_scat(Sx);
% % 
temp = permute(S,[2,3,4,1]);
img_scat = double(ToVector(reshape(temp,[size(temp,1),size(temp,2), size(temp,3)*size(temp,4)]))');
% for i=1:size(img_scat,1)/200
%     img_scat((i-1)*200+1:i*200,:) = NormalizeFea(img_scat((i-1)*200+1:i*200,:),0);
% end
img_scat = NormalizeFea(img_scat(:,std~=0),0);
% option.ReducedDim = 200;
[eigvector,eigvalue]=PCA(img_scat');
img_scat = (img_scat'*eigvector)';

save(['img_scat_J',num2str(filt_opt.J),'_L',num2str(filt_opt.L1),num2str(filt_opt.L2),'_M',num2str(scat_opt.M)],'img_scat');
% save botswana_scat_J3_M0_2 img_scat
clear Sx S temp img_scat;

load chirp
sound(y,Fs)