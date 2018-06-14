function [ mat ] = my_im2bw( img )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

[hh, ww] = size(img);
height = floor(sqrt(hh/ww*(hh+ww)));
width = floor(ww/hh*height);
h = fspecial('average',[height,width]);
% tic  
  gpuimg= gpuArray(img);
  mat = imfilter(gpuimg,h);
  mat = gpuimg - mat*0.9;
  mat(mat<=0) = 0;
  mat(mat~=0) = 1;
  mat = gather(mat);
% toc
end

