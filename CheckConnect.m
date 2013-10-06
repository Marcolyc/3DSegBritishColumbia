function [seginfo] = CheckConnect(face,seginfo,neighbor,verbose)
% CheckConnect check which faces are connected with seginfo=0 (which means unassigned)
% and return seginfo 
% different number of seginfo inform different connected areas
% Li Yangchun <phantomlyc@gmail.com>

tmp_tic = tic;
%first find  assigned faces and set their label = 0
face(find(seginfo ~= 0),:)=0;
numSeg = length(unique(seginfo(:,:)))-1;

%build the initial Matrix then merge them
label=zeros(length(neighbor),1);
for i=1:length(neighbor)
    if(face(i)~=0) %can not use assigned faces
        label(i) = i;
    end
end

stop = true;
while stop
    label2 = label;
    for i=1:length(neighbor)
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
    seginfo(find(label==Ulabel(i)))=i+numSeg;
end %make parts range from 1 to numParts

if verbose
    tmp_toc = toc(tmp_tic);
    fprintf('Done Finding Connected Areas: %.2fs\n',tmp_toc);
end


    