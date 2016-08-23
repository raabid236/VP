function [Sequence1Homographies] = f_projective(im,imx,imy)

path = [pwd '\Sequence1'];
if exist(path) == 0
    mkdir(path);
end
Sequence1Homographies = struct();
save([path '\Sequence1Homographies.mat']);

imwrite(im, [path '\Image_' num2str(00) 'a' '.png']);

offset = 25;
for k = 1: 16
    % This homography contains only positive coordinates to suit (imagewrap) function
     if (1 <= k) && (k <= 4)
        im2 = imx;
        coord1(1,:) = [1-offset+100 1];
        coord1(2,:) = [100 size(im2,1)];
        coord1(3,:) = [size(im2,2)-100 size(im2,1)];
        coord1(4,:) = [size(im2,2)+offset-100 1];
        coord2(1,:) = [100 1];
        coord2(2,:) = [100 size(im2,1)];
        coord2(3,:) = [size(im2,2)-100 size(im2,1)];
        coord2(4,:) = [size(im2,2)-100 1];
    elseif (5 <= k) && (k <= 8)
        im2 = imx;
        coord1(1,:) = [100 1];
        coord1(2,:) = [1-offset+100 size(im2,1)];
        coord1(3,:) = [size(im2,2)+offset-100 size(im2,1)];
        coord1(4,:) = [size(im2,2)-100 1];
        coord2(1,:) = [100 1];
        coord2(2,:) = [100 size(im2,1)];
        coord2(3,:) = [size(im2,2)-100 size(im2,1)];
        coord2(4,:) = [size(im2,2)-100 1];
    elseif (9 <= k) && (k <= 12)
        im2 = imy;
        coord1(1,:) = [1 1-offset+100];
        coord1(2,:) = [1 size(im2,1)+offset-100];
        coord1(3,:) = [size(im2,2) size(im2,1)-100];
        coord1(4,:) = [size(im2,2) 100];
        coord2(1,:) = [1 100];
        coord2(2,:) = [1 size(im2,1)-100];
        coord2(3,:) = [size(im2,2) size(im2,1)-100];
        coord2(4,:) = [size(im2,2) 100];
    elseif (13 <= k) && (k <= 16)
        im2 = imy;
        coord1(1,:) = [1 100];
        coord1(2,:) = [1 size(im2,1)-100];
        coord1(3,:) = [size(im2,2) size(im2,1)+offset-100];
        coord1(4,:) = [size(im2,2) 1-offset+100];
        coord2(1,:) = [1 100];
        coord2(2,:) = [1 size(im2,1)-100];
        coord2(3,:) = [size(im2,2) size(im2,1)-100];
        coord2(4,:) = [size(im2,2) 100];
    end
    
    tform=fitgeotrans(coord1,coord2,'projective');
    proj=tform.T;
    H = proj;

    B = imwarp(im2,tform);

    [m,n,~] = size(B);
    row_c = floor(m/2);
    col_c = floor(n/2);
    rect1 = [500,750];
    a1 =  floor(col_c - rect1(2)/2)+1;
    a2 =  floor(row_c - rect1(1)/2)+1;
    a3 = 750-1;
    a4 = 500-1;
    
    % Creating the set (a) of images without noise
    img_a =  imcrop(B, [a1 a2 a3 a4]);
    imwrite(img_a, [path '/Image_' num2str(k) 'a' '.png']);
    
    % 0-mean Gaussian noise with standard deviation of 3 grayscale values,
    im_b = imnoise(img_a,'gaussian',0,(3/255)^2);
    imwrite(im_b, [path '/Image_' num2str(k) 'b' '.png']);
    
    % Creating the set (c) of images that has additive 0-mean Gaussian
    % noise with standard deviation of 6 grayscale values,
    im_c = imnoise(img_a,'gaussian',0,(6/255)^2);
    imwrite(im_c, [path '/Image_' num2str(k) 'c' '.png']);
    
    % Creating the set (d) of images that has additive 0-mean Gaussian
    % noise with standard deviation of 18 grayscale values,
    im_d = imnoise(img_a,'gaussian',0,(18/255)^2);
    imwrite(im_d, [path '/Image_' num2str(k) 'd' '.png']);
    
    if offset >= 100
        offset = 25;
    else
        offset = offset + 25;
    end 
end

offset = 25;
for k = 1: 16
    % Creating the homography matrix for matching the points
    % This homography contains negative coordinates
     if (1 <= k) && (k <= 4)
        im2 = im;
        coord1(1,:) = [1-offset 1];
        coord1(2,:) = [1 size(im2,1)];
        coord1(3,:) = [size(im2,2) size(im2,1)];
        coord1(4,:) = [size(im2,2)+offset 1];
        coord2(1,:) = [1 1];
        coord2(2,:) = [1 size(im2,1)];
        coord2(3,:) = [size(im2,2) size(im2,1)];
        coord2(4,:) = [size(im2,2) 1];
    elseif (5 <= k) && (k <= 8)
        im2 = im;
        coord1(1,:) = [1 1];
        coord1(2,:) = [1-offset size(im2,1)];
        coord1(3,:) = [size(im2,2)+offset size(im2,1)];
        coord1(4,:) = [size(im2,2) 1];
        coord2(1,:) = [1 1];
        coord2(2,:) = [1 size(im2,1)];
        coord2(3,:) = [size(im2,2) size(im2,1)];
        coord2(4,:) = [size(im2,2) 1];
    elseif (9 <= k) && (k <= 12)
        im2 = im;
        coord1(1,:) = [1 1-offset];
        coord1(2,:) = [1 size(im2,1)+offset];
        coord1(3,:) = [size(im2,2) size(im2,1)];
        coord1(4,:) = [size(im2,2) 1];
        coord2(1,:) = [1 1];
        coord2(2,:) = [1 size(im2,1)];
        coord2(3,:) = [size(im2,2) size(im2,1)];
        coord2(4,:) = [size(im2,2) 1];
    elseif (13 <= k) && (k <= 16)
        im2 = im;
        coord1(1,:) = [1 1];
        coord1(2,:) = [1 size(im2,1)];
        coord1(3,:) = [size(im2,2) size(im2,1)+offset];
        coord1(4,:) = [size(im2,2) 1-offset];
        coord2(1,:) = [1 1];
        coord2(2,:) = [1 size(im2,1)];
        coord2(3,:) = [size(im2,2) size(im2,1)];
        coord2(4,:) = [size(im2,2) 1];
    end
%     

 
%     
    tform=fitgeotrans(coord1,coord2,'projective');
    proj=tform.T;
    proj(1,3)=proj(1,3);
    H = proj'

    % Creating the homography matrix
    Sequence1Homographies(k).H = H;
    
    if offset >= 100
        offset = 25;
    else
        offset = offset + 25;
    end 
end
save([path '/Sequence1Homographies.mat']);
end