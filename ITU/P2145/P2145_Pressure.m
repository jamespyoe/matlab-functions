function Pressure = P2145_Pressure(lats,lons)
%P2145_PRESSURE finds the average air pressure (hPa) per year of 
%coordinates by bilinear interpolation, per ITU-R P.2145-0
arguments
    lats double {mustBeInRange(lats, -90, 90)}
    lons double {mustBeInRange(lons, -180, 180)}
end
load(string(fileparts(mfilename("fullpath"))) + filesep + "Data.mat", ...
    "P");
Pressure = interp2(linspace(-90, 90, size(P, 2)), ...
    linspace(-180, 180, size(P, 1)), P, lats, lons);
