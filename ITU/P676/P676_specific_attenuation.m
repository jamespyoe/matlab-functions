function gamma = P676_specific_attenuation(F, P, rho, T)
%P676_SPECIFIC_ATTENUATION returns the specific attenuation calculated per
%ITU-R P.676-13. 
%   F is Frequency, in GHz
%   P is the total air pressure (dry air plus water vapour), in hPa
%   rho is the water vapour density, in g/m^3
%   T is the air temperature, in K
arguments
    F double {mustBeInRange(F, 1, 1000)}
    P double {mustBeNonnegative} = 1013.25;
    rho double {mustBeNonnegative} = 7.5;
    T double {mustBeNonnegative} = 288.15;
end
validateScalarExpandable(F, P, rho, T);
fd = string(fileparts(mfilename("fullpath"))) + filesep;
rho = rho .* T /216.7; % now vapour pressure in hPa
T = 300./T;
P = P - rho; % now dry air pressure in hPa

gamma = 0.1820 * F .* ( ...
    oxygen(F, P, rho, T, fd) + ...
    water_vapour(F, P, rho, T, fd) + ...
    nitrogen(F, P, rho, T));
end
function O2 = oxygen(F, P_dry, P_vapour, theta, fd)
load(fd + "P676_13 oxygen attenuation data.mat", ...
    "f0", "a1", "a2", "a3", "a5", "a6");
F = reshape(F, [1 size(F)]);
P_dry = reshape(P_dry, [1 size(P_dry)]);
P_vapour = reshape(P_vapour, [1 size(P_vapour)]);
theta = reshape(theta, [1 size(theta)]);

Si = 1e-7 * a1 .* P_dry .* theta.^3 .* exp(a2 .* (1 - theta));

Deltaf = 1e-4 * a3 .* (P_dry .* theta.^0.8 + 1.1 * P_vapour .* theta);
Deltaf = sqrt(Deltaf.^2 + 2.25e-6);

delta = 1e-4 * (a5 + a6 .* theta) .* (P_dry + P_vapour) .* theta.^0.8;

Fi = (F ./ f0) .* ...
    ((Deltaf - delta .* (f0 - F)) ./ ((f0 - F).^2 + Deltaf.^2) + ...
    (Deltaf - delta .* (f0 + F)) ./ ((f0 + F).^2 + Deltaf.^2));

O2 = sum(Si .* Fi);
if ~isscalar(O2)
    if isvector(O2)
        O2 = O2.';
    else
        d = size(O2);
        O2 = reshape(O2, d(2:end));
    end
end
end
function H2O = water_vapour(F, P_dry, P_vapour, theta, fd)
load(fd + "P676_13 water vapour attenuation data.mat", ...
    "f0", "b1", "b2", "b3", "b4", "b5", "b6")
F = reshape(F, [1 size(F)]);
P_dry = reshape(P_dry, [1 size(P_dry)]);
P_vapour = reshape(P_vapour, [1 size(P_vapour)]);
theta = reshape(theta, [1 size(theta)]);

Si = 1e-1 * b1 .* P_vapour .* theta.^3.5 .* exp(b2 .* (1 - theta));

Deltaf = 1e-4 * b3 .* (P_dry .* theta.^b4 + b5 .* P_vapour .* theta.^b6);
Deltaf = 0.535 * Deltaf + ...
    sqrt(0.217 * Deltaf.^2 + 2.1316e-12 * f0.^2 ./ theta);

Fi = (F ./ f0) .* ...
    (Deltaf ./ ((f0 - F).^2 + Deltaf.^2) + ...
    Deltaf ./ ((f0 + F).^2 + Deltaf.^2));

H2O = sum(Si .* Fi);
if ~isscalar(H2O)
    if isvector(H2O)
        H2O = H2O.';
    else
        d = size(H2O);
        H2O = reshape(H2O, d(2:end));
    end
end
end
function N2 = nitrogen(F, P_dry, P_vapour, theta)
Debye = 5.6e-4 * (P_dry + P_vapour) .* theta.^0.8;

N2 = F .* P_dry .* theta.^2 .* ...
    (6.14e-5 ./ (Debye .* (1 + (F ./ Debye).^2)) + ...
    1.4e-12 * P_dry .* theta.^1.5 ./ (1 + 1.9e-5 * F.^1.5));
end