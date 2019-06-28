function [bestacc,bestc] = SVMcgForClass(train_label,train,cmin,cmax,v,cstep,accstep)
% SVMcgForClass
% 输入:
% train_label:训练集标签.要求与libsvm工具箱中要求一致.
% train:训练集.要求与libsvm工具箱中要求一致.
% cmin:惩罚参数c的变化范围的最小值(取以2为底的对数后),即 c_min = 2^(cmin).默认为 -5
% cmax:惩罚参数c的变化范围的最大值(取以2为底的对数后),即 c_max = 2^(cmax).默认为 5
% gmin:参数g的变化范围的最小值(取以2为底的对数后),即 g_min = 2^(gmin).默认为 -5
% gmax:参数g的变化范围的最小值(取以2为底的对数后),即 g_min = 2^(gmax).默认为 5
% v:cross validation的参数,即给测试集分为几部分进行cross validation.默认为 3
% cstep:参数c步进的大小.默认为 1
% gstep:参数g步进的大小.默认为 1
% accstep:最后显示准确率图时的步进大小.默认为 1.5
% 输出:
% bestacc:Cross Validation 过程中的最高分类准确率
% bestc:最佳的参数c
% bestg:最佳的参数g

% about the parameters of SVMcgForClass
if nargin < 7
    accstep = 1.5;
end
if nargin < 6
    accstep = 1.5;
    cstep = 1;
end
if nargin < 5
    accstep = 1.5;
    v = 3;
    cstep = 1;
end
if nargin < 4
    accstep = 1.5;
    v = 3;
    cstep = 1;
    cmax = 5;
end
if nargin < 3
    accstep = 1.5;
    v = 3;
    cstep = 1;
    cmax = 5;
    cmin = -5;
end
% X:c Y:g cg:accuracy
% [X,Y] = meshgrid(cmin:cstep:cmax);
X = cmin:cstep:cmax;
m = length(X);
c = zeros(m,1);
% record accuracy with different c & g,and find the best accuracy with the smallest c
bestc = 0;
bestacc = 0;
basenum = 2;
for i = 1:m
    cmd = ['-v ',num2str(v),' -c ',num2str( basenum^X(i) ),' -t 0 -q'];
    c(i) = svmtrain(train_label, train, cmd);

    if c(i) > bestacc
        bestacc = c(i);
        bestc = basenum^X(i);
    end
    if ( c(i) == bestacc && bestc > basenum^X(i) )
        bestacc = c(i);
        bestc = basenum^X(i);
    end
end
% draw the accuracy with different c & g
% figure;
% [C,h] = contour(X,Y,cg,60:accstep:100);
% clabel(C,h,'FontSize',10,'Color','r');
% xlabel('log2c','FontSize',10);
% ylabel('log2g','FontSize',10);
% title('参数选择结果图(grid search)','FontSize',10);
% grid on;

