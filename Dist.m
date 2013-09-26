function distance = Dist(face,vertex,hull,centroids) 
% vertex is tmpV in SM
% this function computes metric dist
% given a group of triangles compute dist(p,C(p)) 
% Li Yangchun <phantomlyc@gmail.com>
tmp_tic = tic;

numFace = size(face,1);

A1 = vertex(face(:,1),:);
A2 = vertex(face(:,2),:);
A3 = vertex(face(:,3),:);
%store the area in Matrix every row is a face's area
Area = triangleArea3d(A1,A2,A3);
%compute Normal and centroid to get lines
normals = faceNormal( vertex,face );
center = faceCentroids( vertex,face );
lines = createLine3d( center , normals(:,1) , normals(:,2), normals(:,3));
[points pos faceInds] = intersectLineMesh3d(lines,vertex,hull);
%get rid of points not on the ray
numbers = find(pos<-0.00001);
points(numbers,:) = [];
faceInds(numbers,:) = [];

%compute bounding box
box = boundingBox3d(vertex);
%compute diagnol
diagnol = sqrt((box(2)-box(1))^2+(box(4)-box(3))^2+(box(6)-box(5))^2);

%compute distance
distMatrix = sqrt(sum((points - centroids(faceInds)).^2,2)); 
distMatrix = distMatrix.^0.5 ./diagnol;									   														

distance = sum(distMatrix .* Area)/sum(Area);

if verbose
    tmp_toc = toc(tmp_tic);
    fprintf('Computing Dist using time: %.2fs\n',tmp_toc);
end


