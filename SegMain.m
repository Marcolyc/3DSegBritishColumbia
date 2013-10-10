% Shape decomposition Using methods from British Columbia
% Set up by Li Yangchun <phantomlyc@gmail.com> 
% Sep 2013
%

%read a data
[vertex,face]= read_off('F:\MeshsegBenchmark-1.0\data\off\200.off'); % It's a hand
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
patchFaceId = {}; % to store the face Id for growing

%patchhull = {}; %to store the convexhull's face

patchVertexIdOld = {}; %used to check if convergence
patchVertexOld = {};
patchFaceIdOld = {};


while (terminate == true)
    %step1 find potential patch
    segInfo = CheckConnect(face,segInfo,neighbor,1);

	while(true)
	    %step2 finding seeds for connected areas
	    [patchVertexId patchFaceId patchVertex] = Findseeds(segInfo,face,vertex);
		
	
	    %step3 grow all the seed into patches
	
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
					                   ,[patchVertex{i};vertex(vertexNeighbor(k),:)],tmphull,tmphull,alpha,tmpVolume,centroid);
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
		    % to test convergence
		    convergence = [];
	    for i =1:length(patchVertex)
	        diffNum = length(setdiff(patchFaceId,patchFaceIdOld));
		    oldNum = length(patchFaceIdOld);
		    convergence = [;diffNum/oldNum];
	    end
	    if(all(convergence<0.05))
	        break;
	    end
		for i=1:length(Triold)
		    Triold{i} = patchFaceId{i};
		end	
	end		
	% if convergence assigned Triangles to patch
	for i =1:length(patchFaceId)
	    segInfo(patchFaceId{i}) = i;
	end		   	

    %to test if we have covered all the patches  
	if(size(find(segInfo == 0),1) == 0)
	    terminate = false;
	end
end


