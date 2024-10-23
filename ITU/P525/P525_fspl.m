function L = P525_fspl(D, F)
%P525   calculates the free space path loss between two points distance D
%(km) apart of a signal with carrier frequency F (GHz)
% referencing ITU-R P.525 to avoid name conflict with MATLAB fspl function
arguments
    D double {mustBeNonnegative}
    F double {mustBeNonnegative}
end
validateScalarExpandable(D, F); % unneccesary
L = 20 * log10(D .* F) + 92.44778322188337;
% 10log10((4pi * 1km * 1Ghz/c)^2) ~ 92.44778322188337
% closest double to true value
end