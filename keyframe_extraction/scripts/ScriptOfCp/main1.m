%-----------by chenpei------------

clc; 
clear ;

group_size = 20;
group_num = 3;
img_paths =[];
path_index = 0;

%% 得到训练集图片路径
for index = 1:group_num
   for i=1:group_size  
   path_index  =  path_index+1;
   name= strcat('.\',int2str(index),'\a (',int2str(i),').jpg')  ;
   img_paths{path_index,1} = name;
   end 
end

%% 提取sift特征（训练集所有图片）
data_sift = get_sifts(img_paths);

%% 聚类阶段（K-means）
%将所有图片sift特征放在一起聚类，形成K（K=800）维特征

K=800;
initMeans = data_sift(randi(size(data_sift,1),1,K),:);%初始聚类中心
[KMeans] = K_Means(data_sift,K,initMeans);%kmeans聚类
[KFeatures] = get_countVectors(KMeans,K,size(img_paths,1));% 统计图片库每张图片每个聚类中特征点个数，每张图片对应一个K维向量

%% 提取hog+gist+K维特征
data_all = get_allfeatures(KFeatures,img_paths);

%% PCA 降维
[COEFF,SCORE, latent] = princomp(data_all);
 SelectNum = cumsum(latent)./sum(latent);
 index = find(SelectNum >= 0.95);
 ForwardNum = index(1);
 data_all_pca = SCORE(:,1:ForwardNum);
 
%% SVM训练分类器(此处训练group_num个)
svm(data_all_pca,group_num,group_size);


%% 视频帧特征提取
D = dir('image/*.jpg');
frame_num = length(D);%视频帧数量
for i=1:frame_num  
    name= strcat('.\image\',int2str(i),'.jpg')  ;
    frame_paths{i,1} = name;%视频帧图片存储位置，名字代表第几秒的关键帧
end
target = frame_features( frame_paths,KMeans);%特征提取


%% 视频帧特征降维
tranMatrix = COEFF(:,1:ForwardNum);
row = size(target,1);
meanValue = mean(data_all);
normXtest = target - repmat(meanValue,[row,1]);
target_pca = normXtest*tranMatrix;

%% 输出分数最高的视频帧图片 及时间
score = [];
for i=1:group_num
    Structname = strcat('svmStruct','all-',int2str(i));
%     Structname = strcat('svmStruct','all-',int2str(2));
    load (Structname);
    w=svmStruct.SVs'*svmStruct.sv_coef;
    b=-svmStruct.rho;
    for j = 1:frame_num
        score(j,:) = target_pca(j,:)*w+b;
    end
    [B,id] = sort(score,'descend');
    for z = 1:5
        strtemp=strcat('.\image\',int2str(id(z,:)),'.jpg');
        img = imread(strtemp);
        strtemp=strcat('.\test\',int2str(i),'(',int2str(z),').jpg');
%         strtemp=strcat('.\test\',int2str(i),'(',int2str(z),').jpg');
        imwrite(img,strtemp);
    end
end


