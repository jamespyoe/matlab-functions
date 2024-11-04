function T = TropoClim(lats, lons)
%TROPOCLIM  finds the Troposheric Climate Parameter for use in the ITM
%Model, per get_text_GUI.m in general_terrestrial_pathloss
arguments
    lats double {mustBeInRange(lats, -90, 90)}
    lons double {mustBeInRange(lons, -180, 180)}
end

load(string(fileparts(mfilename("fullpath"))) + filesep + "Data.mat", ...
    "TropoClim")
% TropoClim is 0.5 degree bilinear sample of globe from
% 89:37:30S - 89:52:30N (-89.625 to 89.875) Latitude
% 179:37:30W - 179:52:30E (-179.625 to 179.875) Longitude
[nglon, nglat] = size(TropoClim);
T = interp2(linspace(90 - 1/8, -90 + 180/nglat - 1/8, nglat), ...
    linspace(-180 + 360/nglon - 1/8, 180 - 1/8, nglon), TropoClim, ...
    lats, lons, "nearest");
