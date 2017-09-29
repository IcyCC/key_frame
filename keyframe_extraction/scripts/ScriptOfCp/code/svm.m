function svm(data_temp,group_num,group_size)
%-----------by chenpei------------
total_num = group_size * group_num;

for i=1:group_num
    label =  -ones(total_num,1);
    for j = (i-1)*group_size+1:i*group_size
        label(j,:) = 1;
    end
    svmStruct = svmtrain(label,data_temp,'-s 0,-t 0,-c 10');    %这里可以选择核函数，设置参数
    modelname = strcat('svmStruct','all-',int2str(i));
    save( modelname, 'svmStruct');
end
