function [tri, x, y, z] = myPovTIN(player_coord, FOV, myDEM, point_tol)
% Uses coordinates and POV to generate an incomplete TIN for a DEM 
%
% Inputs: 
%    player_coord : [x, y, z] coordinates of the player
%    FOV          : [int] value for the distance that the user can see
%    myDEM        : some DEM model (ex: peaks(40) ) 
%    point_tol    : [0 < x < 1] percentage of points used for accuracy
% 
% Outputs:
%    [x, y, z]    : the coordinates of the TIN
%    [tri]        : the triangles mapped in the TIN
%
%
% Example Use:
%    player_coord = [10, 10, 5];
%    FOV = 10;
%    myDEM = peaks(40);
%    point_tol = 0.5;
%    [tri, x, y, z] = myPovTIN(player_coord, FOV, myDEM, point_tol);
%    trisurf(tri, x, y, z);
%



% Create a grid of points
[x, y] = meshgrid(1:size(myDEM, 2), 1:size(myDEM, 1));

% % Calculate the number of points
% num_points = numel(x);
% 
% % Calculate the FOV boundaries
% x_min = max(1, player_coord(1) - FOV);
% x_max = min(length(myDEM), player_coord(1) + FOV);
% y_min = max(1, player_coord(2) - FOV);
% y_max = min(length(myDEM), player_coord(2) + FOV);
% z_min = player_coord(3) - FOV;
% z_max = player_coord(3) + FOV;
% 
% % Filter points based on FOV boundaries
% valid_indices = find(x >= x_min & x <= x_max & y >= y_min & y <= y_max & myDEM >= z_min & myDEM <= z_max);
% selected_points = [x(valid_indices), y(valid_indices)];
% z = myDEM(valid_indices);

z = myDEM;

% Calculate the 3D distances between all points and player_coord
distances = sqrt((x - player_coord(1)).^2 + (y - player_coord(2)).^2 + (z - player_coord(3)).^2);

% Find valid indices where distance <= FOV
valid_indices = find(distances <= FOV);

% Extract selected points and Z values
selected_points = [x(valid_indices), y(valid_indices)];
z = z(valid_indices);

% Calculate the number of selected points based on the selected point_tol
num_points = numel(valid_indices);
selected_point_tol = point_tol * (numel(valid_indices) / num_points);

% % Randomly select the specified number of points
% num_points_to_select = round(selected_point_tol * num_points);
% selected_indices = randperm(numel(valid_indices), num_points_to_select);
% selected_points = selected_points(selected_indices, :);
% selected_ZI = selected_ZI(selected_indices);

% Use vipmask to select points based on the threshold
thresh = selected_point_tol; % Use selected_point_tol as the threshold
keepcorners = true; % Set keepcorners to false

% Call the vipmask function to create a mask
[ZImask] = vipmask(z, thresh, keepcorners);

% Use the mask to select the points
selected_points = selected_points(ZImask, :);

% Set X, Y, and Z
x = selected_points(:, 1);
y = selected_points(:, 2);
z = z(ZImask);


% Create a triangulation using Delaunay from the selected points
tri = delaunay(x, y);

end