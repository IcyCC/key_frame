function target = frame_features(image_paths,KMeans)
%-----------by chenpei------------
frame_data = get_sifts(image_paths);
K=size(KMeans,2);

target_sift=zeros(size(image_paths,1),K);
for N=1:size(frame_data,1);                                                                                    
    min = do_eucidean_distance(frame_data(N,(1:128)),KMeans(1).value);
    num = 1;
    for M=2:K
        distance = do_eucidean_distance(frame_data(N,(1:128)),KMeans(M).value);
        if(distance<min)
            min = distance;
            num = M;
        end;
    end;
    target_sift(frame_data(N,129),num )= target_sift(frame_data(N,129),num)+1;
end;

target = get_allfeatures(target_sift,image_paths);