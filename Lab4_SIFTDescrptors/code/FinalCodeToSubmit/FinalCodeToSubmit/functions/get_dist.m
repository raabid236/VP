function dist_est = get_dist(pointIm1XY, pointIm2XY, Hmat)

    %estimate using homography
    projpoints = project2Points(Hmat, pointIm1XY);

    % compute Euclidean distance between original and estimated points
    estDiff = projpoints- pointIm2XY;
    dist_est = sqrt(estDiff(:,1).^2 + estDiff(:,2).^2);

end

function point2dOut = project2Points(projectMat, point2dIn)
% project3to2 - function to project 2D points to 2D points

    % bind vector of ones
    nPoints = size(point2dIn, 1);
    point2d1 = [point2dIn, ones(nPoints,1)];
    % project
    point2ds = projectMat*point2d1';
    %divide points by scale s
    point2dX = point2ds(1,:)./point2ds(3,:);
    point2dY = point2ds(2,:)./point2ds(3,:);
    % save final points
    point2dOut= [point2dX; point2dY]';
end