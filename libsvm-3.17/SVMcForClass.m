function [bestacc,bestc] = SVMcgForClass(train_label,train,cmin,cmax,v,cstep,accstep)
% SVMcgForClass
% ����:
% train_label:ѵ������ǩ.Ҫ����libsvm��������Ҫ��һ��.
% train:ѵ����.Ҫ����libsvm��������Ҫ��һ��.
% cmin:�ͷ�����c�ı仯��Χ����Сֵ(ȡ��2Ϊ�׵Ķ�����),�� c_min = 2^(cmin).Ĭ��Ϊ -5
% cmax:�ͷ�����c�ı仯��Χ�����ֵ(ȡ��2Ϊ�׵Ķ�����),�� c_max = 2^(cmax).Ĭ��Ϊ 5
% gmin:����g�ı仯��Χ����Сֵ(ȡ��2Ϊ�׵Ķ�����),�� g_min = 2^(gmin).Ĭ��Ϊ -5
% gmax:����g�ı仯��Χ����Сֵ(ȡ��2Ϊ�׵Ķ�����),�� g_min = 2^(gmax).Ĭ��Ϊ 5
% v:cross validation�Ĳ���,�������Լ���Ϊ�����ֽ���cross validation.Ĭ��Ϊ 3
% cstep:����c�����Ĵ�С.Ĭ��Ϊ 1
% gstep:����g�����Ĵ�С.Ĭ��Ϊ 1
% accstep:�����ʾ׼ȷ��ͼʱ�Ĳ�����С.Ĭ��Ϊ 1.5
% ���:
% bestacc:Cross Validation �����е���߷���׼ȷ��
% bestc:��ѵĲ���c
% bestg:��ѵĲ���g

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
% title('����ѡ����ͼ(grid search)','FontSize',10);
% grid on;

