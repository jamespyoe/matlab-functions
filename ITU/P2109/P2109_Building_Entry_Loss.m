function BEL = P2109_Building_Entry_Loss(Frequency_GHz, P, theta, ...
    options)
arguments
    Frequency_GHz double {mustBeInRange(Frequency_GHz, 0.08, 100)}
    P double {mustBeInRange(P, 0, 1)} = 0.5;
    theta double {mustBeInRange(theta, -90, 90)} = 0;
    options.trad_constr (1, 1) logical = true
end
validateScalarExpandable(Frequency_GHz, P, theta)

% coefficients for traditional construction (true) or thermally efficient
% construction (false)
if options.trad_constr
    r = 12.64;
    s = 3.72;
    t = 0.96;
    u = 9.6;
    v = 2.0;
    w = 9.1;
    x = -3.0;
    y = 4.5;
    z = -2.0;
else
    r = 28.19;
    s = -3.00;
    t = 8.48;
    u = 13.5;
    v = 3.8;
    w = 27.8;
    x = -2.9;
    y = 9.4;
    z = -2.1;
end

lf = log10(Frequency_GHz);

sigma_1 = u + v*lf;
sigma_2 = y + z*lf;
mu_2 = w + x*lf;
L_h = r + s*lf + t*lf.^2;
L_e = 0.212*abs(theta);
mu_1 = L_h + L_e;

try
    Finv = norminv(P);
catch
    Finv = -sqrt(2)*erfcinv(2*P);
end

A = Finv.*sigma_1 + mu_1;
B = Finv.*sigma_2 + mu_2;

% 10^(0.1 * -3.0) approx equal to 0.501187233627272
BEL = pow2db(db2pow(A) + db2pow(B) + 0.501187233627272);