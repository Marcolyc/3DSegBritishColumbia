function costvalue = Cost(face,vertex,vertComp,vertDist,hullComp,hullDist,alpha,volume,centroids)
% Cost is a function to compute the cost
% of a potential patch
% by using the functions of Dist.m and Comp.m
% face inform which faces will be used to compute
% vertex is the exact cordinate of face
% hullv is the vertex forming the convexhull
% alpha is a para to control the Costvalue
% Liyangchun <phantomlyc@gmail.com>

%tmp_tic = tic;
%compute the compactness

A1=vertComp(hullComp(:,1),:); 
A2=vertComp(hullComp(:,2),:);
A3=vertComp(hullComp(:,3),:);  

Area = sum(triangleArea3d(A1,A2,A3));% get the area of convex hull
compact = Area/(volume^(2/3));

%compute the distance
A1 = vertex(face(:,1),:);
A2 = vertex(face(:,2),:);
A3 = vertex(face(:,3),:);
%store the area in Matrix every row is a face's area
Area = triangleArea3d(A1,A2,A3);
%compute Normal and centroid to get lines
normals = normalizeVector3d(faceNormal( vertex,face ));
center = (A1+A2+A3)/3;
line = createLine3d( center , normals(:,1) , normals(:,2), normals(:,3));
points = zeros(size(line,1),3);
faceInds = zeros(size(line,1),1);

%tmp_tic = tic;
tmpT = size(line,1);
for k = 1:tmpT
    [tmpP pos tmpInds] = intersectLineMesh3d(line(k,:),vertDist,hullDist);
    points(k,:) = tmpP(find(pos>-0.0001),:);
	faceInds(k,:) = tmpInds(find(pos>-0.0001),:);
end
%tmp_toc = toc(tmp_tic);
%fprintf('Done Compute intersect : %.5fs\n',tmp_toc);

%tmp_tic = tic;
%compute bounding box
box = boundingBox3d(vertDist);
%compute diagnol
diagnol = sqrt((box(2)-box(1))^2+(box(4)-box(3))^2+(box(6)-box(5))^2);

%compute distance
distMatrix = sqrt(sum((points - centroids(faceInds,:)).^2,2)); 
distMatrix = distMatrix./diagnol;									   														

distance = sum(distMatrix .* Area)/sum(Area);

% cost function
costvalue = (1+distance)*(1+compact)^alpha; 
%tmp_toc = toc(tmp_tic);
%fprintf('Done Compute Costvalue : %.5fs\n',tmp_toc);




