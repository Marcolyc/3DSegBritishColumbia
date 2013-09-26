function [NeighborTriangle NeighborVertex] = ...
GetNeighborVertex( TriId,patchId,face,neighbor )
% This function is used to get neighbors of current patch
% input 
% the indices of current patch's vertex
% Triangle Id of current patch
% return the NeighborVertex's indices in Vertex
% Li Yangchun <phantomlyc@gmail.com>

tmpNeighbor = neighbor(TriId,:) ; % Triface k*3 neighbor triangles 
NeighborTriangle = unique(tmpNeighbor(:,:)); %get rid of the repeat ones but just indices

tmpNeighborVertex = face(NeighborTriangle,:);
tmpNeighborVertex = unique(tmpNeighborVertex(:,:));
NeighborVertex = setdiff(tmpNeighborVertex , patchId); %find neighbor Vertex