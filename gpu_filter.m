function [ ret ] = gpu_filter( img,h )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
  img = int16(img);
  gpuimg= gpuArray(img);
  [ret] = imfilter(gpuimg,h);
%   h2 = fspecial('average', 2);
%   [ret] = imfilter(ret,h2);
  ret(ret<=0) = 0;
  ret = gather(ret);
  ret = uint16(ret);
end

