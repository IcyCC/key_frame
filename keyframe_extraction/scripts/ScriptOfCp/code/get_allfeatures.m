 function [data_temp] = get_allfeatures(KFeatures,imgpaths)
%-----------by chenpei------------
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;

data_temp=[];
for N = 1:size(imgpaths,1)
    name = imgpaths{N,1};
    image=imread(name);
       
    im=imresize(image,[64,64]); 
    img=rgb2gray(im);
    hog =hogcalculator(img);
    hog = hog/norm(hog);
       
    [gist, param] = LMgist(img, '', param);
    gist = gist/norm(gist);
       
    data_temp(N,:) = [gist,hog]; 
end

m= size(KFeatures,1);

for j = 1:m
    KFeatures(j,:) =KFeatures(j,:)/norm(KFeatures(j,:));
end

data_temp = [data_temp,KFeatures];