function [compactness centroid] = comp(vertex)
%This function calculates a convexHull's compactness
%input:vertex in 3*num store vertex's cordinates
%  
%output : area(C)/volume(C)^(2/3)                     
% Li Yangchun <phantomlyc@gmail.com>

[hull v] = convhulln(tmpV); %get triangles and volume 
centroid = polyhedronCentroid(vertex, hull); %get the centroid of convexhull

%Matrix of three vertices of one triangle in hull
A1=vertex(hull(:,1)); 
A2=vertex(hull(:,2));
A3=vertex(hull(:,3));  

Area = sum(triangleArea3d(A1,A2,A3));% get the area of convex hull

compactness = Area/(v^(2/3));



