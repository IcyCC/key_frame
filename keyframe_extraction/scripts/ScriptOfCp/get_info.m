
%-----------by chenpei------------
function [result] = get_info(im1)

group_size = 20;
group_num = 3;
img_paths =[];
path_index = 0;
root_path = pwd;


 im_name{1,1}=im1;
 im_name{1,2}='cat';
 im_name{1,3}='rabbit';

for index = 1:group_num
    for i = 1:group_size
        path_index  =  path_index+1;
        name= strcat(root_path,'/image_data/',im_name{1,index},'/a (',int2str(i),').jpg');
        img_paths{path_index,1} = name;
    end
end


data_sift = get_sifts(img_paths);


K=800;
initMeans = data_sift(randi(size(data_sift,1),1,K),:);
[KMeans] = K_Means(data_sift,K,initMeans);
[KFeatures] = get_countVectors(KMeans,K,size(img_paths,1));


data_all = get_allfeatures(KFeatures,img_paths);


[COEFF,SCORE, latent] = princomp(data_all);
 SelectNum = cumsum(latent)./sum(latent);
 index = find(SelectNum >= 0.95);
 ForwardNum = index(1);
 data_all_pca = SCORE(:,1:ForwardNum);
 

svm(data_all_pca,group_num,group_size);


frame_paths = {};
system('ffmpeg -i 1.flv -r 1 -y -f image2 image/%1d.jpg');
D = dir('image/*.jpg');
frame_num = length(D);
for i=1:frame_num  
    name= strcat(root_path,'/image/',int2str(i),'.jpg')  ;
    frame_paths{i,1} = name;
end

[image_paths,time] = deduplication(frame_num,frame_paths);
image_num = size(image_paths,1);
target = frame_features(image_paths,KMeans);


tranMatrix = COEFF(:,1:ForwardNum);
row = size(target,1);
meanValue = mean(data_all);
normXtest = target - repmat(meanValue,[row,1]);
target_pca = normXtest*tranMatrix;

    score = [];
    Structname = strcat('svmStruct','all-',int2str(1));
   load (Structname);
    w=svmStruct.SVs'*svmStruct.sv_coef;
    b=-svmStruct.rho;
    for j = 1:image_num
        score(j,:) = target_pca(j,:)*w+b;
    end
    score = [score,time];
    score = flipud(sortrows(score,1));
    for z = 1:5
        strtemp=strcat(root_path,'/image/',int2str(score(z,2)),'.jpg');
        frame{1,1} = '1.flv';
        frame{1,2} = strcat(root_path,'test/',int2str(score(z,2)),'.jpg');
        frame{1,3} = secondtotime(score(z,2));
        result{z} = frame;
        img = imread(strtemp);
        strtemp=strcat(root_path,'/test/',int2str(score(z,2)),'.jpg');
        imwrite(img,strtemp);
    end
