function costvalue = Cost(face,vertex,vertComp,vertDist,hullComp,hullDist,alpha,volume)
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

A11=vertComp(hullComp(:,1),:); 
A12=vertComp(hullComp(:,2),:);
A13=vertComp(hullComp(:,3),:);  

AreaComp = sum(triangleArea3d(A11,A12,A13));% get the area of convex hull
compact = AreaComp/(volume^(2/3));

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
distMatrix = linesMesh(line, vertDist, hullDist);


%compute bounding box
box = boundingBox3d(vertDist);
%compute diagnol
diagnol = sqrt((box(2)-box(1))^2+(box(4)-box(3))^2+(box(6)-box(5))^2);

%compute distance
distMatrix = distMatrix./diagnol;									   														

distance = sum(distMatrix .* Area)/sum(Area);

% cost function
costvalue = (1+distance)*(1+compact)^alpha; 
%tmp_toc = toc(tmp_tic);
%fprintf('Done Compute Costvalue : %.5fs\n',tmp_toc);




