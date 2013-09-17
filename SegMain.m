%Shape decomposition Using methods from British Columbia
%Set up by Li Yangchun <phantomlyc@gmail.com> 
%Sep 2013

%init the work directory
%by performing following command in matlab:
% [vertex,face]= read_off('F:\MeshsegBenchmark-1.0\data\off\1.off');
% now I have vertex and face Matrix of a 3D mesh Model
%face is 3*number of Triangle
%vertex is 3*number of vertices

function segInfo= SegMain(vertex, face, verbose)
%This func performs algorithms to decomposite 3D mesh

numFace = size(face,2);
numVertex = size(vertex,2);
segInfo = zeros(numFace,1); %to store the label of faces
terminate = true;

while (terminate == true)
    label = CheckConnect(face,segInfo);
	
	%need a circle to find seeds for all the potential patch
	tmpF = face(:,find(label==1))'; % get the temp Face of a connect Patch num*3
	tmpV = vertex(:,unique(tmpF(:,:)))'; 
	[hull v] = convhulln(tmpV); %get the triangle 3*face v is the volume of the convexhull
	
    
	
	
	
	
	

    	


    %to test if we have covered all the patches
	if(size(find(segInfo == 0),1) == 0)
	    terminate = false;
	end
end


