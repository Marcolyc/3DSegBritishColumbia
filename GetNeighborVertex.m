function [NeighborTriangle NeighborVertex] = ...
GetNeighborVertex( TriId,patchId,face,neighbor )
% This function is used to get neighbors of current patch
% input 
% the indices of current patch's vertex
% Triangle Id of current patch
% return the NeighborVertex's indices in Vertex
% Li Yangchun <phantomlyc@gmail.com>

tmp_tic = tic;
tmpNeighbor = neighbor(TriId,:) ; % Triface k*3 neighbor triangles 
NeighborTriangle = setdiff(unique(tmpNeighbor(:,:)),TriId); %get rid of the repeat ones but just indices

tmpNeighborVertex = face(NeighborTriangle,:);
tmpNeighborVertex = unique(tmpNeighborVertex(:,:));
NeighborVertex = setdiff(tmpNeighborVertex , patchId); %find neighbor Vertex

tmp_toc = toc(tmp_tic);
fprintf('Done finding neighbors : %.2fs\n',tmp_toc);