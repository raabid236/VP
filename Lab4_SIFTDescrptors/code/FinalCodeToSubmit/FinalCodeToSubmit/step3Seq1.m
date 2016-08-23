
clc; clear all; close all;
% add path to sift 
run('vlfeat/toolbox/vl_setup')
addpath('functions');
% path of images
pathIm = 'Sequence1';
% load noise and geometry
load par_noise_seq
load binSize
geometry = [4 4 8];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load homographies
seq1homo = [pathIm, 'Homographies'];
load(fullfile(pathIm, [seq1homo, '.mat']) );
allHomographies = eval(seq1homo);
clear(seq1homo);

% read original image (reference image)
im1Name = fullfile(pathIm, 'Image_0a.png');
im1 = imread( im1Name);
%convert to single grayscale
im1 = single(rgb2gray(im1));
% get original image size (for centering points)
im1SizeXY= [size(im1,2), size(im1,1)];
% taking floor half size for offset
im1SizeXYHalf = floor(im1SizeXY/2);

% setup descriptor Parameters
step = 7;
%binSize = 5;
magnif = 1;

% smooth image
im1Smooth = vl_imsmooth(im1, sqrt((binSize/magnif)^2 - .25));
% extract features locations and descriptors
[im1l, im1d] = vl_dsift(im1Smooth, 'Geometry', geometry, 'Size', binSize, 'Step', step);

% transform indexes
transformArray = 1:16;
numOfTransforms = numel(transformArray);

imageIndex = 4;
for imageIndex =1:numOfTransforms

    % form transformed image filename for reading
    if imageIndex<10
        im2FileName = strcat('Image_', num2str(imageIndex), noiseSequence,'.png');
    else
        im2FileName = strcat('Image_', num2str(imageIndex), noiseSequence,'.png');
    end
    im2Name = fullfile(pathIm, im2FileName);
	
    disp(sprintf('Processing image: "%s", ii=%d/%d', im2Name, imageIndex, numOfTransforms));

    im2 = imread( im2Name);
    %convert to single grayscale
    im2 = single(rgb2gray(im2));
    
    % smooth image
    im2Smooth = vl_imsmooth(im2, sqrt((binSize/magnif)^2 - .25));
    % extract features locations and descriptors
    [im2l, im2d] = vl_dsift(im2Smooth, 'Geometry', geometry, 'Size', binSize, 'Step', step);
  
    disp(sprintf('Finding matches...'));
    % FIND matches, orig descriptor
    matchPos = vl_ubcmatch(im1d, im2d);
    %[MATCHES,SCORES] = vl_ubcmatch(im1d, im2d);
    % get matched locations of keypoints, transpose
    loc1XY = im1l(:,matchPos(1,:))';
    loc2XY = im2l(:,matchPos(2,:))';
    
    currentMatH = allHomographies(imageIndex).H;
    % estimate distances
    e_dist = get_dist(loc1XY, loc2XY, currentMatH);
    
    % save estimated distances
    e_dist_all{imageIndex} = e_dist;
  
   
end

save(fullfile('output', strcat('e_dist_',pathIm, '_', num2str(binSize, '%d'), '_', noiseSequence)), 'e_dist_all');

