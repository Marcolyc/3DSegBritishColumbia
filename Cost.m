function costvalue = Cost(face,vertex,vertComp,vertDist,hullComp,hullDist,alpha,volume,centroids)
% Cost is a function to compute the cost
% of a potential patch
% by using the functions of Dist.m and Comp.m
% face inform which faces will be used to compute
% vertex is the exact cordinate of face
% hullv is the vertex forming the convexhull
% alpha is a para to control the Costvalue
% Liyangchun <phantomlyc@gmail.com>

%compute the compactness
compact = Comp(hullComp,vertComp,volume,centroids);
%compute the distance
distance = Dist(face,vertex,vertDist,hullDist,centroids);

% cost function
costvalue = (1+distance)*(1+compact)^alpha; 
