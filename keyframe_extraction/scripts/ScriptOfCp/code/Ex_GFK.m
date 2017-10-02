function Ex_GFK()
% This shows how to use GFK in a 1-nearest neighbor classifier.

% ref: Geodesic Flow Kernel for Unsupervised Domain Adaptation.  
% B. Gong, Y. Shi, F. Sha, and K. Grauman.  
% Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition (CVPR), Providence, RI, June 2012.

% Contact: Boqing Gong (boqinggo@usc.edu)


%-------------------------I. setup source/target domains----------------------
% Four domains: { Caltech10, amazon, webcam, dslr }
src = 'test1';
tgt = 'test2';

d = 10; % subspace dimension, the following dims are used in the paper:
% webcam-dslr: 10
% dslr-amazon: 20
% webcam-amazon: 10
% caltech-webcam: 20
% caltech-dslr: 10
% caltech-amazon: 20
% Note the dim from X to Y is the same as that from Y to X.

nPerClass = 20; 
% 20 per class when Caltech/Amazon/Webcam is the source domain, and 
% 8 when DSLR is the source domain.

%--------------------II. prepare data--------------------------------------
load('GFKtest1');     % source domain
yhy1 = yhy1 ./ repmat(sum(yhy1,2),1,size(yhy1,2)); 
Xs = zscore(yhy1,1);    clear yhy1
Ys = label1;           clear label1
Ps = princomp(Xs);  % source subspace

load('GFKtest2');     % target domain
yhy2 = yhy2 ./ repmat(sum(yhy2,2),1,size(yhy2,2)); 
Xt = zscore(yhy2,1);     clear yhy2
Yt = label2;            clear label2
Pt = princomp(Xt);  % target subspace

fprintf('\nsource (%s) --> target (%s):\n', src, tgt);
fprintf('round     accuracy\n');
%--------------------III. run experiments----------------------------------
round = 20; % 20 random trials  %20个随机试验
tot = 0;
for iter = 1 : round 
    fprintf('%4d', iter);
    
    inds = split(Ys, nPerClass);   %选取合适的source样本 在source中选取合适的样本，一点一点的测试过去
    Xr = Xs(inds,:);
    Yr = Ys(inds);

    %---------------III.A. PLS --------------------------------------------
    % Ps = PLS(Xr, OneOfKEncoding(Yr), 3*d);   
    % PLS generally leads to better performance.
    % A nice implementation is publicaly available at http://www.utd.edu/~herve/
    
    G = GFK([Ps,null(Ps')], Pt(:,1:d));
    size(Ps)
    
    
    size(Pt(:,1:d))
    pause()
    [~, accy] = my_kernel_knn(G, Xr, Yr, Xt, Yt);  
    
    
    fprintf('\t\t%2.2f%%\n', accy*100);
    tot = tot + accy;
end
fprintf('mean accuracy: %2.2f%%\n\n', tot/round*100);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [prediction accuracy] = my_kernel_knn(M, Xr, Yr, Xt, Yt)
dist = repmat(diag(Xr*M*Xr'),1,length(Yt)) ...
    + repmat(diag(Xt*M*Xt')',length(Yr),1)...
    - 2*Xr*M*Xt';
[~,minIDX] = min(dist);
prediction = Yr(minIDX);
accuracy = sum( prediction==Yt ) / length(Yt); 


function [idx1 idx2] = split(Y,nPerClass, ratio)
% [idx1 idx2] = split(X,Y,nPerClass)
idx1 = [];  idx2 = [];
for C = 1 : max(Y)
    idx = find(Y == C);
    rn = randperm(length(idx));
    if exist('ratio')
        nPerClass = floor(length(idx)*ratio);
    end
    idx1 = [idx1; idx( rn(1:min(nPerClass,length(idx))) ) ];
    idx2 = [idx2; idx( rn(min(nPerClass,length(idx))+1:end) ) ];
end
