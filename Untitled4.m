%% 对检查单表格进行定位
% 之前的分割算法，由于图片可能存在倾斜，以及图片拍摄时由于相机倾斜造成的图像畸形
% 问题，即表格不是严格的矩形，，需要准确定位表格位置，后续对表格内的内容进行透射变换，
% 形成矩形，标准化表格内内容
%% 透射变换示意
%% 原始图
% 
% <<D:\工作\图像处理\变换前.jpg>>
% 
%% 变换后
% 
% <<D:\工作\图像处理\变换后.jpg>>
% 
% 透视变换需要准确的找到矩形的四个角，假设其是矩形，对其整张图片进行变换
close all
clear 
dbstop if error
fileFolder=fullfile('D:\工作\图像处理\a\上海交通大学静脉血');
dirOutput=dir(fullfile(fileFolder,'*.jpg')); 
for l = 1:length(dirOutput)
% for l = 1:2
    filename = dirOutput(l).name;
    [ret ,I3,I2] = improc( filename );
    figure
    title(strcat('第',num2str(l),'张测试图片'))
    hold on
    subplot(2,2,1)
    imshow(I3);
    hold on
    subplot(2,2,1)
    figret = ret;
    figret(3,:) = [];
    figret(4,:) = ret(3,:);
    figret(5,:) = ret(1,:);
%       plot(figret(:,2),figret(:,1),'-r*','MarkerSize',10)
    plot(ret(1,2),ret(1,1),'r*','MarkerSize',10)
    plot(ret(2,2),ret(2,1),'r*','MarkerSize',10)
    plot(ret(3,2),ret(3,1),'r*','MarkerSize',10)
    plot(ret(4,2),ret(4,1),'r*','MarkerSize',10) 
    title('原图')
    %透射变换
%     ret = floor(ret./I1);
    [I4,ret2]=PerspectiveTransform(I2,ret);
    subplot(2,2,2)
    imshow(I4);
    title('透射变换结果图')
%     [I5,I6]=imgcut(I4,ret2);
%     subplot(2,2,3)
%     imshow(I5);
%     subplot(2,2,4)
%     imshow(I6);
%     hold on
%     figret = ret2;
%     figret(3,:) = [];
%     figret(4,:) = ret2(3,:);
%     figret(5,:) = ret2(1,:);
%     plot(figret(:,2),figret(:,1),'-r*','MarkerSize',10)
%     axes
%     set(gca,'Visible','off','Title',text('String',strcat('第',num2str(l),'张测试图片'),'Color','r'))
end
%% 结论
% 经过参数优化，目前对该类型检查单进行测试，15个单子，其中14个能够准确定位表格的四个角，其中
% 一张图片为拍摄时缺少表格的一边，暂时目前的思路不能解决该问题。
