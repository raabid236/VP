function [im1,im2,imx,imy]=cropimage(im)

% Creating a smaller image of size 2000 x 2000 in the center of the
% original image
[m,n,~] = size(im);
row_c = floor(m/2);
col_c = floor(n/2);
rect1 = [2000,2000];
a1 =  floor(col_c - rect1(2)/2)+1;
a2 =  floor(row_c - rect1(1)/2)+1;
a3 = 2000-1;
a4 = 2000-1;
im1 =  imcrop(im, [a1 a2 a3 a4]);

% Creating the reference image of size 750 x 500 in the center of the
% original image
[m,n,c] = size(im1);
row_c = floor(m/2);
col_c = floor(n/2);
rect1 = [500,750];
a1 =  floor(col_c - rect1(2)/2)+1;
a2 =  floor(row_c - rect1(1)/2)+1;
a3 = 750-1;
a4 = 500-1;
im2 =  imcrop(im1, [a1 a2 a3 a4]);

% Creating the reference image of size 1000 x 500 in the center of the
% original image
[m,n,c] = size(im1);
row_c = floor(m/2);
col_c = floor(n/2);
rect1 = [500,950];
a1 =  floor(col_c - rect1(2)/2)+1;
a2 =  floor(row_c - rect1(1)/2)+1;
a3 = 950-1;
a4 = 500-1;
imx =  imcrop(im1, [a1 a2 a3 a4]);

% Ref image of size 750 x 700 in the center
[m,n,c] = size(im1);
row_c = floor(m/2);
col_c = floor(n/2);
rect1 = [700,750];
a1 =  floor(col_c - rect1(2)/2)+1;
a2 =  floor(row_c - rect1(1)/2)+1;
a3 = 750-1;
a4 = 700-1;
imy =  imcrop(im1, [a1 a2 a3 a4]);

