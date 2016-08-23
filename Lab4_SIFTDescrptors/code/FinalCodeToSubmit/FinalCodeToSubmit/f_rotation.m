function [Sequence3Homographies] = f_rotation(im1,im2)

% Creating the folder that contains the images and the homography matrix
path = [pwd '\Sequence3'];
if exist(path) == 0
    mkdir(path);
end
Sequence3Homographies = struct();
save([path '\Sequence3Homographies.mat']);
    
% Save the reference image
imwrite(im2, [path '\Image_' num2str(00) 'a' '.png']);

%% -45 to 45 deg in step of 5
k = 1;
for i = -45 : 5 : 45
    if i ~= 0
        B = imrotate(im1,-i,'crop');
        
        [m,n,~] = size(B);
        row_c = floor(m/2);
        col_c = floor(n/2);
        rect1 = [500,750];
        a1 =  floor(col_c - rect1(2)/2)+1;
        a2 =  floor(row_c - rect1(1)/2)+1;
        a3 = 750-1;
        a4 = 500-1;
        
        % No noise
        im_a =  imcrop(B, [a1 a2 a3 a4]);
        imwrite(im_a, [path '\Image_' num2str(k) 'a' '.png']);
        %3 grayscale noise
        im_b = imnoise(im_a,'gaussian',0,(3/255)^2);
        imwrite(im_b, [path '\Image_' num2str(k) 'b' '.png']);
        %6 grayscale noise
        im_c = imnoise(im_a,'gaussian',0,(6/255)^2);
        imwrite(im_c, [path '\Image_' num2str(k) 'c' '.png']);
        %18 grayscale noise
        im_d = imnoise(im_a,'gaussian',0,(18/255)^2);
        imwrite(im_d, [path '\Image_' num2str(k) 'd' '.png']);
        
        % Creating the corresponding homography matrix
        theta = i * pi / 180;
        Sequence3Homographies(k).H = inv([1 0 -750/2; 0 1 -500/2; 0 0 1]) * [cos(theta) -sin(theta) 0;sin(theta) cos(theta) 0;0 0 1] * [1 0 -750/2; 0 1 -500/2; 0 0 1];
        
        k = k + 1;
    end
end
save([path '\Sequence3Homographies.mat']);
end