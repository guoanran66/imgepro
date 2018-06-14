clear 
close all
clc
dbstop if error
load templat.mat
img = imread('6012.jpg');
[high,len,~] = size(img);
img2 = img(0.1*high:0.9*high,0.1*len:0.9*len,:);
thresh = graythresh(img2);     %自动确定二值化阈值  
% I2 = im2bw(img,0.65);       %对图像二值化 
img = rgb2gray(img);
I2 = my_im2bw(img); 
I2 = imresize(I2,0.5);
I2 = ~I2;
[high,len] = size(I2);
if high > len
    I2 = imrotate(I2,90);
end
[a,b] = size(I2);
sum_row = sum(I2,1);
sum_col = sum(I2,2);
figure
plot(sum_row);
hold on
plot(sum_col);
legend('sum_row','sum_col')

% I2 = imresize(I2,[1000,1500]);
figure
imshow(I2);
%% 十字模板匹配
% 
I3  = imresize(I2,0.3);
% I3 = bwmorph(I3, 'thin',Inf);
imshow(I3);
si = 51;
mat1 =zeros(si-1);
% 左上角 形状为
aa = (1:5);
bb = (5:-1:1);
mat1(1:(si-1)/2,(si-1)/2+1) = -(repelem(aa',5));
mat1((si-1)/2+1:end,(si-1)/2+1) = (repelem(b',5));
mat1((si-1)/2+1,1:(si-1)/2) = -(repelem(aa,5));
mat1((si-1)/2+1,(si-1)/2+1:end) = (repelem(bb,5));
mat1((si-1)/2+1,(si-1)/2+1) = 10;
[ ret ] = gpu_filter( I3,mat1 );
[~,I] = max(ret(:));
[I_row1, I_col1] = ind2sub(size(ret),I);

%% 右上角
mat1(1:(si-1)/2,(si-1)/2+1) = -(repelem(aa',5));
mat1((si-1)/2+1:end,(si-1)/2+1) = (repelem(b',5));
mat1((si-1)/2+1,1:(si-1)/2) = (repelem(aa,5));
mat1((si-1)/2+1,(si-1)/2+1:end) = -(repelem(bb,5));
mat1((si-1)/2+1,(si-1)/2+1) = 10;
[ ret2 ] = gpu_filter( I3,mat1 );
[~,I] = max(ret2(:));
[I_row2, I_col2] = ind2sub(size(ret2),I);
%% 左下角
mat1(1:(si-1)/2,(si-1)/2+1) = (repelem(aa',5));
mat1((si-1)/2+1:end,(si-1)/2+1) = -(repelem(bb',5));
mat1((si-1)/2+1,1:(si-1)/2) = -(repelem(aa,5));
mat1((si-1)/2+1,(si-1)/2+1:end) = (repelem(bb,5));
mat1((si-1)/2+1,(si-1)/2+1) = 10;
[ ret3 ] = gpu_filter( I3,mat1 );
[~,I] = max(ret3(:));
[I_row3, I_col3] = ind2sub(size(ret3),I);
%% 右下角
mat1(1:(si-1)/2,(si-1)/2+1) = (repelem(a',5));
mat1((si-1)/2+1:end,(si-1)/2+1) = -(repelem(b',5));
mat1((si-1)/2+1,1:(si-1)/2) =(repelem(a,5));
mat1((si-1)/2+1,(si-1)/2+1:end) =  -(repelem(b,5));
mat1((si-1)/2+1,(si-1)/2+1) = 10;
[ ret4 ] = gpu_filter( I3,mat1 );
[~,I] = max(ret4(:));
[I_row4, I_col4] = ind2sub(size(ret4),I);
hold on
plot(I_col1,I_row1,'r*')
plot(I_col2,I_row2,'r*')
plot(I_col3,I_row3,'r*')
plot(I_col4,I_row4,'r*')
%%  倾斜校正 检测横向直线
se = strel('rectangle',[30,50]);
I3 = imclose(I2,se);
figure 
% imshow(I3)
I3 = imresize(I3,0.2);
 L = bwlabel(I3, 4);
%   L = logical(I2);
% (2)Compute the area of each component.
  S = regionprops(L, 'Area');
% (3)Remove small objects.
  I3 = ismember(L, find([S.Area] >= 10));
  I3 = bwmorph(I3, 'thin',Inf);
  I3 = imrotate(I3,30);
  imshow(I3)
% templat = I3(30:end,:);
%%
hold on
[H1,T1,R1] = hough(I3,'Theta',50:0.1:70);
%求极值点
Peaks=houghpeaks(H1,100);
%得到线段信息
lines=houghlines(I3,T1,R1,Peaks);
%绘制线段
p1 = zeros(length(lines),2);
 for k=1:length(lines)
    xy=[lines(k).point1;lines(k).point2];   
    plot(xy(:,1),xy(:,2),'LineWidth',2);
    p1(k,:)=polyfit(xy(:,1),xy(:,2),1);  
 end
 %% 合并直线
 figure 
   imshow(I3)
   hold on
 selet = zeros(1,size(p1,1));
 seletflag = zeros(1,size(p1,1));
 class_val = 1;
 for i = 1: size(p1,1)
     if seletflag(i)
         continue;
     end
     selet(i) = class_val;
     for j = i+1 :size(p1,1)
         if seletflag(i)
            continue;
         end
         if abs(p1(i,1) - p1(j,1)) < 0.1 && abs(p1(i,2) - p1(j,2)) < size(I2,1)/60
             seletflag(j) = 1;
             selet(j) = class_val;
             
         end
     end
     
     class_val = class_val +1;
 end
 for i = 1: class_val-1
     ret = find(selet == i);
     point1 = zeros(length(ret),3);
     point2 = zeros(length(ret),3);
     for j = 1:length(ret)
        point1(j,1:2)  = lines(ret(j)).point1;
        point2(j,1:2)  = lines(ret(j)).point2;
     end
     [~,index1] = min(point1(:,1));
     [~,index2] = max(point2(:,1));
     xy=[point1(index1,1:2);point2(index2,1:2)];
     plot(xy(:,1),xy(:,2),'LineWidth',2);
 end
 

%% 取左半部分空白区域进行投影过滤小目标，计算其文字框高度
child = I2(:,floor(0.9*a):floor(0.9*b));
 L = bwlabel(child, 4);
%   L = logical(I2);
% (2)Compute the area of each component.
  S = regionprops(L, 'Area');
% (3)Remove small objects.
  child = ismember(L, find([S.Area] >= 100));
%   child = bwmorph(child, 'thin',Inf);
%   child = imrotate(child,30);
figure
imshow(child);
sum1 = sum(child,2);
figure
plot(sum1)
Target = zeros(1,3);
target = ones(1,3);
Star = 0;
len  = 0;
for i = 1: length(sum1)
    if sum1(i) <20
        len = len +1;
        target(2) = i;
    else
        
        target(3) = len;
       
        if Target(3)<target(3)
            Target = target;
        end
        target(1) = i; 
        len = 0;
    end
    
end

%%  获取中间部分框内文字区域
child2 = I2(Target(1):Target(2),1:floor(0.5*b));
L = bwlabel(child2, 4);
S = regionprops(L, 'Area');
child2 = ismember(L, find([S.Area] >= 20));
figure
imshow(child2);
sum1 = sum(child2);
figure
plot(sum1)
se = strel('rectangle',[10,20]);
child2 = imclose(child2,se);
figure
imshow(child2);
sum1 = sum(child2);
figure
plot(sum1)
Target1 = zeros(2,3);
target = ones(1,3);
for i = 1:floor( 0.6*a)
     if sum1(i) > 20
        len = len +1;
        target(2) = i;
     else
         if len > 50
             target(3) = len;
            if Target1(1,3)<target(3)
                Target1(1,:) = target;
                if Target1(1,3) > Target1(2,3)
                   Target1 =flipud(Target1);
                end
            end
         end
        target(1) = i; 
        len = 0;
    end
end

child3 = I2(Target(1):Target(2),Target1(1,1):Target1(1,2));
figure
imshow(child3);
child4 = I2(Target(1):Target(2),Target1(2,1):Target1(2,2));
figure
imshow(child4);
% %% 取其中一部分进行i运算然后进行投影
% child = I2(400:600,:);
% se = strel('rectangle',[30,50]);
% child = imclose(child,se);
% 
% figure
% imshow(child);
% sum1 = sum(child);
% figure
% plot(1:1500,child);
%%
% sumval = sum(I2);
% leftsum  = sum(sumval(1:fix((length(sumval)/2))));
% rightsum = sum(sumval(1+fix((length(sumval)/2)):end));
% 
% if rightsum>leftsum
%     I2 = imrotate(I2,180);
% end

% %% 图像增强滤波
% 
% 
% 
%  plot([1,100],[1,100],'LineWidth',2);
%  %% 竖直线检测
% %  I2 = bwmorph(I2, 'thin',Inf);
%  imshow(I2)
%  hold on
%  [H2,T2,R2] = hough(I2,'Theta',-10:0.1:10);
% %求极值点
% Peaks2=houghpeaks(H2,5);
% %得到线段信息
% lines2=houghlines(I2,T2,R2,Peaks2);
% %绘制线段
%  for k=1:length(lines2)
% xy2=[lines2(k).point1;lines2(k).point2];   
% plot(xy2(:,1),xy2(:,2),'LineWidth',4);
%  end