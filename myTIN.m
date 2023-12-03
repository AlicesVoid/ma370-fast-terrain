function [tri, x, y, z] = myTIN(myDEM, tol)
% Uses a Digital Elevation Model (DEM) to develop a Triangular Irregular Network (TIN)


% Create a referencing matrix

R = [0, 1; 1, 0; 0, 0];

% Select VIP points

ZImask = vipmask(myDEM,1/tol,true);

% Create the TIN from the image, refmat, and mask

[tri, x, y, z] = dem2tin(myDEM,R,ZImask);

% % Check error
% 
% [ZIe, ZIn] = verifytin(myDEM,R,x,y,z);
end