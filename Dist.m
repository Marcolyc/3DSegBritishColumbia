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

disMatrix = zeros(numFace,1);



