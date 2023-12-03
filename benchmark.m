% Benchmark Testing

% == DEFAULT VARIABLES ==========================================

% I hate warnings 
warning off; 

% Create a DEM of some size 
sizeDEM = 50;
ZI = peaks(sizeDEM);

% myTIN:
point_tol = 0.1; 

% myPovTIN:
player_coord = [15, 15, 0];
FOV = 15;

% == STANDARD DEM ===============================================


% DEM Figure
figure(1); clf;
tic; 
surf(ZI);
DEM_time = toc; 
title('DEM Model:');

% == myTIN ======================================================

% Create Figure
figure(2); clf;

% Find TIN model from DEM shown above
[tri, x, y, z] = myTIN(ZI, point_tol);

% Plot the TIN found 
tic;
trisurf(tri, x, y, z);
TIN_time = toc;

% Update Figure and Separate
title(['myTIN: (', num2str(100*point_tol), '% Point Tolerance)']);

% == myPovTIN ===================================================

% Use MyPovTIN!
[tri, x, y, z] = myPovTIN(player_coord, FOV, ZI, point_tol);

% Plot the surface using trisurf
figure(3); clf;
tic;
trisurf(tri, x, y, z);
povTIN_time = toc; 

% Set axis limits (do not change xlim, ylim, or zlim)
xlim([0, sizeDEM]);
ylim([0, sizeDEM]);
zlim([min(ZI(:)), max(ZI(:))]);

% Add labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
title(['myPovTIN: (', num2str(100*point_tol), '% Point Tolerance)']);

% == PRINT BENCHMARK RESULTS =====================================

disp(' '); disp('Benchmarking Results:');
disp('---------------------------');
disp(['DEM      | ', num2str(DEM_time, '%.5f'), ' seconds']);
disp('---------------------------');
disp(['myTIN    | ', num2str(TIN_time, '%.5f'), ' seconds' ]);
disp('---------------------------');
disp(['myPovTIN | ', num2str(povTIN_time, '%.5f'), ' seconds']);
disp('---------------------------'); disp(' ');