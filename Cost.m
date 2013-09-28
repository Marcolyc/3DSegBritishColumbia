function costvalue = Cost(face,vertex,hull,alpha,v,centroids)
% Cost is a function to compute the cost
% of a potential patch
% by using the functions of Dist.m and Comp.m
% face inform which triangles will be used to compute
% hull is the current convexhull
% alpha is a para to control the Costvalue
% Liyangchun <phantomlyc@gmail.com>

%compute the centroids
compact = Comp(hull,vertex,v,centroids);
%compute the distance
distance = Dist(face,vertex,hull,centroids);

% cost function
costvalue = (1+distance)*(1+compact)^alpha; 
