%% �Լ�鵥�����ж�λ
% ֮ǰ�ķָ��㷨������ͼƬ���ܴ�����б���Լ�ͼƬ����ʱ���������б��ɵ�ͼ�����
% ���⣬��������ϸ�ľ��Σ�����Ҫ׼ȷ��λ���λ�ã������Ա���ڵ����ݽ���͸��任��
% �γɾ��Σ���׼�����������
%% ͸��任ʾ��
%% ԭʼͼ
% 
% <<D:\����\ͼ����\�任ǰ.jpg>>
% 
%% �任��
% 
% <<D:\����\ͼ����\�任��.jpg>>
% 
% ͸�ӱ任��Ҫ׼ȷ���ҵ����ε��ĸ��ǣ��������Ǿ��Σ���������ͼƬ���б任
close all
clear 
dbstop if error
fileFolder=fullfile('D:\����\ͼ����\a\�Ϻ���ͨ��ѧ����Ѫ');
dirOutput=dir(fullfile(fileFolder,'*.jpg')); 
for l = 1:length(dirOutput)
% for l = 1:2
    filename = dirOutput(l).name;
    [ret ,I3,I2] = improc( filename );
    figure
    title(strcat('��',num2str(l),'�Ų���ͼƬ'))
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
    title('ԭͼ')
    %͸��任
%     ret = floor(ret./I1);
    [I4,ret2]=PerspectiveTransform(I2,ret);
    subplot(2,2,2)
    imshow(I4);
    title('͸��任���ͼ')
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
%     set(gca,'Visible','off','Title',text('String',strcat('��',num2str(l),'�Ų���ͼƬ'),'Color','r'))
end
%% ����
% ���������Ż���Ŀǰ�Ը����ͼ�鵥���в��ԣ�15�����ӣ�����14���ܹ�׼ȷ��λ�����ĸ��ǣ�����
% һ��ͼƬΪ����ʱȱ�ٱ���һ�ߣ���ʱĿǰ��˼·���ܽ�������⡣
