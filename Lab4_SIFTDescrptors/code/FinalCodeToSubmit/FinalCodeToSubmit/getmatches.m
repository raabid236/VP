function [ result ] = getmatches( ind_1, ind_2, loc_1, loc_2, homography )
%get_ratio Summary of this function goes here
%   Detailed explanation goes here

    result = 0;

    x_1 = loc_1(ind_1, 2);
    y_1 = loc_1(ind_1, 1);

    x_2 = loc_2(ind_2, 2);
    y_2 = loc_2(ind_2, 1);

    p_original = [x_1 y_1 1];
    
    p_final    = homography * p_original';
    p_final    = p_final / p_final(3);
    l_final    = [x_2; y_2; 1];

    % check the distnace between points
    if sqrt((p_final(1) - l_final(1))^2 + (p_final(2) - l_final(2))^2) <= 1.0
        
        result = 1;

    end

end

