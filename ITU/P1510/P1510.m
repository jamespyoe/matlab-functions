function Temperature = P1510(lats,lons)
%P1510 finds the average Temperature (K) per year of 
%coordinates by bilinear interpolation, per ITU-R P.1510-1
arguments
    lats double {mustBeInRange(lats, -90, 90)}
    lons double {mustBeInRange(lons, -180, 180)}
end
load(string(fileparts(mfilename("fullpath"))) + filesep + "Data.mat", ...
    "T");
Temperature = interp2(linspace(-90, 90, size(T, 2)), ...
    linspace(-180, 180, size(T, 1)), T, lats, lons);
