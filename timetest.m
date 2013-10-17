

[vertex,face]= read_off('F:\MeshsegBenchmark-1.0\data\off\1.off'); % It's a hand
vertex= vertex';
face = face';
[hull volume] = convhull(vertex);
normal = faceNormal(vertex,hull);
centroids = faceCentroids(vertex,hull);

neighbor = getNeighbor(hull');
neighbor = neighbor';
newV = [0 0 1];


tmpTic = tic;
[newHull newVolume] = ConvAddVertex(hull,vertex,newV,normal,neighbor,volume);
%[newhull newvolume] = convhull([vertex;newV]);
%distance = Dist(face,vertex,vertex,hull,centroids);
%intersect(hull,newHull);


tmpToc = toc(tmpTic);
fprintf('Done Compute New Convex : %.5fs\n',tmpToc);