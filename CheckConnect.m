function [label] = CheckConnect(face,seginfo)
% CheckConnect check which faces are connected with seginfo=0 (which means unassigned)
% and return a matrix called label which stores the label of vertex (label(i) stores face(i) belong to which label)
% Li Yangchun <phantomlyc@gmail.com>


%first find  assigned faces and set their label = 0
face(:,find(seginfo ~= 0))=0;
neighbor = getNeighbor(face) ;% c function 3*numFace
%build the initial Matrix then merge them
label=zeros(length(neighbor),1);
for i=1:length(neighbor)
    label(i) = i;
end

stop=true;
while stop
    label2 = label;
    for i=1:length(neighbor)
        index=[i neighbor(1,i) neighbor(2,i) neighbor(3,i)];
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
    label(find(label==Ulabel(i)))=i;
end %make parts range from 1 to numParts


    