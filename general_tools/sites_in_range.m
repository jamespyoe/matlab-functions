function [sites, dist, az] = sites_in_range(A_lats, A_lons, ...
    B_lats, B_lons, dist_limit, options)
arguments
    A_lats (1, :) double {mustBeInRange(A_lats, -90, 90, "inclusive")}
    A_lons (1, :) double {mustBeInRange(A_lons, -180, 180, "inclusive")}
    B_lats (:, 1) double {mustBeInRange(B_lats, -90, 90, "inclusive")}
    B_lons (:, 1) double {mustBeInRange(B_lons, -180, 180, "inclusive")}
    dist_limit (1, 1) double {mustBePositive}
    options.distUnits (1, 1) string {mustBeTextScalar} = "km"
    options.includeAllResults (1, 1) logical = false
    options.ParallelOptions (1, 1) = Inf
end
nargoutchk(1, 3);
ellipsoid = wgs84Ellipsoid(options.distUnits);
sz = validateSameSize(A_lats, A_lons);
iter = max(sz);
if options.includeAllResults
    sz = sz .* validateSameSize(B_lats, B_lons);
    sites = zeros(sz, "logical");
    dist = zeros(sz);
    az = zeros(sz);
    parfor (idx = 1:iter, options.ParallelOptions)
        [dist(idx, :), az(idx, :)] = distance(A_lats(idx), A_lons(idx), ...
            B_lats, B_lons, ellipsoid);
        sites(idx, :) = dist(idx, :) <= dist_limit;
    end
else
    validateSameSize(B_lats, B_lons);
    sites = cell(sz);
    dist = cell(sz);
    az = cell(sz);
    parfor (idx = 1:iter, options.ParallelOptions)
        [iter_dist, iter_az] = distance(A_lats(idx), A_lons(idx), ...
            B_lats, B_lons, ellipsoid);
        iter_sites = iter_dist <= dist_limit;
        sites{idx} = find(iter_sites);
        dist{idx} = iter_dist(iter_sites);
        az{idx} = iter_az(iter_sites);
    end
end

