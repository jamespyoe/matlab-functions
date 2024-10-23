function [k, alpha] = P838(F, elev, tau, options)
%P838 Calculates the k and alpha as the specific attenuation parameters due
%to rain for Frequency F at elevation elev and polarization tau
%   F is frequency, in GHz
%   elev is the elevation angle, in degrees
%   tau is the polarization angle, in degrees
arguments
    F double {mustBeInRange(F, 1, 1000)}
    elev double {mustBeInRange(elev, -90, 90)} = 0;
    tau = missing
    options.Polarization (1, 1) = 1;
    options.Revision (1, 1) double {mustBeMember(options.Revision, ...
        [1 2 3])} = 3;
end
if isequal(class(tau), "missing")
    validateScalarExpandable(F, elev);
    [options.Polarization, tau] = ...
        validatePolarization(options.Polarization);
    if isequal(elev, 0) && ~isequal(options.Polarization, 2)
        [k, alpha] = P838_Polarized(F, options.Polarization, ...
            options.Revision);
    else
        [k_v, alpha_v] = P838_Polarized(F, 0, options.Revision);
        [k_h, alpha_h] = P838_Polarized(F, 1, options.Revision);
        trig = cosd(elev).^2 .* cosd(2*tau);
        k = (k_h + k_v + (k_h - k_v).*trig)/2;
        alpha = (alpha_h.*k_h + alpha_v.*k_v + ...
            (alpha_h.*k_h - alpha_v.*k_v).*trig)./(2*k);
    end
else
    tau = double(tau);
    mustBeInRange(tau, 0, 90);
    validateScalarExpandable(F, elev, tau);

    [k_h, alpha_h] = P838_Polarized(F, 0, options.Revision);
    [k_v, alpha_v] = P838_Polarized(F, 1, options.Revision);
    trig = cosd(elev).^2 .* cosd(2*tau);
        k = (k_h + k_v + (k_h - k_v).*trig)/2;
        alpha = (alpha_h.*k_h + alpha_v.*k_v + ...
            (alpha_h.*k_h - alpha_v.*k_v).*trig)./(2*k);
end
if nargout < 2
    if iscolumn(k)
        k = [k alpha];
    elseif isrow(k)
        k = [k; alpha];
    else
        k = cat(ndims(k) + 1, k, alpha);
    end
end
end
function [k, alpha] = P838_Polarized(F, Pol, Revision)
fd = string(fileparts(mfilename("fullpath"))) + filesep;
    switch Revision
        case 1
            load(fd + "P838_1.mat", "Fi");
            switch Pol
                case 0
                    load(fd + "P838_1 Vertical.mat", "ki", "alphai");
                case 1
                    load(fd + "P838_1 Horizontal.mat", "ki", "alphai");
            end
            Fi = log(Fi);
            F = log(F);
            k = exp(interp1(Fi, log(ki), F));
            alpha = interp1(Fi, alphai, F);

        case 2
            sF = size(F);
            F = log10(F(:)).';
            switch Pol
                case 0
                    load(fd + "P838_2 k Vertical.mat", ...
                        "a", "b", "s", "m", "c");
                    k = 10.^reshape(sum(a .* exp(-((F - b)./s).^2)) + ...
                        m*F + c, sF);
                    load(fd + "P838_2 alpha Vertical.mat", ...
                        "a", "b", "s", "m", "c");
                    alpha = reshape(sum(a .* exp(-((F - b)./s).^2)) + ...
                        m*F + c, sF);
                case 1
                    load(fd + "P838_2 k Horizontal.mat", ...
                        "a", "b", "s", "m", "c");
                    k = 10.^reshape(sum(a .* exp(-((F - b)./s).^2)) + ...
                        m*F + c, sF);
                    load(fd + "P838_2 alpha Horizontal.mat", ...
                        "a", "b", "s", "m", "c");
                    alpha = reshape(sum(a .* exp(-((F - b)./s).^2)) + ...
                        m*F + c, sF);
            end
        case 3
            sF = size(F);
            F = log10(F(:)).';
            switch Pol
                case 0
                    load(fd + "P838_3 k Vertical.mat", ...
                        "a", "b", "s", "m", "c");
                    k = 10.^reshape(sum(a .* exp(-((F - b)./s).^2)) + ...
                        m*F + c, sF);
                    load(fd + "P838_3 alpha Vertical.mat", ...
                        "a", "b", "s", "m", "c");
                    alpha = reshape(sum(a .* exp(-((F - b)./s).^2)) + ...
                        m*F + c, sF);
                case 1
                    load(fd + "P838_3 k Horizontal.mat", ...
                        "a", "b", "s", "m", "c");
                    k = 10.^reshape(sum(a .* exp(-((F - b)./s).^2)) + ...
                        m*F + c, sF);
                    load(fd + "P838_3 alpha Horizontal.mat", ...
                        "a", "b", "s", "m", "c");
                    alpha = reshape(sum(a .* exp(-((F - b)./s).^2)) + ...
                        m*F + c, sF);
            end
    end
end