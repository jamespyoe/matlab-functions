function wvd = P2145_Water_Vapour_Density(lats,lons)
%P2145_WATER_VAPOUR_DENSITY finds the average water vapour density (g/m^3)
%per year of coordinates by bilinear interpolation, per ITU-R P.2145-0
arguments
    lats double {mustBeInRange(lats, -90, 90)}
    lons double {mustBeInRange(lons, -180, 180)}
end
load(string(fileparts(mfilename("fullpath"))) + filesep + "Data.mat", ...
    "rho");
wvd = interp2(linspace(-90, 90, size(rho, 2)), ...
    linspace(-180, 180, size(rho, 1)), rho, lats, lons);