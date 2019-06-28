clear;clc;
warning off;

data_choose = 1;


% %%%%%%%%%%%%%% Indian pine %%%%%%%%%%%%%%%
train_ratio = 0.05;
test_ratio = 1-train_ratio;

if data_choose == 1
std = double(imread('92AV3GT.tif'));
stdimage = double(imread('92AV3C.tif'));
stdimage(:,:,[104:108 150:163 220]) = [];

elseif data_choose == 2
load paviaU.mat;
stdimage = double(paviaU);
load paviaU_gt.mat;
std = double(paviaU_gt);

elseif data_choose == 3
load pavia_right;
stdimage = double(pavia);
load pavia_gt_right
std = double(pavia_gt);

elseif data_choose == 4
load Botswana.mat;
stdimage = double(Botswana);
load Botswana_gt.mat;
std = double(Botswana_gt);

else
load KSC.mat;
stdimage = double(KSC);
load KSC_gt.mat;
std = double(KSC_gt);
end

class_num = max(max(std));
std(std==0)=100;
img = ToVector(stdimage);
img = img';
img = NormalizeFea(img,0);


height = size(std,1);
width = size(std,2);
trueindex = reshape(std,[1 height*width]);

for i0=1:10
mydisp(i0,10);

train_gt = [];
train = [];
train_avg = [];
train_sqrt = [];
train_index_all = [];
test_gt = [];
test = [];
test_index_all = [];

for i=1:class_num
    index{i} = find(trueindex==i);
    class_rand{i} = randperm(size(index{i},2));
    
    if exist('train_ratio','var')
        train_index{i} = index{i}(class_rand{i}(1:round(size(class_rand{i},2)*train_ratio)));
    else
        train_index{i} = index{i}(class_rand{i}(1:train_each));
    end
    
    class_train{i} = img(:,train_index{i});
    train_number(i) = size(class_train{i},2);
    train_gt = [train_gt i*ones(1,train_number(i))];
    train = [train class_train{i}];
    train_avg = [train_avg mean(class_train{i},2)];
    train_sqrt = [train_sqrt 1/sqrt(train_number(i))];
    train_index_all = [train_index_all train_index{i}];
    
    test_index{i} = index{i}(class_rand{i}(train_number(i)+1:end));
    class_test{i} = img(:,test_index{i});
    test_number(i) = size(class_test{i},2);
    test_gt = [test_gt i*ones(1,ceil(test_number(i)*test_ratio))];
    test = [test class_test{i}(:,1:ceil(test_number(i)*test_ratio))];
    test_index_all = [test_index_all test_index{i}(:,1:ceil(test_number(i)*test_ratio))];
end

test_size = size(test,2);
train_size = size(train,2);
feature_size = size(test,1);
image_size = size(std,1);


if data_choose == 1
load img_scat_J2_L22_M2
elseif data_choose == 2
load paviaU_scat
elseif data_choose == 3
load pavia_scat_L2
elseif data_choose == 4
load botswana_scat
else 
load KSC_scat
end

img_scat(:,std~=0&std~=100) = img_scat;
train_scat = img_scat(:,train_index_all);
test_scat = img_scat(:,test_index_all);

model_SVM = svmtrain(train_gt',train', '-c 128 -g 64 -q');
[map_SVM(:,i0)] = svmpredict(test_gt', test', model_SVM,'-q');

model_SVM = svmtrain(train_gt',train_scat', '-c 32768 -g 4 -q');
[map_SVM_2(:,i0)] = svmpredict(test_gt', test_scat', model_SVM,'-q');


[OA_SVM(i0),kappa_SVM(i0),AA_SVM(i0),CA_SVM(:,i0),errorMatrix_SVM] = calcError(test_gt,map_SVM(:,i0)',1:class_num);
[OA_SVM_scat(i0),kappa_SVM_scat(i0),AA_SVM_scat(i0),CA_SVM_scat(:,i0),errorMatrix_SVM_scat] = calcError(test_gt,map_SVM_2(:,i0)',1:class_num);

end

OA_SVM
OA_SVM_scat
clear img_scat
load chirp
sound(y,Fs)