function [patchVertexId patchFaceId patchVertex] = Findseeds(segInfo,face,vertex)
% This function is the second stage of segment
% Given the segInfo which gives information of potential patch
% We find seeds for each potential patch
% output is patchVertexId{} which stores VertexId in vertex
%           patchFaceId{} which stores faceId in face
%           patchVertex{} which stores exact cordinate
%           Typically patchVertexId is 3*1 patchFaceId is 1*1
% Li Yangchun    <phantomlyc@gmail.com>

tmp_tic = tic;
alpha =0.07;

segNum = length(unique(segInfo(:,:))); 
for j = 1:segNum
	faceId{j} = find(segInfo == j);       %get the patch ID in face
    tmpF = face(find(segInfo == j),:);  %find which faces(3*faces)
    tmpV = vertex(unique(tmpF(:,:)),:); %include which vertices
	hull = convhulln(tmpV);
	patchhull{j} = hull ;
			
	convCentroids = ConvCentroids (tmpV,hull);%get centroid of convexhull
	centroid = faceCentroids(tmpV,hull); %get centroids of each faces of convexhull
		    
	volumeMatrix = zeros(length(tmpF),1);
	vertexMatrix = {}; % potential seeds convexhull's vertex 
	for k = 1:length(tmpF)
	    vertexMatrix{k} = [vertex(tmpF(k,:),:);convCentroids];
	end
			
	hullMatrix = {}; %potential seeds hull
	for k = 1:length(tmpF)
	    [tmphull tmpVolume] = convhulln(vertexMatrix{k});
		hullMatrix{k} = tmphull;
		volumeMatrix(k) = tmpVolume;
	end
			
	%init the cost Matrix
	costMatrix = inf(length(tmpF),1);
	%compute the costMatrix
	for i = 1:length(costMatrix)
	    costMatrix(i) = Cost(tmpF(i,:),vertex,vertexMatrix{i},tmpV...
			,hullMatrix{i},hull,alpha,volumeMatrix(i),centroid);
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

tmp_toc = toc(tmp_tic);
fprintf('Find seeds: %.2fs\n',tmp_toc);