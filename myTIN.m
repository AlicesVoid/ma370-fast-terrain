
function [tri, x, y, z] = myTIN(myDEM, point_tol)
    % % Uses a Digital Elevation Model (DEM) to develop a Triangular Irregular Network (TIN)
    %
    % Inputs: 
    %    myDEM        : some DEM model (ex: peaks(40) ) 
    %    point_tol    : [0 < x < 1] percentage of points used for accuracy
    % 
    % Outputs:
    %    [x, y, z]    : the coordinates of the TIN
    %    [tri]        : the triangles mapped in the TIN
    %
    %
    % Example Use:
    %    myDEM = peaks(40);
    %    point_tol = 0.5;
    %    [tri, x, y, z] = myPovTIN(player_coord, FOV, myDEM, point_tol);
    %    trisurf(tri, x, y, z);
    %

    % Create a referencing matrix
    R = [0, 1; 1, 0; 0, 0];

    % Get the size of the DEM
    [rows, cols] = size(myDEM);

    % Define the middle region
    midRowStart = floor(rows/4) + 1;
    midRowEnd = floor(3*rows/4);
    midColStart = floor(cols/4) + 1;
    midColEnd = floor(3*cols/4);

    % Initialize full mask
    fullMask = false(rows, cols);

    % Create mask for the middle region
    middleMask = fullMask;
    middleMask(midRowStart:midRowEnd, midColStart:midColEnd) = true;
    ZImask_1 = vipmask(myDEM .* middleMask, point_tol, false);

    % Create mask for the outer region
    outerMask = fullMask;
    outerMask(~middleMask) = true;
    ZImask_2 = vipmask(myDEM .* outerMask, point_tol/2, true);

    % Combine ZImask_1 and ZImask_2
    ZImask = ZImask_1 | ZImask_2;

    % Create the TIN from the image, refmat, and combined mask
    [tri, x, y, z] = dem2tin(myDEM, ZImask, R);

    % % Check error (if needed)
    % [ZIe, ZIn] = verifytin(myDEM, R, x, y, z);
end


