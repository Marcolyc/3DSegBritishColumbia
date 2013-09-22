function distance = Dist(face,vertex) 
% face is tmpF in SM ;vertex is tmpV in SM
% this function computes metric dist
% given a group of triangles compute dist(p,C(p)) 
% Li Yangchun <phantomlyc@gmail.com>

numFace = length(face);


A1 = vertex(face(:,1));
A2 = vertex(face(:,2));
A3 = vertex(face(:,3));
%store the area in Matrix every row is a face's area
Area = triangleArea3d(A1,A2,A3);
%compute Normal and centroid to get lines
normals = faceNormal( vertex,face );
centroids = faceCentroids( vertex,face );
lines = createLine3d( centroids , normals(:,1) , normals(:,2), normals(:,3));
[points pos faceInds] = intersectLineMesh3d(lines,vertex,face);

distMatrix = points - centroids(faceInds); %get the number $faceInds centroids 
                                                               % and compute the distance
distance = sum(distMatrix * Area)/sum(Area);



