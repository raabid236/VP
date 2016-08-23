%Visual Perception
%Lab 1: Harris Corner Detector
%Author: Raabid Hussain
%Note: Write the address of the image on line 10
close all;
clear;
clc;

%Image name (In order to change the image, give the address of the new image)
filename='chessboard03.png';

%Reading image and changing it to RGB
im = imread(filename);
im_orig = im;
if size(im,3)>1
    im=rgb2gray(im); 
end

% Derivative masks
dx = [-1 0 1; -1 0 1; -1 0 1];
dy = dx';

% Image derivatives
Ix = conv2(double(im), dx, 'same');
Iy = conv2(double(im), dy, 'same');
sigma=2;

% Generate Gaussian filter of size 9x9 and std. dev. sigma.
g = fspecial('gaussian',9, sigma);

% Smoothed squared image derivatives
Ix2 = conv2(Ix.^2, g, 'same');
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');

%Summing for elements of M
WIx2=conv2(Ix2,ones(3),'same');
WIxy=conv2(Ixy,ones(3),'same');
WIy2=conv2(Iy2,ones(3),'same');
[m,n]=size(Ix2);
tic;

%calculating E (min eigen values)
for i=1:m
    for j=1:n
        [~,e]=eig([WIx2(i,j) WIxy(i,j); WIxy(i,j) WIy2(i,j)]);
        E(i,j)=min(e*[1;1]);
    end
end
%time consumed
timeE=toc

%calculating R (Determinant and trace)
tic;
for i=1:m
    for j=1:n
        d=WIx2(i,j)*WIy2(i,j)-WIxy(i,j)*WIxy(i,j);
        t=0.04*(WIx2(i,j)+WIy2(i,j)).^2;
        R(i,j)=d-t;
    end
end
%time consumed
timeR=toc

%Displaying the outputs
imshow(mat2gray(E));
title('E matrix');
figure;
imshow(mat2gray(R));
title('R matrix');

%Duplicating E and R
E1=E;
R1=R;
%creating structures to store corner points for maximal suppression and sub
%pixel accuracy for both E and R
featuresE(81)=struct('p_x',[],'p_y',[]);
featuresR(81)=struct('p_x',[],'p_y',[]);
featuresEs(81)=struct('p_x',[],'p_y',[]);
featuresRs(81)=struct('p_x',[],'p_y',[]);

%Extracting 81 most salient points from E
for i=1:81
    maxE1=max(max(E1));
    [row,col] = find(E1==maxE1);
    featuresE(i).p_x=row;
    featuresE(i).p_y=col;
    E1(row,col)=-inf;
end
%Displaying salient points on original image
figure; imshow(im_orig); hold on;
title('E-most salient points');
for i=1:size(featuresE,2),
    plot(featuresE(i).p_y, featuresE(i).p_x, 'r+');
end

%Extracting 81 most salient points from E
for i=1:81
    maxR1=max(max(R1));
    [row,col] = find(R1==maxR1);
    featuresR(i).p_x=row;
    featuresR(i).p_y=col;
    R1(row,col)=-inf;
end
%Displaying salient points on original image
figure; imshow(im_orig); hold on;
title('R-most salient points');
for i=1:size(featuresR,2),
    plot(featuresR(i).p_y, featuresR(i).p_x, 'r+');
end

%Duplicating E and R again as E1 and R1 have changed
E1=E;
R1=R;

%calculating maximal suppressed and sub pixel accurate points for E
for i=1:81
    maxE1=0;
%Loop until a global maxima found    
    while(1);
%Finding the most salient point
        maxE1=max(max(E1));
        [row,col] = find(E1==maxE1);
%is the max weightage point a local maxima too around its neighborhood?        
            if E1(row+1,col)== -inf | E1(row-1,col)== -inf | E1(row,col-1)== -inf | E1(row,col+1)== -inf | E1(row-1,col-1)== -inf | E1(row+1,col-1)== -inf | E1(row+1,col+1)== -inf | E1(row-1,col+1)== -inf
                E1(row,col)=-inf;
                continue;
            end
            break;
    end
%saving the pixel in the structure
    featuresE(i).p_x=row;
    featuresE(i).p_y=col;
%opening the 11x11 window (later it was changed to 17x17 due to chessboard03 image)
    rowmax=row+8;
    colmax=col+8;
    rowmin=row-8;
    colmin=col-8;
%reducing the neighborhood if it exceeds image size
    if rowmax>m
        rowmax=m;
    end
    if rowmin<1
        rowmin=1;
    end
    if colmax>n
        colmax=n;
    end
    if colmin<1
        colmin=1;
    end
%sub-pixel accuracy through linear least squares (more weightage given to local maxima)
    A=[row*row col*col (row)*(col) row col 1; row*row col*col (row)*(col) row col 1; row*row col*col (row)*(col) row col 1; row*row col*col (row)*(col) row col 1; (row-1)*(row-1) (col-1)*(col-1) (row-1)*(col-1) row-1 col-1 1; (row-1)*(row-1) col*col (row-1)*(col) row-1 col 1; (row-1)*(row-1) (col+1)*(col+1) (row-1)*(col+1) row-1 col+1 1; row*row (col-1)*(col-1) (row)*(col-1) row col-1 1; row*row col*col (row)*(col) row col 1; row*row (col+1)*(col+1) (row)*(col+1) row col+1 1; (row+1)*(row+1) (col-1)*(col-1) (row+1)*(col-1) row+1 col-1 1; (row+1)*(row+1) col*col (row+1)*(col) row+1 col 1; (row+1)*(row+1) (col+1)*(col+1) (row+1)*(col+1) row+1 col+1 1];
    b=[E1(row,col) E1(row,col) E1(row,col) E1(row,col) E1(row-1,col-1) E1(row-1,col) E1(row-1,col+1) E1(row,col-1) E1(row,col) E1(row,col+1) E1(row+1,col-1) E1(row+1,col) E1(row+1,col+1)]';
    Y=A\b;
