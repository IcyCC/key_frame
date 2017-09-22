function [image_paths,time]=deduplication(frame_num,frame_paths)
%-----------by chenpei------------
image_paths{1,1} = frame_paths{1,1};
time(1,:)=1;
index = 1;
for N = 1:frame_num-1
    name1 = frame_paths{N,1};
    name2 = frame_paths{N+1,1};
    image1 = imread(name1);
    image1 = rgb2gray(image1);
    im1=double(image1);
    image2 = imread(name2);
    image2 = rgb2gray(image2);
    im2=double(image2);
    cimage = abs(im1-im2);
    num = find(cimage >= 30);
    Num=size(num,1);
    if Num>120000
        index = index + 1;
        image_paths{index,1} = frame_paths{N+1,1};
        time(index,:) = N+1;
    end 
end
