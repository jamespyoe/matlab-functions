function DeltaN = P617_Delta_Refractivity(lats, lons)
%P617_DELTA_REFRACTIVITY finds the difference between the median surface 
%refractivity and the refractivity 1000m above the surface of coordinates 
%by bilinear interpolation, per ITU-R P.617-5
arguments
    lats double {mustBeInRange(lats, -90, 90)}
    lons double {mustBeInRange(lons, -180, 180)}
end
load(string(fileparts(mfilename("fullpath"))) + filesep + "Data.mat", ...
    "DN50");
DeltaN = interp2(linspace(90, -90, size(DN50, 2)), ...
    linspace(0, 360, size(DN50, 1)), DN50, lats, mod(lons, 360));
