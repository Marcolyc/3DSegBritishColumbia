function distance = Dist(face,vertex,hullvertex,hull,centroids) 
% 
% this function computes metric dist
% given a group of triangles compute dist(p,C(p)) 
% Li Yangchun <phantomlyc@gmail.com>

numFace = size(face,1);

A1 = vertex(face(:,1),:);
A2 = vertex(face(:,2),:);
A3 = vertex(face(:,3),:);
%store the area in Matrix every row is a face's area
Area = triangleArea3d(A1,A2,A3);
%compute Normal and centroid to get lines
normals = faceNormal( vertex,face );
center = faceCentroids( vertex,face );
line = createLine3d( center , normals(:,1) , normals(:,2), normals(:,3));
points = zeros(size(line,1),3);
faceInds = zeros(size(line,1),1);

for k = 1:size(line,1)
    [tmpP pos tmpInds] = intersectLineMesh3d(line(k,:),hullvertex,hull);
    points(k,:) = tmpP(find(abs(pos)<0.0001),:);
	faceInds(k,:) = tmpInds(find(abs(pos)<0.0001),:);
end

%compute bounding box
box = boundingBox3d(hullvertex);
%compute diagnol
diagnol = sqrt((box(2)-box(1))^2+(box(4)-box(3))^2+(box(6)-box(5))^2);

%compute distance
distMatrix = sqrt(sum((points - centroids(faceInds,:)).^2,2)); 
distMatrix = distMatrix./diagnol;									   														

distance = sum(distMatrix .* Area)/sum(Area);






