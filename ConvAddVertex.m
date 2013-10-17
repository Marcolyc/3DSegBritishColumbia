function [newHull newVolume] = ConvAddVertex(hull,vertex,newV,normals,neighbor,volume)
% This function is used to add one vertex to a existed 
% Convex hull
% function is created in order to save time
%
% hull stores vertex of one face in counter-clockwise order 
% to make sure that normal is pointing outside of convex hull
% hullC is the center of convexhull to correct direction
%
% Function finally returns a newHull
% Li Yangchun   <phantomlyc@gmail.com>

% first search the visible faces
% init the vector Matrix
tmpTic = tic;
newV = repmat(newV,length(hull),1);
v = newV - vertex(hull(:,3),:);
numV = length(vertex); %num of vertex 
newIndice = numV+1;%newV's indice is numV+1
newVolume = volume;

visible = dot(v,normals,2);
% visible(i)>0 means visible 

visibleFace = find(visible > 0); %indice of visible
invisibleFace = find(visible<=0); %indice of invisible
newHull = hull;
% delete the visible Face
newHull(visibleFace,:) = [];

if(~isempty(visibleFace))
    for i = 1:length(visibleFace)
	    tmpV = [vertex(hull(visibleFace(i),:),:);newV];
		newVolume = newVolume + tetrahedronVolume(tmpV);
	    for j= 1:3
	        tmp = find(invisibleFace == neighbor(visibleFace(i),j));
            if(~isempty(tmp))
	        % get the edge of horizon 
		    [h ia] = intersect(hull(visibleFace(i),:),hull(invisibleFace(tmp),:),'stable');
			if(ia == [1;3])
			    newHull = [newHull;h(1),newIndice,h(2)];
			else
			% add new triangles
		    h = [h,newIndice];
		    newHull = [newHull;h];
	        end
			end
		end
	end
end

tmpToc = toc(tmpTic);
fprintf('Done Compute New Convex : %.5fs\n',tmpToc);
	

