
clear all;
close all; clc;

orgim = imread('Image_base_050.jpg');
[img1,img2,ref_img1,ref_img2]=cropimage(orgim);


%% Step 1
%% Zoom :COmment or Uncomment for zoom
[Sequence2Homographies,path2] = f_zoom(img1,img2);

% Checking the homography matrix of the rotation

Image_00a = imread(fullfile(path2,'Image_0a.png'));
Image_4a = imread(fullfile(path2,'Image_4a.png'));

p_00 = [316 290 1];
p_04 = Sequence2Homographies(4).H * p_00'

figure(3); imshow(Image_00a); impixelinfo; hold on;
plot(p_00(1), p_00(2), 'gx');

figure(4); imshow(Image_4a); impixelinfo; hold on;
plot(p_04(1), p_04(2), 'rx');


%% Rotation : Comment or Uncomment for rotation
[Sequence3Homographies] = f_rotation(img1,img2);
% 
% Checking the homography matrix of the rotation
Image_00a = imread(fullfile(path2,'Image_00a.png'));
Image_4a = imread(fullfile(path2,'Image_4a.png'));

p_00 = [316 290 1];
p_04 = Sequence3Homographies(4).H * p_00';

figure(1); imshow(Image_00a); impixelinfo; hold on;
plot(p_00(1), p_00(2), 'gx');

figure(2); imshow(Image_4a); impixelinfo; hold on;
plot(p_04(1), p_04(2), 'rx');




%% Comment or uncomment for Projective sequence

%Projective
[Sequence1Homographies] = f_projective(img2,ref_img1,ref_img2);

Checking the homography matrix of the rotation
Image_0a = imread([pwd '/Sequence1/Image_0a.png']);
Image_4a = imread([pwd '/Sequence1/Image_4a.png']);

% p_00 = [635 303 1];
p_00 = [316 290 1];
p_04 = Sequence1Homographies(4).H * p_00';
p_04 = p_04/p_04(3);

figure(5); imshow(Image_0a); impixelinfo; hold on;
plot(p_00(1), p_00(2), 'g*');

figure(6); imshow(Image_4a); impixelinfo; hold on;
plot(p_04(1), p_04(2), 'r*');
%{%}


%%---------------------------------------------------------------
%% Step 2
%% SIFT Results
% Projective
path = [pwd '/Sequence1/Sequence1Homographies.mat'];
draw_graph( path, 1, 16 )


% zoom
path = [pwd '\Sequence2\Sequence2Homographies.mat'];
draw_graph( path, 2, 9)
sum(time)

% Rotation
path = [pwd '\Sequence3\Sequence3Homographies.mat'];
draw_graph( path, 3, 18)

%% Step 3

%% Comment or Uncomment for Modified desrcriptor
%Modified descriptor
step3run
step3plots

