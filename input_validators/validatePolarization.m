function [Pol, tau] = validatePolarization(Pol)
%VALIDATEPOLARIZATION   helper to resolve different ways of passing
%polarization arguments
%   validates and returns 0 for vertical polarization, 1 for horizontal
%   polarization, and 2 for circular polarization. Throws an error if it
%   can't parse the input into one of these values. tau is the conversion
%   of polarization to degrees.
%   NOTE: While polarizations can be specified numerically, there is
%   conflict between conventional polarization and the angle relative to
%   the horizontal they represent. Data representing angle relative to the
%   horizontal cannot be treated as polarization and validated with this
%   method
if istext(Pol) 
    % handle 'char' or cell array of 'char'
    T = string(Pol);
    % "0", "1", "2" will convert properly to doubles, "Horizontal", "Vert",
    % "C", etc will convert to NaN
    Pol = double(T); 
    idx = isnan(Pol);
    T = upper(T);
    % searches for strings that can be interpreted as horizontal, vertical,
    % or circular
    Pol(idx & contains(T, "H")) = 1;
    Pol(idx & contains(T, "V")) = 0;
    Pol(idx & contains(T, "C") & ~contains(T, "V")) = 2;
end
mustBeMember(Pol, [0 1 2]);
taus = [90 0 45];
tau = taus(Pol+1);