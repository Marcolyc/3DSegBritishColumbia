function centroids = ConvCentroids (vertex,hull)
% Compute the centroids of a given convexhull
% with its vertex and triangle faces(hull)
% based on face-area weight average
tmp_tic = tic;

numV = length(vertex);

A1 = vertex(hull(:,1),:); %n*3
A2 = vertex(hull(:,2),:);
A3 = vertex(hull(:,3),:);
%store the area in Matrix every row is a face's area
Area = triangleArea3d(A1,A2,A3);

faceCenter = faceCentroids(vertex , hull);

% multiply with area weight
for i=1:length(Area)
    faceCenter(i,:) = faceCenter(i,:)*Area(i);
end

centroids = mean(faceCenter);

tmp_toc = toc(tmp_tic);
fprintf('Computing Centroids using time: %.2fs\n',tmp_toc);

%0.28s