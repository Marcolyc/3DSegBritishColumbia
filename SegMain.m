%Shape decomposition Using methods from British Columbia
%Set up by Li Yangchun <phantomlyc@gmail.com> 
%Sep 2013

%init the work directory
%by performing following command in matlab:
% [vertex,face]= read_off('F:\MeshsegBenchmark-1.0\data\off\1.off');
% now I have vertex and face Matrix of a 3D mesh Model
%face is 3*number of Triangle
%vertex is 3*number of vertices

function segInfo= SegMain(vertex, face, verbose,alpha)
%This func performs algorithms to decomposite 3D mesh

numFace = size(face,2);
numVertex = size(vertex,2);
segInfo = zeros(numFace,1); %to store the label of faces
neighbor = getNeighbor(face); %c function get Neighbors
terminate = true;

while (terminate == true)
    label = CheckConnect(face,segInfo);
	%init the seed Matrix
	labelNum = length(unique(label(:,:)))
	segNum = length(unique(segInfo(:,:)))-1; %except 0
	patchVertexId = {}; %to store the vertex belong to a potential patch
	patchVertex = {}; % to store the cordinate
	faceId = {}; %to store which faces belong to a Potential patch
	
	% find seeds for existed and potential patch
	for j = 1:segNum
	    faceId{j} = find(segInfo == j); %get the patch ID in face
		tmpF = face(: , find(segInfo == j))';
		tmpV = vertex(: , unique(tmpF(:,:)))';
		[hull v] = convhulln(tmpV);
	    convCentroids = ConvCentroids (tmpV,hull);
		%init the cost Matrix
	    costMatrix = inf(length(tmpF),1);
	    %compute the costMatrix
	    for i = 1:length(costMatrix)
	        costMatrix(i) = Cost(tmpF(:,i),tmpV,hull,alpha,v);
	    end
	    %find the seed Triangle seedTri is the index 
	    seedTri = find(costMatrix == min(costMatrix));
		%get the seed convexhull vertex number
		patchVertexId{j} = [face(1,faceId{j}(seedTri));face(2,faceId{j}(seedTri));face(3,faceId{j}(seedTri))];
		patchVertex{j} = [tmpV(seedTri(1),:);tmpV(seedTri(2),:);...
		tmpV(seedTri(3),:);convCentroids];
	end
	
	for j = 1:labelNum
	    %need a circle to find seeds for all the potential patch
		faceId{j+segNum} = find(label == j-1);
	    tmpF = face(:,find(label==j-1))'; % get the temp Face of a connect Patch num*3
	    tmpV = vertex(:,unique(tmpF(:,:)))'; %get the temp Vertex num*3
	    [hull v] = convhulln(tmpV); %get the triangle 3*face ; v is the volume of the convexhull
	    convCentroids = ConvCentroids (tmpV,hull); %1*3
		%init the cost Matrix
	    costMatrix = inf(length(tmpF),1);
	    %compute the costMatrix
	    for i = 1:length(costMatrix)
	        costMatrix(i) = Cost(tmpF(:,i),tmpV,hull,alpha,v);
	    end
	    %find the seed Triangle seedTri is the index 
	    seedTri = tmpV(find(costMatrix == min(costMatrix)),:);
		%get the seed convexhull
		patchVertexId{j} = [face(1,faceId{j}(seedTri));face(2,faceId{j}(seedTri));face(3,faceId{j}(seedTri))];
		patchVertex{j} = [tmpV(seedTri(1),:);tmpV(seedTri(2),:);...
		tmpV(seedTri(3),:);convCentroids];
    end
	
	% grow all the seed into patches
	
    	


    %to test if we have covered all the patches
	if(size(find(segInfo == 0),1) == 0)
	    terminate = false;
	end
end


