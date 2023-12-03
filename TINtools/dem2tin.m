function [tri x y z] = dem2tin(ZI, ZImask, R)

    % Default values for optional arguments
    R_def = [0 1; 1 0; 0 0]; 

    % Check if R is provided
    if nargin < 3 || isempty(R)
        R = R_def;
    end

    % Create the grid
    [xi yi] = ir2xiyi(ZI,R);
    [XI YI] = meshgrid(xi,yi);

    % And extract the points that fit the provided mask.
    x = XI(ZImask);
    y = YI(ZImask);
    z = ZI(ZImask);
    [yp xp] = map2pix(R,x,y);

    % Then create the triangle representation from just the x, y points
    tri = delaunay(x,y);

end



% function [tri, x, y, z] = dem2tin(ZI, R, tol)
% 
%     % Default values for optional arguments
%     defaultR = [0 1; 1 0; 0 0]; % Default referencing matrix
%     defaultTol = 1; % Default tolerance
% 
%     % Check if R is provided
%     if nargin < 2 || isempty(R)
%         R = defaultR;
%     end
% 
%     % Check if tol is provided
%     if nargin < 3 || isempty(tol)
%         tol = defaultTol;
%     end
% 
%     % Create the grid
%     [xi, yi] = ir2xiyi(ZI, R);
%     [XI, YI] = meshgrid(xi, yi);
% 
%     % Implement tolerance-based point selection
%     [x, y, z] = selectPointsBasedOnTolerance(ZI, XI, YI, tol);
% 
%     % Create the triangulation
%     tri = delaunay(x, y);
% 
% end

% Generic little function to get the vectors that correspond to the
% axes of the raster
function [xi yi] = ir2xiyi(I,R)
    r = size(I,1);
    c = size(I,2);
    [xb yb] = pix2map(R,[1 r],[1 c]);
    xi = xb(1):R(2):xb(2);
    yi = yb(1):R(4):yb(2);
end