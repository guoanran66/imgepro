function [ output_args, I3,I2] = improc( filename )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明

    img = imread(filename);
    img = rgb2gray(img);
    I2 = my_im2bw(img); 
    I2 = imresize(I2,0.5);
    I2 = ~I2;
    [high,len] = size(I2);
    if high > len
        I2 = imrotate(I2,90);
    end
    [a,b] = size(I2);
    % I2 = imresize(I2,[1000,1500]);
%     figure
%      imshow(I2);
    %% 十字模板匹配
    I3= I2;
    se = strel('rectangle',[1,2]);
    I3 = imdilate(I3,se);
    % I3 = bwmorph(I3, 'thin',Inf);
    
    si = 51;
    mat1 =zeros(si-1);
    %% 左上角 
    n = 5;
    a = (2:6);
    b = (6:-1:2);
    mat1(1:(si-1)/2,(si-1)/2+1) = -(repelem(a',n));
    mat1((si-1)/2+1:end,(si-1)/2+1) = (repelem(b',n));
    mat1((si-1)/2+1,1:(si-1)/2) = -(repelem(a,n));
    mat1((si-1)/2+1,(si-1)/2+1:end) = (repelem(b,n));
    mat1((si-1)/2+1,(si-1)/2+1) = 10;
%     mat1(1:(si)/2,(si)/2:(si)/2+1)        = repelem(-(repelem(a',n)),1,2);
%     mat1((si)/2+1:end,(si)/2:(si)/2+1)    = repelem((repelem(b',n)),1,2);
%     mat1((si)/2:(si)/2+1,1:(si)/2)        = repelem(-(repelem(a,n)),2,1);
%     mat1((si)/2:(si)/2+1,(si)/2+1:end)    = repelem((repelem(b,n)),2,1); 
%     mat1((si)/2:(si)/2+1,(si)/2:(si)/2+1) = 5;
    [ ret ] = gpu_filter( I3,mat1 );
    [~,I] = max(ret(:));
    [I_row1, I_col1] = ind2sub(size(ret),I);

    %% 右上角
    mat1(1:(si-1)/2,(si-1)/2+1) = -(repelem(a',n));
    mat1((si-1)/2+1:end,(si-1)/2+1) = (repelem(b',n));
    mat1((si-1)/2+1,1:(si-1)/2) = (repelem(a,n));
    mat1((si-1)/2+1,(si-1)/2+1:end) = -(repelem(b,n));
    mat1((si-1)/2+1,(si-1)/2+1) = 10;
%     mat1(1:(si)/2,(si)/2:(si)/2+1)        = repelem(-(repelem(a',n)),1,2);
%     mat1((si)/2+1:end,(si)/2:(si)/2+1)    = repelem((repelem(b',n)),1,2);
%     mat1((si)/2:(si)/2+1,1:(si)/2)        = repelem((repelem(a,n)),2,1);
%     mat1((si)/2:(si)/2+1,(si)/2+1:end)    = repelem(-(repelem(b,n)),2,1); 
%     mat1((si)/2:(si)/2+1,(si)/2:(si)/2+1) = 5;
    [ ret2 ] = gpu_filter( I3,mat1 );
    [~,I] = max(ret2(:));
    [I_row2, I_col2] = ind2sub(size(ret2),I);
    %% 左下角
    mat1(1:(si-1)/2,(si-1)/2+1) = (repelem(a',n));
    mat1((si-1)/2+1:end,(si-1)/2+1) = -(repelem(b',n));
    mat1((si-1)/2+1,1:(si-1)/2) = -(repelem(a,n));
    mat1((si-1)/2+1,(si-1)/2+1:end) = (repelem(b,n));
    mat1((si-1)/2+1,(si-1)/2+1) = 10;

%     mat1(1:(si)/2,(si)/2:(si)/2+1)        = repelem((repelem(a',n)),1,2);
%     mat1((si)/2+1:end,(si)/2:(si)/2+1)    = repelem(-(repelem(b',n)),1,2);
%     mat1((si)/2:(si)/2+1,1:(si)/2)        = repelem(-(repelem(a,n)),2,1);
%     mat1((si)/2:(si)/2+1,(si)/2+1:end)    = repelem((repelem(b,n)),2,1); 
%     mat1((si)/2:(si)/2+1,(si)/2:(si)/2+1) = 5;
    [ ret3 ] = gpu_filter( I3,mat1 );
    [~,I] = max(ret3(:));
    [I_row3, I_col3] = ind2sub(size(ret3),I);
    %% 右下角
    mat1(1:(si-1)/2,(si-1)/2+1) = (repelem(a',n));
    mat1((si-1)/2+1:end,(si-1)/2+1) = -(repelem(b',n));
    mat1((si-1)/2+1,1:(si-1)/2) =(repelem(a,n));
    mat1((si-1)/2+1,(si-1)/2+1:end) =  -(repelem(b,n));
    mat1((si-1)/2+1,(si-1)/2+1) = 10;
%     mat1(1:(si)/2,(si)/2:(si)/2+1)        = repelem((repelem(a',n)),1,2);
%     mat1((si)/2+1:end,(si)/2:(si)/2+1)    = repelem(-(repelem(b',n)),1,2);
%     mat1((si)/2:(si)/2+1,1:(si)/2)        = repelem((repelem(a,n)),2,1);
%     mat1((si)/2:(si)/2+1,(si)/2+1:end)    = repelem(-(repelem(b,n)),2,1); 
%     mat1((si)/2:(si)/2+1,(si)/2:(si)/2+1) = 5;
    [ ret4 ] = gpu_filter( I3,mat1 );
    [~,I] = max(ret4(:));
    [I_row4, I_col4] = ind2sub(size(ret4),I);
    output_args = [I_row1, I_col1;I_row2, I_col2;I_row3, I_col3;I_row4, I_col4];
end

