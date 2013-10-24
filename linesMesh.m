function pos = linesMesh(line, vertex, face)
% Compute distance in Matrix form
% Given a bunch of lines, vertex and face
% return distance of each ray to current mesh
% line is a n*6 matrix of n lines
% using for to acclerate the computation

tol = 1e-6;


% find triangle edge vectors
t0  = vertex(face(:,1), :);
u   = vertex(face(:,2), :) - t0;
v   = vertex(face(:,3), :) - t0;
% triangle normal
n   = normalizeVector3d(vectorCross3d(u, v));
% normalize direction vectors of triangle edges
uu  = dot(u, u, 2);
uv  = dot(u, v, 2);
vv  = dot(v, v, 2);

pos = [];

for i = 1:size(line,1)
    % direction vector of line
    tmpline = line(i,:);
	dir = tmpline(4:6);

    % vector between triangle origin and line origin
    w0 = bsxfun(@minus, tmpline(1:3), t0);

    a = -dot(n, w0, 2);
    b = dot(n, repmat(dir, size(n, 1), 1), 2);

    valid = abs(b) > tol & vectorNorm3d(n) > tol;

    % compute intersection point of line with supporting plane
    % If pos < 0: point before ray
    % IF pos > |dir|: point after edge
    tmppos = a ./ b;

    % coordinates of intersection point
    points = bsxfun(@plus, tmpline(1:3), bsxfun(@times, tmppos, dir));


    %% test if intersection point is inside triangle
    % coordinates of vector v in triangle basis
    w = points - t0;
    wu = dot(w, u, 2);
    wv = dot(w, v, 2);

    % normalization constant
    D = uv.^2 - uu .* vv;

    % test first coordinate
    s = (uv .* wv - vv .* wu) ./ D;
    ind1 = s < 0.0 | s > 1.0;
    points(ind1, :) = NaN;
    tmppos(ind1) = NaN;

    % test second coordinate, and third triangle edge
    t = (uv .* wu - uu .* wv) ./ D;
    ind2 = t < 0.0 | (s + t) > 1.0;
    points(ind2, :) = NaN;
    tmppos(ind2) = NaN;

    % keep only interesting points
    inds = ~ind1 & ~ind2 & valid;
    points = points(inds, :);
    tmppos = tmppos(inds);
	
	coplane = find(abs(tmppos-0)<0.00001);
	if(~isempty(coplane))
	    tmppos = 0;
	else
        tmppos = tmppos((tmppos>0.00001),:);
	end
	
	pos = [pos;tmppos]; 
end




