function [patchVertexId patchFaceId patchVertex] = Reseed(vertex,face,patchVertex,patchFaceId)
% This is used to get the seed between different iteration
%
%

seedNum = length(patchVertex);
alpha = 0.007;

for j = 1:seedNum   
    tmpF = face(patchFaceId{j},:);  %find which faces(3*faces)
    tmpV = patchVertex{j}; %include which vertices
	hull = convhull(tmpV);
			
	convCentroids = ConvCentroids (tmpV,hull);%get centroid of convexhull
		    
	vertexMatrix = {}; % potential seeds convexhull's vertex 
	for k = 1:length(tmpF)
	    vertexMatrix{k} = [vertex(tmpF(k,:),:);convCentroids];
	end
	
	volumeMatrix = zeros(length(tmpF),1);		
	hullMatrix = {}; % potential seeds hull
	for k = 1:length(tmpF)
	    [tmphull tmpVolume] = convhull(vertexMatrix{k});
		hullMatrix{k} = tmphull;
		volumeMatrix(k) = tmpVolume;
	end
			
	%init the cost Matrix
	costMatrix = inf(length(tmpF),1);
	%compute the costMatrix
	for i = 1:length(costMatrix)
	    costMatrix(i) = Cost(tmpF(i,:),vertex,vertexMatrix{i},tmpV...
			,hullMatrix{i},hull,alpha,volumeMatrix(i));
	end
	%find the seed Triangle seedTri is the index
    seedTriIndex = find(costMatrix == min(costMatrix));%get the indices of tmpF 
	seedTriIndex = seedTriIndex(1);
    seedTriIndex = find(ismember(face,tmpF(seedTriIndex,:),'rows'));
	        
			
    %get the seed convexhull !attention the rows and columns
    patchVertexId{j} = [face(seedTriIndex,1);face(seedTriIndex,2);face(seedTriIndex,3)];
	patchVertex{j} = [convCentroids];
	for i = 1:3
        patchVertex{j} = [patchVertex{j};vertex(patchVertexId{j}(i),:)];
	end
	patchFaceId{j} = [;seedTriIndex];

end
    
