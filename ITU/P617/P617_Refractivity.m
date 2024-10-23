function N0 = P617_Refractivity(lats, lons)
%P617_REFRACTIVITY finds the median surface refractivity of coordinates by
%bilinear interpolation, per ITU-R P.617-5
arguments
    lats double {mustBeInRange(lats, -90, 90)}
    lons double {mustBeInRange(lons, -180, 180)}
end
load(string(fileparts(mfilename("fullpath"))) + filesep + "Data.mat", ...
    "N050");
N0 = interp2(linspace(90, -90, size(N050, 2)), ...
    linspace(0, 360, size(N050, 1)), N050, lats, mod(lons, 360));
