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
		tmp_tic = tic;
		%init patch group and find neighbors
	    [faceNeighbor vertexNeighbor]= GetNeighborVertex(patchFaceId{i},patchVertexId{i},face,neighbor); %return the indices
	    faceNeighbor = faceNeighbor(:); %form a column vector
		
		% Compute the para of current hull
		%[nowHull nowVolume]= convhull(patchVertex{i}); %current patch's hull		
	    %nowNormal = faceNormal(patchVertex{i},nowHull); %current hull's normal
		%hullNeighbor = getNeighbor(nowHull');
		%hullNeighbor = hullNeighbor';
		
		
		% initial CostMatrix for Neighbors
	    tmpCostMatrix = zeros(length(vertexNeighbor),1);
        tmpLength = length(tmpCostMatrix);		
        % compute the cost Matrix 
		for k =1:tmpLength
		[tmpRow ~] = find(face(faceNeighbor,:) == vertexNeighbor(k));
	    tmpTriId = [patchFaceId{i};faceNeighbor(tmpRow,:)]; %add triangle belong to this vertex
		
		% This part is going to be replaced 
	    [tmphull tmpVolume] = convhull([patchVertex{i};vertex(vertexNeighbor(k),:)]);
		% And the replacing part is as below
		%[tmphull tmpVolume] = ConvAddVertex(nowHull,patchVertex{i},vertex(vertexNeighbor(k),:),...
		%                      nowNormal,hullNeighbor,nowVolume);
		%centroid = faceCentroids([patchVertex{i};vertex(vertexNeighbor(k),:)],tmphull);		
	
	    tmpCostMatrix(k) = Cost(face(tmpTriId,:),vertex,[patchVertex{i};vertex(vertexNeighbor(k),:)]...
		                   ,[patchVertex{i};vertex(vertexNeighbor(k),:)],tmphull,tmphull,0.07,tmpVolume);
	
        end
		%costMatrix's indices is correspondance to vertexNeighbor

				 
		%find costMatrix's min and compute its error dist
		for j = 1:tmpLength
		    k = find(tmpCostMatrix == min(tmpCostMatrix)); %get minimum Indices
		    [tmpRow ~] = find(face(faceNeighbor,:) == vertexNeighbor(k));
		    tmpTriId = [patchFaceId{i};faceNeighbor(tmpRow,:)];
			
            % This part is going to be placed			
		    [tmphull tmpVolume] = convhull([patchVertex{i};vertex(vertexNeighbor(k),:)]);
		    centroid = faceCentroids([patchVertex{i};vertex(vertexNeighbor(k),:)],tmphull);
			% Replacing part is as below
			%[tmphull tmpVolume] = ConvAddVertex(nowHull,patchVertex{i},vertex(vertexNeighbor(k),:),...
			%					  nowNormal,hullNeighbor,nowVolume);
			
		    errorDist = Dist(face(tmpTriId,:),vertex,[patchVertex{i};vertex(vertexNeighbor(k),:)],tmphull);
				
		    if(errorDist < Dmax)
	            % errorDist<Dmax then we have to add v to the patch
				fprintf('Current error Distance is : %.5f \n',errorDist);
                patchFaceId{i} = tmpTriId;
			    patchVertex{i} = [patchVertex{i};vertex(vertexNeighbor(k),:)];
			    patchVertexId{i} = [patchVertexId{i};vertexNeighbor(k)];
				terminate2 = true;
				break;
		    else
		        tmpCostMatrix(k,:) = Dmax;
		    end
		end	
        tmp_toc = toc(tmp_tic);
        fprintf('Done Add one Vertex: %.5fs\n',tmp_toc);		
	end
end