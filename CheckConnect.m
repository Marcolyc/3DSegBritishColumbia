function [seginfo] = CheckConnect(face,seginfo,verbose)
% CheckConnect check which faces are connected with seginfo = 0 (which means unassigned)
% and return seginfo 
% different number of seginfo inform different connected areas
% Li Yangchun <phantomlyc@gmail.com>

tmp_tic = tic;
%first find  assigned faces and existed patches
numSeg = length(unique(seginfo(:,:)))-1;

% get the unassigned triangles
list = find(seginfo == 0);
tmpFace = face(list,:);
neighbor = getNeighbor(tmpFace');
neighbor = neighbor';

%build the initial Matrix then merge them
label=zeros(size(neighbor,1),1);
for i=1:length(label)
    label(i) = i;
end

stop = true;
while stop
    label2 = label;
    for i=1:size(neighbor,1)
        index=[i neighbor(i,1) neighbor(i,2) neighbor(i,3)];
        index(find(index==0))=[]; %delete 0 element
	    tmpLabel=label(index);
	    label(index)=min(tmpLabel); %make all neighbor label to min
    end
	%merge until label does not change any more
	if (label2 == label)
	stop = false;
	end
end
	

Ulabel = unique(label); %find how many parts
for i=1:length(Ulabel)
    seginfo(list(find(label==Ulabel(i))))=i+numSeg;
end %make parts range from 1 to numParts

if verbose
    tmp_toc = toc(tmp_tic);
    fprintf('Done Finding Connected Areas: %.2fs\n',tmp_toc);
end


    