%taking negative of the equation as no inbuilt function for maxima in my
%MATLAB version
    f=@(x)-(Y(1).*x(1).*x(1) + Y(2).*x(2).*x(2) + Y(3).*x(1).*x(2) + Y(4).*x(1) + Y(5).*x(2) + Y(6));
%finding maxima (minima) and storing it into the structure
    sub=fminsearch(f,[row col]);
    featuresEs(i).p_x=sub(1);
    featuresEs(i).p_y=sub(2);
%Eliminating the 17x17 neighbors
    E1(rowmin:rowmax,colmin:colmax)=-inf;        
end

%Displaying the result for maximal suppression
figure;imshow(im_orig);hold on
title('E81 - maximal suppression');
for i=1:size(featuresE,2),
    plot(featuresE(i).p_y, featuresE(i).p_x, 'r+');
end

%calculating maximal suppressed and sub pixel accurate points for R
for i=1:81
    maxR1=0;
%Loop until a global maxima found    
    while(1);
%Finding the most salient point
    maxR1=max(max(R1));
    [row,col] = find(R1==maxR1);
%is the max weightage point a local maxima too around its neighborhood?        
        if R1(row+1,col)== -inf | R1(row-1,col)== -inf | R1(row,col-1)== -inf | R1(row,col+1)== -inf | R1(row-1,col-1)== -inf | R1(row+1,col-1)== -inf | R1(row+1,col+1)== -inf | R1(row-1,col+1)== -inf
            R1(row,col)=-inf;
            continue;
        end
        break;
    end
%saving the pixel in the structure
    featuresR(i).p_x=row;
    featuresR(i).p_y=col;
%opening the 11x11 window (later it was changed to 17x17 due to chessboard03 image)
    rowmax=row+8;
    colmax=col+8;
    rowmin=row-8;
    colmin=col-8;
%reducing the neighborhood if it exceeds image size
    if rowmax>m
        rowmax=m;
    end
    if rowmin<1
        rowmin=1;
    end
    if colmax>n
        colmax=n;
    end
    if colmin<1
        colmin=1;
    end
%sub-pixel accuracy through linear least squares (more weightage given to local maxima)
    A=[(row-1)*(row-1) (col-1)*(col-1) (row-1)*(col-1) row-1 col-1 1; (row-1)*(row-1) col*col (row-1)*(col) row-1 col 1; (row-1)*(row-1) (col+1)*(col+1) (row-1)*(col+1) row-1 col+1 1; row*row (col-1)*(col-1) (row)*(col-1) row col-1 1; row*row col*col (row)*(col) row col 1; row*row (col+1)*(col+1) (row)*(col+1) row col+1 1; (row+1)*(row+1) (col-1)*(col-1) (row+1)*(col-1) row+1 col-1 1; (row+1)*(row+1) col*col (row+1)*(col) row+1 col 1; (row+1)*(row+1) (col+1)*(col+1) (row+1)*(col+1) row+1 col+1 1];
    b=[R1(row-1,col-1) R1(row-1,col) R1(row-1,col+1) R1(row,col-1) R1(row,col) R1(row,col+1) R1(row+1,col-1) R1(row+1,col) R1(row+1,col+1)]';
    Y=A\b;
%taking negative of the equation as no inbuilt function for maxima in my
%MATLAB version
    f=@(x)-(Y(1).*x(1).*x(1) + Y(2).*x(2).*x(2) + Y(3).*x(1).*x(2) + Y(4).*x(1) + Y(5).*x(2) + Y(6));
%finding maxima (minima) and storing it into the structure
    sub=fminsearch(f,[row col]);
    featuresRs(i).p_x=sub(1);
    featuresRs(i).p_y=sub(2);
%Eliminating the 17x17 neighbors
    R1(rowmin:rowmax,colmin:colmax)=-inf;        
end

%Displaying the result for maximal suppression
figure; imshow(im_orig);hold on;
title('R81 - maximal suppression');
for i=1:size(featuresR,2),
    plot(featuresR(i).p_y, featuresR(i).p_x, 'r+');
end

%Displaying the both subpixel E and maximal suppressed E together
figure;hold on;
title('E - with and without subpixel accuracy');
for i=1:size(featuresR,2),
    plot(featuresE(i).p_y, featuresE(i).p_x, 'r+');
    plot(featuresEs(i).p_y, featuresEs(i).p_x, 'o');
end

%Displaying the both subpixel E and maximal suppressed R together
figure;hold on;
title('R - with and without subpixel accuracy');
for i=1:size(featuresR,2),
    plot(featuresR(i).p_y, featuresR(i).p_x, 'r+');
    plot(featuresRs(i).p_y, featuresRs(i).p_x, 'o');
end
