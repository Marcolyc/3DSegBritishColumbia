function [patchVertexId patchFaceId patchVertex] = ...
GrowPatches(patchVertexId,patchFaceId,neighbor,patchVertex,vertex,face,Dmax)
% This function is the 3rd step of Segment
% input: potential seeds: they are all cells
% output: still patchVertexId patchFaceId patchVertex
%         but they have more elements
% still needs to check convergence
for i = 1:length(patchVertex)
	terminate2 = true; % used to test stop
	while(terminate2)
		terminate2 = false;
		%init patch group and find neighbors
	    [faceNeighbor vertexNeighbor]= GetNeighborVertex(patchFaceId{i},patchVertexId{i},face,neighbor); %return the indices
	    faceNeighbor = faceNeighbor(:); %form a column vector
				
	    % initial CostMatrix for Neighbors
	    tmpCostMatrix = zeros(length(vertexNeighbor),1);				
        % compute the cost Matrix 
		for k =1:length(tmpCostMatrix)
		[tmpRow ~] = find(face(faceNeighbor,:) == vertexNeighbor(k));
	    tmpTriId = [patchFaceId{i};faceNeighbor(tmpRow,:)]; %add triangle belong to this vertex
					
	    [tmphull tmpVolume] = convhulln([patchVertex{i};vertex(vertexNeighbor(k),:)]);
		centroid = faceCentroids([patchVertex{i};vertex(vertexNeighbor(k),:)],tmphull);
		
	    tmpCostMatrix(k) = Cost(face(tmpTriId,:),vertex,[patchVertex{i};vertex(vertexNeighbor(k),:)]...
		                   ,[patchVertex{i};vertex(vertexNeighbor(k),:)],tmphull,tmphull,0.07,tmpVolume,centroid);
        end
		%costMatrix's indices is correspondance to vertexNeighbor
				 
		%find costMatrix's min and compute its error dist
		for j = 1:length(tmpCostMatrix)
		    k=find(tmpCostMatrix == min(tmpCostMatrix)); %get minimum Indices
		    [tmpRow ~] = find(face(faceNeighbor,:) == vertexNeighbor(k));
		    tmpTriId = [patchFaceId{i};faceNeighbor(tmpRow,:)];
				
		    [tmphull tmpVolume] = convhulln([patchVertex{i};vertex(vertexNeighbor(k),:)]);
		    centroid = faceCentroids([patchVertex{i};vertex(vertexNeighbor(k),:)],tmphull);
				
		    errorDist = Dist(face(tmpTriId,:),vertex,[patchVertex{i};vertex(vertexNeighbor(k),:)],tmphull,centroid);
				
		    if(errorDist < Dmax)
	            % errorDist<Dmax then we have to add v to the patch
				fprintf('Current error Distance is : %.2f \n',errorDist);
                patchFaceId{i} = tmpTriId;
			    patchVertex{i} = [patchVertex{i};vertex(vertexNeighbor(k),:)];
			    patchVertexId{i} = [patchVertexId{i};vertexNeighbor(k)];
				terminate2 = true;
				break;
		    else
		        tmpCostMatrix(k,:) = Dmax;
		    end
		end				
	end
end