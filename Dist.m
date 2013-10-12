function distance = Dist(face,vertex,hullvertex,hull,centroids) 
% 
% this function computes metric dist
% given a group of triangles compute dist(p,C(p)) 
% Li Yangchun <phantomlyc@gmail.com>

A1 = vertex(face(:,1),:);
A2 = vertex(face(:,2),:);
A3 = vertex(face(:,3),:);
%store the area in Matrix every row is a face's area
Area = triangleArea3d(A1,A2,A3);
%compute Normal and centroid to get lines
normals = normalizeVector3d(faceNormal( vertex,face ));
center = faceCentroids( vertex,face );
line = createLine3d( center , normals(:,1) , normals(:,2), normals(:,3));
points = zeros(size(line,1),3);
faceInds = zeros(size(line,1),1);

%tmp_tic = tic;
for k = 1:size(line,1)
    [tmpP pos tmpInds] = intersectLineMesh3d(line(k,:),hullvertex,hull);
    points(k,:) = tmpP(find(pos>-0.0001),:);
	faceInds(k,:) = tmpInds(find(pos>-0.0001),:);
end
%tmp_toc = toc(tmp_tic);
%fprintf('Done Compute intersect : %.5fs\n',tmp_toc);

%tmp_tic = tic;
%compute bounding box
box = boundingBox3d(hullvertex);
%compute diagnol
diagnol = sqrt((box(2)-box(1))^2+(box(4)-box(3))^2+(box(6)-box(5))^2);

%compute distance
distMatrix = sqrt(sum((points - centroids(faceInds,:)).^2,2)); 
distMatrix = distMatrix./diagnol;									   														

distance = sum(distMatrix .* Area)/sum(Area);

%tmp_toc = toc(tmp_tic);
%fprintf('Done Compute Distance: %.5fs\n',tmp_toc);




