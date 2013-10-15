function centroids = ConvCentroids (vertex,hull)
% Compute the centroids of a given convexhull
% with its vertex and triangle faces(hull)
% based on face-area weight average


%tmp_tic = tic;

A1 = vertex(hull(:,1),:); %n*3
A2 = vertex(hull(:,2),:);
A3 = vertex(hull(:,3),:);
%store the area in Matrix every row is a face's area
Area = triangleArea3d(A1,A2,A3);
sumArea = sum(Area);
faceCenter = faceCentroids(vertex , hull);

% multiply with area weight
Area = repmat(Area,1,3);

faceCenter = faceCenter.*Area;

centroids = sum(faceCenter)./repmat(sumArea,1,3);

%tmp_toc = toc(tmp_tic);
%fprintf('Computing Centroids using time: %.2fs\n',tmp_toc);

%0.28s