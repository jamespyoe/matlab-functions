function varargout = validateScalarExpandable(varargin)
%VALIDATESCALAREXPANDABLE   Validate arguments are the compatible for
%operations which support scalar expansion. Arguments are compatible for
%scalar expansion if all their dimmensions are equal to each other and/or
%equal to 1.
%   VALIDATESCALAREXPANDABLE(A, B) throws an error if A is not compatible
%   with B
%   VALIDATESAMESIZE(___, An, ___) throws an error if An is not compatible
%   with all arguments preceeding and following it.
%   varargout is a matrix containing the size of all arguments in varargin,
%   1 padded to accomodate the input argument with the greatest number of
%   dimmensions.
nargoutchk(0, 1);

mdims = max(cellfun(@ndims, varargin));
dimMat = zeros([nargin mdims]);

for i = 1:nargin
    dimMat(i, :) = paddata(size(varargin{i}), mdims, FillValue=1);
end
for i = 1:mdims
    % checks the number of different non unit lengths each argument has for
    % each dimmension. This should be 0 (all arguments length 1 in a
    % dimmension) or 1 (There is a length L ~= 1, all arguments are either
    % length 1 or length L in a dimmension). Otherwise there are
    % arguments with non scalar compatible lengths in a dimmension and an
    % error is thrown
    if numel(unique(dimMat(dimMat(:, i) ~= 1, i))) > 1
        if mdims > 2
            errstr = ...
                "Not all arguments are compatible in dimmension " + i;
        elseif i == 2
            errstr = ...
                "Not all arguments have the same number of rows";
        else
            errstr = ...
                "Not all arguments have the same number of columns";
        end
        ME = MException("JYOE:validators:" + mfilename, ...
            errstr);
        throwAsCaller(ME);
    end
end

if nargout
    varargout{:} = dimMat;
end
