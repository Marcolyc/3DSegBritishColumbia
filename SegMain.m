% Shape decomposition Using methods from British Columbia
% Set up by Li Yangchun <phantomlyc@gmail.com> 
% Sep 2013
%

%read a data
[vertex,face]= read_off('F:\MeshsegBenchmark-1.0\data\off\1.off');
vertex= vertex';
face = face';
alpha = 0.07;
Dmax = 100;

numFace = size(face,1);
numVertex = size(vertex,1);
segInfo = zeros(numFace,1); %to store the label of faces
neighbor = getNeighbor(face'); %c function get Neighbors
neighbor = neighbor';
terminate = true;

patchVertexId = {}; %to store the vertex belong to a potential patch
patchVertex = {}; % to store the cordinate
TriId = {}; % to store the face Id for growing
patchhull = {}; %to store the convexhull's face

patchVertexIdOld = {}; %used to check if convergence
patchVertexOld = {};
TriIdOld = {};


while (terminate == true)
    %step1 find potential patch
    segInfo = CheckConnect(face,segInfo,neighbor,1);
	segNum = length(unique(segInfo(:,:))); %except 0

	while(true)
	    faceId = {}; %to store which faces belong to a Potential patch	
	    %step2 find seeds for existed and potential patch
	    for j = 1:segNum
	        faceId{j} = find(segInfo == j);       %get the patch ID in face
		    tmpF = face(find(segInfo == j),:);  %find which faces(3*faces)
		    tmpV = vertex(unique(tmpF(:,:)),:); %include which vertices
		    hull = convhulln(tmpV);
			patchhull{j} = hull ;
			
	        convCentroids = ConvCentroids (tmpV,hull);%get the centroid of convexhull
			centroid = faceCentroids(vertex,hull); 
		    
			VolumeMatrix = zeros(length(tmpF),1);
			vertexMatrix = {}; % potential seeds convexhull's vertex 
			for k = 1:length(tmpF)
			    vertexMatrix{k} = [vertex(tmpF(k,:),:);convCentroids];
			end
			
			hullMatrix = {}; %potential seeds hull
			for k = 1:length(tmpF)
			    [tmphull tmpVolume] = convhulln(faceMatrix{k});
				hullMatrix{k} = tmphull;
				VolumeMatrix(k) = tmpVolume;
			end
			
			%init the cost Matrix
	        costMatrix = inf(length(tmpF),1);
	        %compute the costMatrix
	        for i = 1:length(costMatrix)
	            costMatrix(i) = Cost(tmpF(i,:),tmpV,vertexMatrix{i}...
				,hullMatrix{i},hull,alpha,VolumeMatrix(i),centroid);
	        end
	        %find the seed Triangle seedTri is the index
            seedTriIndex = find(costMatrix == min(costMatrix));%get the indices of tmpF 
			seedTriIndex = seedTriIndex(1);
		    seedTriIndex = find(ismember(face,tmpF(seedTriIndex,:),'rows'));
	        
			
		    %get the seed convexhull attention the rows and columns
		    patchVertexId{j} = [face(seedTriIndex,1);face(seedTriIndex,2);face(seedTriIndex,3)];
			patchVertex{j} = [convCentroids];
			for i = 1:3
		        patchVertex{j} = [patchVertex{j};vertex(patchVertexId{j}(i),:)];
			end
		    TriId{j} = [;seedTriIndex];
	    end
	
	    %step3 grow all the seed into patches
	
	    for i = 1:length(patchVertex)
		    cost = 0;
		    while(true)
		        %init patch group and find neighbors
	            [tmpTriNei tmpNeighbor]= GetNeighborVertex(TriId{i},patchVertexId{i},face,neighbor); %return the indices
	            tmpCostMatrix = zeros(length(tmpNeighbor),1);
		        % compute the cost Matrix 
				% some problems!!!!!!!! update new triangles
		        for k =1:length(tmpCostMatrix)
		            [hull tmpVolume] = convhulln([patchVertex{j};vertex(tmpNeighbor(i),:)]);
					centroid = faceCentroids([PatchVertex{j};vertex(tmpNeighbor(i),:)],hull);
		            tmpCostMatrix(k) = Cost(face(TriId{i},:),vertex,patchVertex{i}...
					                   ,hull,hull,alpha,tmpVolume,centroid);
		        end
				% some problems!!!!!!!!! update new triangles
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


