%Shape decomposition Using methods from British Columbia
%Set up by Li Yangchun <phantomlyc@gmail.com> 
%Sep 2013

%init the work directory
%by performing following command in matlab:
% [vertex,face]= read_off('F:\MeshsegBenchmark-1.0\data\off\1.off');
% now I have vertex and face Matrix of a 3D mesh Model
%face is 3*number of Triangle
%vertex is 3*number of vertices

function segInfo= SegMain(vertex, face, alpha)
%This func performs algorithms to decomposite 3D mesh

numFace = size(face,2);
numVertex = size(vertex,2);
segInfo = zeros(numFace,1); %to store the label of faces
neighbor = getNeighbor(face); %c function get Neighbors
terminate = true;

patchVertexId = {}; %to store the vertex belong to a potential patch
patchVertex = {}; % to store the cordinate
TriId = {}; % to store the face Id for growing

patchVertexIdOld = {}; %used to check if convergence
patchVertexOld = {};
TriIdOld = {};


while (terminate == true)
    %step1
    label = CheckConnect(face,segInfo,1);
	%init the seed Matrix
	labelNum = length(unique(label(:,:)));
	segNum = length(unique(segInfo(:,:)))-1; %except 0

	while(true)
	    faceId = {}; %to store which faces belong to a Potential patch	
	    %step2 find seeds for existed and potential patch
	    for j = 1:segNum
	        faceId{j} = find(segInfo == j); %get the patch ID in face
		    tmpF = face(: , find(segInfo == j))';
		    tmpV = vertex(: , unique(tmpF(:,:)))';
		    [hull tmpVolume] = convhulln(tmpV);
	        convCentroids = ConvCentroids (tmpV,hull);
		    %init the cost Matrix
	        costMatrix = inf(length(tmpF),1);
	        %compute the costMatrix
	        for i = 1:length(costMatrix)
	            costMatrix(i) = Cost(tmpF(i,:),tmpV,hull,alpha,tmpVolume);
	        end
	        %find the seed Triangle seedTri is the index
            seedTriIndex = find(costMatrix == min(costMatrix));%get the indices of tmpF 
		    seedTriIndex = find(face == tmpF(seedTriIndex)); %get the indices in face
	        seedTri = vertex(face(seedTriIndex));
		    %get the seed convexhull
		    patchVertexId{j} = [face(1,seedTriIndex);face(2,seedTriIndex);face(3,seedTriIndex)];
		    patchVertex{j} = [;convCentroids;seedTri(1,:);seedTri(2,:);...
		                       seedTri(3,:)];
		    TriId{j} = [;seedTriIndex];
	    end
	
	    for j = 1:labelNum
	        %need a circle to find seeds for all the potential patch
		    faceId{j+segNum} = find(label == j);
	        tmpF = face(:,faceId{j+segNum})'; % get the temp Face of a connect Patch num*3
	        tmpV = vertex(:,unique(tmpF(:,:)))'; %get the temp Vertex num*3
	        [hull tmpVolume] = convhulln(tmpV); %get the triangle 3*face ; v is the volume of the convexhull
	        convCentroids = ConvCentroids (tmpV,hull); %1*3
		    %init the cost Matrix
	        costMatrix = inf(length(tmpF),1);
	        %compute the costMatrix
	        for i = 1:length(costMatrix)
	            costMatrix(i) = Cost(tmpF(i,:),tmpV,hull,alpha,tmpVolume);
	        end
	        %find the seed Triangle seedTri is the index
            seedTriIndex = find(costMatrix == min(costMatrix));%get the indices of tmpF 
		    seedTriIndex = find(face == tmpF(seedTriIndex)); %get the indices in face
	        seedTri = vertex(face(seedTriIndex));
		    %get the seed convexhull
		    patchVertexId{j} = [face(1,seedTriIndex);face(2,seedTriIndex);face(3,seedTriIndex)];
		    patchVertex{j} = [;convCentroids;seedTri(1,:);seedTri(2,:);...
		                   seedTri(3,:)];
		    TriId{j} = [;seedTriIndex];
        end
	
	    %step3 grow all the seed into patches
	
	    for i = 1:length(patchVertex)
		    cost = 0;
		    while(true)
		        %init patch group and find neighbors
	            [tmpTriNei tmpNeighbor]= GetNeighborVertex( TriId{i},patchVertexId{i},face,neighbor ); %return the indices
	            tmpCostMatrix = zeros(length(tmpNeighbor),1);
		        %compute the cost Matrix
		        for k =1:length(tmpCostMatrix)
		            [hull tmpVolume] = convhulln([patchVertex{j};vertex(tmpNeighbor(i))]);
		            tmpCostMatrix(k) = Cost(face(TriId{i}),patchVertex{i},hull,alpha,tmpVolume);
		        end
		        cost = min(tmpCostMatrix);
		        if ( (cost - Dmax) > 0 )
		            break;
		        end
		        % cost<Dmax then we have to add v to the patch
		        tmpVertexId = tmpNeighbor(find(costMatrix == cost));
		        patchVertexId{i} = [patchVertexId;tmpVertexId];
		        patchVertex{i} = [patchVertex;vertex(tmpVertexId,:)];
		        %find which rows in Neighbor has this added vertex
		        [row column] = ...
		        find(ismember(face(tmpTriNei,:),tmpVertexId) == 1); 
		        TriId{i} = [TriId{i} ; row];
			end
	    end
		    % to test convergence
		    convergence = [];
	    for i =1:length(patchVertex)
	        diffNum = length(setdiff(TriId,TriIdOld));
		    oldNum = length(TriIdOld);
		    convergence = [;diffNum/oldNum];
	    end
	    if(all(convergence<0.05))
	        break;
	    end
		for i=1:length(Triold)
		    Triold{i} = TriId{i};
		end	
	end		
	% if convergence assigned Triangles to patch
	for i =1:length(TriId)
	    segInfo(TriId{i}) = i;
	end		   	

    %to test if we have covered all the patches
	if(size(find(segInfo == 0),1) == 0)
	    terminate = false;
	end
end


