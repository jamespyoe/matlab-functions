function Lcct = P2108_Terrestrial_Clutter_Loss(Frequency_GHz, Distance, p)
% clutter loss (single ended) via section 3.2 of ITU-R P.2108-1
arguments
    Frequency_GHz double {mustBeInRange(Frequency_GHz, 0.5, 67)}
    Distance double {mustBePositive}
    p double {mustBeInRange(p, 0, 100, "exclusive")} = 50;
end
validateScalarExpandable(Frequency_GHz, Distance, p);

% clutter loss at maximum value when Distance = 2km. To limit calculation
% to this maximum, Distance can be limited to 2km, as clutter loss
% monotonically increases with distance
Distance(Distance > 2) = 2;

% clutter loss calculations inapplicable for paths less than 0.25km. Such
% paths can be identified at the output by setting distance to 0km and
% letting -Inf value propagate through calculation and correcting loss at
% output
Distance(Distance < 0.25) = 0;

% 4a and 4b are only referenced in later equations as 10^(-0.2*x), so that
% is included in the definitions of Ll/Ls here

% 4a
Ll = 10.^(0.4*log10(10.^(-5*log10(Frequency_GHz) -12.5) + 10^-16.5));
% 5a
Ls = 10.^(-0.2 * ...
    (32.98 + 23.9 * log10(Distance) + 3*log10(Frequency_GHz)));
% 3b
sigma_cb = sqrt((16 * Ll + 36 * Ls)./(Ll + Ls));
% 3a
try
    iQ = -norminv(p*1e-2);
catch
    iQ = sqrt(2)*erfcinv(2*p*1e-2);
end

Lcct = -5*log10(Ll + Ls) - sigma_cb .* iQ;

% corrects Lcct for Distance < 0.25 to 0 dB
% Lcct(~(isfinite(Lcct) & isreal(Lcct))) = 0;
Lcct(~isfinite(Lcct)) = 0;