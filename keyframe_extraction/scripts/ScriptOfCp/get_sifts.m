function [sifts] = get_sifts(imgpaths)
% function [ imgpaths,sifts] = get_sifts( FullFilePaths )
% imgpaths = textread(FullFilePaths,'%s');
%-----------by chenpei------------
 sifts = [];
 for N = 1:size(imgpaths,1)
     name = imgpaths{N,1};
     image=imread(name);
     im=imresize(image,[128,128]);  
     img=rgb2gray(im);  
     imshow(img);
     
     [~,descr,~,~] = do_sift( img, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 );
     descr = descr';
     sift_count = size(descr,1);
     descr = [descr,ones(sift_count,1)*N];
     sifts = [sifts;descr];
end