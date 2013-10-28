function [patchVertexId patchFaceId patchVertex] = ...
GrowPatches(patchVertexId,patchFaceId,neighbor,patchVertex,vertex,face,Dmax,alpha)
% This function is the 3rd step of Segment
% input: potential seeds: they are all cells
% output: still patchVertexId patchFaceId patchVertex
%         but they have more elements
% still needs to check convergence

segInfo = zeros(length(face),1);
faceUsed = []; %to remember which faces are used to avoid repeat
faceNeighbor = {};
vertexNeighbor = {};

for i = 1:length(patchVertex)
	%init patch group and find neighbors
	[faceNeighbor{i} vertexNeighbor{i}]= GetNeighborVertex(patchFaceId{i},patchVertexId{i},face,neighbor); %return the indices
	faceNeighbor{i} = faceNeighbor{i}(:); %form a column vector
end	

% init Used Face
for i = 1:length(patchVertex)
    faceUsed = [faceUsed;patchFaceId{i}];
	segInfo(patchFaceId{i},:) = i;
end

% delete Used face
for i = 1:length(faceNeighbor)
    faceNeighbor{i} = setdiff(faceNeighbor{i},faceUsed);
end

CostMatrix = {};
% initial CostMatrix for Neighbors
for i = 1:length(patchVertex)
    CostMatrix{i} = inf(size(vertexNeighbor{i},1),1);
end

minCost = inf(length(vertexNeighbor),1); %store the minimum of each CostMatrix	
    		
% compute the cost Matrix 
for i = 1:length(CostMatrix)
    TvertexNeighbor = vertexNeighbor{i};
	TfaceNeighbor = faceNeighbor{i};
    for j = 1:size(CostMatrix{i},1) 
	    [tmpRow ~] = find(face(TfaceNeighbor,:) == TvertexNeighbor(j));
	    tmpTriId = [patchFaceId{i};TfaceNeighbor(tmpRow,:)]; %add triangle belong to this vertex
		
	    [tmphull tmpVolume] = convhull([patchVertex{i};vertex(TvertexNeighbor(j),:)]);		
	
	    CostMatrix{i}(j) = Cost(face(tmpTriId,:),vertex,[patchVertex{i};vertex(TvertexNeighbor(j),:)]...
		                   ,[patchVertex{i};vertex(TvertexNeighbor(j),:)],tmphull,tmphull,alpha,tmpVolume);
    end
end
% compute minCost[]
for i = 1:length(CostMatrix)
    minCost(i,:) = min(CostMatrix{i});
end

% costMatrix's indices is correspondance to vertexNeighbor{i}
% get minimum and Add vertex into patch
    
while(true)	
	k = find(minCost == min(minCost)); %get minimum Indices in minCost
	k = k(randperm(length(k),1));
	k2 = find(CostMatrix{k} == min(minCost));
	k2 = k2(randperm(length(k2),1));
	
	TvertexNeighbor = vertexNeighbor{k};
	TfaceNeighbor = faceNeighbor{k};
	% find corresponding faces
	[tmpRow ~] = find(face(TfaceNeighbor,:) == TvertexNeighbor(k2));
	
    % Compute error Distance
	tmpTriId = [patchFaceId{k};TfaceNeighbor(tmpRow,:)];
	[tmphull tmpVolume] = convhull([patchVertex{k};vertex(TvertexNeighbor(k2),:)]);
	% Replacing part is as below
	%[tmphull tmpVolume] = ConvAddVertex(nowHull,patchVertex{i},vertex(vertexNeighbor(k),:),...
	%					  nowNormal,hullNeighbor,nowVolume);
			
	errorDist = Dist(face(tmpTriId,:),vertex,[patchVertex{k};vertex(TvertexNeighbor(k2),:)],tmphull);
				
	if(errorDist < Dmax)
	    % errorDist<Dmax then we have to add v to the patch
		fprintf('Current error Distance is : %.5f \n',errorDist);
        % add vertexNeighbor{k}(k2) into patchVertex{k}
		patchFaceId{k} = tmpTriId;
	    patchVertex{k} = [patchVertex{k};vertex(TvertexNeighbor(k2),:)];
	    patchVertexId{k} = [patchVertexId{k};TvertexNeighbor(k2)];
		segInfo(tmpTriId,:) = k;
				% update Used face
		faceUsed = [faceUsed;TfaceNeighbor(tmpRow,:)];	
        % find already belong to patches' triangles
		[nf nv] = GetNeighborVertex(patchFaceId{k},patchVertexId{k},face,neighbor);
		nf = nf(:);
		nf = setdiff(nf,faceUsed);
		% add already belong to patches triangles
		for nn = 1:length(nf)
		    tt = face(nf(nn),:);
			result = setdiff(tt,patchVertexId{k});
			if(isempty(result))
			    patchFaceId{k} = [patchFaceId{k};nf(nn)];
				fprintf('add one Triangle \n');
				faceUsed = [faceUsed;nf(nn)];
				segInfo(nf(nn)) = k;
			end
		end
		%%%%%% very important		
		% update vertexNeighbor{k}
		[faceNeighbor{k} vertexNeighbor{k}] = GetNeighborVertex(patchFaceId{k},patchVertexId{k},face,neighbor); %return the indices
	    faceNeighbor{k} = faceNeighbor{k}(:); %form a column vector
		faceNeighbor{k} = setdiff(faceNeighbor{k},faceUsed);
	    TvertexNeighbor = vertexNeighbor{k};
	    TfaceNeighbor = faceNeighbor{k};
		
		% update CostMatrix{k}
		CostMatrix{k} = inf(size(TvertexNeighbor,1),1);
		for i = 1:size(CostMatrix{k},1) 
	        [tmpRow ~] = find(face(TfaceNeighbor,:) == TvertexNeighbor(i));
	        tmpTriId = [patchFaceId{k};TfaceNeighbor(tmpRow,:)]; %add triangle belong to this vertex			
			
	        [tmphull tmpVolume] = convhull([patchVertex{k};vertex(TvertexNeighbor(i),:)]);
		    %[tmphull tmpVolume] = ConvAddVertex(nowHull,patchVertex{i},vertex(vertexNeighbor(k),:),...
		    %                      nowNormal,hullNeighbor,nowVolume);	
	
	        CostMatrix{k}(i) = Cost(face(tmpTriId,:),vertex,[patchVertex{k};vertex(TvertexNeighbor(i),:)]...
		                       ,[patchVertex{k};vertex(TvertexNeighbor(i),:)],tmphull,tmphull,alpha,tmpVolume);
        end
		if(length(CostMatrix{k}) == 0)
		    minCost(k,:) = inf;
		else
		% update minCost
		    minCost(k,:) = min(CostMatrix{k});
		end
	else
        % update costMatrix
        CostMatrix{k}(k2) = inf;
        % update minCost
        minCost(k,:) = min(CostMatrix{k});
    end
% check if all neighbors' error is bigger than Dmax
    if(min(minCost) == inf)
	    fprintf('All neighbor exceeds Dmax \n');
        break;
    end		
% check if all Triangles are included
    if(isempty(find(segInfo == 0)))
	    fprintf('All triangles being assigned\n');
	    break;
	end
end
