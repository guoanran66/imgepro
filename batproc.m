close all
clear 
fileFolder=fullfile('D:\����\ͼ����\a\�Ϻ���ͨ��ѧ����Ѫ');
dirOutput=dir(fullfile(fileFolder,'*.jpg'));
for l = 1:length(dirOutput)
    filename = dirOutput(l).name;
    img = imread(filename);
    [high,len,~] = size(img);
    img2 = img(0.1*high:0.9*high,0.1*len:0.9*len,:);
    thresh = graythresh(img2);     %�Զ�ȷ����ֵ����ֵ  
    % I2 = im2bw(img,0.65);       %��ͼ���ֵ�� 
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
    %% ʮ��ģ��ƥ��
    % 
    if a>1000
       I3  = imresize(I2,0.3);
    else
        I3= I2;
    end
 
%    se = strel('rectangle',[2,2]);
%     I3 = imopen(I3,se);
    % I3 = bwmorph(I3, 'thin',Inf);
    figure
    imshow(I3);
    si = 51;
    mat1 =zeros(si-1);
    % ���Ͻ� ��״Ϊ
   a = (1:5);
    b = (5:-1:1);
    mat1(1:(si-1)/2,(si-1)/2+1) = -(repelem(a',5));
    mat1((si-1)/2+1:end,(si-1)/2+1) = (repelem(b',5));
    mat1((si-1)/2+1,1:(si-1)/2) = -(repelem(a,5));
    mat1((si-1)/2+1,(si-1)/2+1:end) = (repelem(b,5));
    mat1((si-1)/2+1,(si-1)/2+1) = 10;
    [ ret ] = gpu_filter( I3,mat1 );
    [~,I] = max(ret(:));
    [I_row1, I_col1] = ind2sub(size(ret),I);

    %% ���Ͻ�
    mat1(1:(si-1)/2,(si-1)/2+1) = -(repelem(a',5));
    mat1((si-1)/2+1:end,(si-1)/2+1) = (repelem(b',5));
    mat1((si-1)/2+1,1:(si-1)/2) = (repelem(a,5));
    mat1((si-1)/2+1,(si-1)/2+1:end) = -(repelem(b,5));
    mat1((si-1)/2+1,(si-1)/2+1) = 10;
    [ ret2 ] = gpu_filter( I3,mat1 );
    [~,I] = max(ret2(:));
    [I_row2, I_col2] = ind2sub(size(ret2),I);
    %% ���½�
    mat1(1:(si-1)/2,(si-1)/2+1) = (repelem(a',5));
    mat1((si-1)/2+1:end,(si-1)/2+1) = -(repelem(b',5));
    mat1((si-1)/2+1,1:(si-1)/2) = -(repelem(a,5));
    mat1((si-1)/2+1,(si-1)/2+1:end) = (repelem(b,5));
    mat1((si-1)/2+1,(si-1)/2+1) = 10;
    [ ret3 ] = gpu_filter( I3,mat1 );
    [~,I] = max(ret3(:));
    [I_row3, I_col3] = ind2sub(size(ret3),I);
    %% ���½�
    mat1(1:(si-1)/2,(si-1)/2+1) = (repelem(a',5));
    mat1((si-1)/2+1:end,(si-1)/2+1) = -(repelem(b',5));
    mat1((si-1)/2+1,1:(si-1)/2) =(repelem(a,5));
    mat1((si-1)/2+1,(si-1)/2+1:end) =  -(repelem(b,5));
    mat1((si-1)/2+1,(si-1)/2+1) = 10;
    [ ret4 ] = gpu_filter( I3,mat1 );
    [~,I] = max(ret4(:));
    [I_row4, I_col4] = ind2sub(size(ret4),I);
    hold on
    plot(I_col1,I_row1,'r*','MarkerSize',10)
    plot(I_col2,I_row2,'r*','MarkerSize',10)
    plot(I_col3,I_row3,'r*','MarkerSize',10)
    plot(I_col4,I_row4,'r*','MarkerSize',10)
end