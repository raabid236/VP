function [Sequence2Homographies,path] = f_zoom(im1,im2)
%Create folder
path = [pwd '\Sequence2'];
if exist(path) == 0
    mkdir(path);
end
Sequence2Homographies = struct();
save([path '\Sequence2Homographies.mat']);

% Save the reference image
imwrite(im2, [path '\Image_' num2str(00) 'a' '.png']);

%Zoom from 110% up to a 150% in increments of 5%.
zoom = 1.1;
for i = 1: 9
    % We zoom the image of size 2000 x 2000 and then crop it to size
    % 750 x 500 and save it
    B = imresize(im1,zoom);
    
    [m,n,~] = size(B);
    row_c = floor(m/2);
    col_c = floor(n/2);
    rect1 = [500,750];
    a1 =  floor(col_c - rect1(2)/2)+1;
    a2 =  floor(row_c - rect1(1)/2)+1;
    a3 = 750-1;
    a4 = 500-1;
    
    %images without noise
    img_a =  imcrop(B, [a1 a2 a3 a4]);
    imwrite(img_a, [path '\Image_' num2str(i) 'a' '.png']);
    
     img_b = imnoise(img_a,'gaussian',0,(3/255)^2);
    imwrite(img_b, [path '\Image_' num2str(i) 'b' '.png']);
    

    img_c = imnoise(img_a,'gaussian',0,(6/255)^2);
    imwrite(img_c, [path '\Image_' num2str(i) 'c' '.png']);
    
    img_d = imnoise(img_a,'gaussian',0,(18/255)^2);
    imwrite(img_d, [path '\Image_' num2str(i) 'd' '.png']);
    
    %Homography matrix
    Sequence2Homographies(i).H = inv([1 0 -750/2; 0 1 -500/2; 0 0 1]) * [zoom 0 0; 0 zoom 0; 0 0 1] * [1 0 -750/2; 0 1 -500/2; 0 0 1];
    zoom = zoom + 0.05;
end
save([path '\Sequence2Homographies.mat']);
end
