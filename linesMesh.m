function pos = linesMesh(line, vertex, face)
% Compute distance in Matrix form
% Given a bunch of lines, vertex and face
% return distance of each ray to current mesh

tol = 1e-12;

% find triangle edge vectors
t0  = vertices(faces(:,1), :);
u   = vertices(faces(:,2), :) - t0;
v   = vertices(faces(:,3), :) - t0;

% triangle normals
nMatrix = normalizeVector3d(cross(u,v));

%direction
dirMatrix = line(:,4:6);

w0 = bsxfun(@minus, line(:,1:3), t0);


