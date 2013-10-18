% Shape decomposition Using methods from British Columbia
% Set up by Li Yangchun <phantomlyc@gmail.com> 
% Sep 2013
%

%read a data
[vertex,face]= read_off('F:\github\3DSegBritishColumbia\200-155.off'); % It's a hand
vertex= vertex';
face = face';
alpha = 0.007;
Dmax = 0.07;

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

patchFaceIdOld = {};


while (terminate == true)
    %step1 find potential patch
    segInfo = CheckConnect(face,segInfo,neighbor,1);
	
	% step2 find initial seeds
	[patchVertexId patchFaceId patchVertex] = Findseeds(segInfo,face,vertex);
	
	for i=1:length(patchFaceId)
		patchFaceIdOld{i} = patchFaceId{i};
	end

	while(true)
	    %step2 finding seeds for connected areas
		
	    %step3 grow all the seed into patches	
		[patchVertexId patchFaceId patchVertex] = ...
        GrowPatches(patchVertexId,patchFaceId,neighbor,patchVertex,vertex,face,Dmax);
		% to test convergence
		convergence = [];
	    for i =1:length(patchVertex)
	        diffNum = length(setdiff(patchFaceId{i},patchFaceIdOld{i}));
		    oldNum = length(patchFaceIdOld{i});
		    convergence = [;diffNum/oldNum];
	    end
	    if(all(convergence<0.05))
	        break;
	    end
		% update old patchFace
		for i=1:length(patchFaceId)
		    patchFaceIdOld{i} = patchFaceId{i};
	    end
		%not convergence we have to Reseed
		[patchVertexId patchFaceId patchVertex] = Reseed(vertex,face,patchVertex,patchFaceId);

	end	
	
	%step4 
    segInfo(:,:) = 0;	
	% if convergence assigned Triangles to patch
	for i =1:length(patchFaceId)
	    segInfo(patchFaceId{i}) = i;
	end		   	
    %to test if we have covered all the patches  
	if(size(find(segInfo == 0),1) == 0)
	    terminate = false;
	end
end


