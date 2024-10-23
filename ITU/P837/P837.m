function R = P837(lats,lons)
%   P837 finds the Rain Rate (mm/hr) exceeded 0.01% of the time per year of 
%coordinates by bilinear interpolation, per ITU-R P.837-7
arguments
    lats double {mustBeInRange(lats, -90, 90)}
    lons double {mustBeInRange(lons, -180, 180)}
end
load(string(fileparts(mfilename("fullpath"))) + filesep + "Data.mat", ...
    "R001");
R = interp2(linspace(-90, 90, size(R001, 2)), ...
    linspace(-180, 180, size(R001, 1)), R001, lats, lons);