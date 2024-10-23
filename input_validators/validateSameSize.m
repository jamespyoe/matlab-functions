function varargout = validateSameSize(varargin)
%VALIDATESAMESIZE Validate arguments are the same size
%   VALIDATESAMESIZE(A, B) throws an error if B is not the same size as A
%   VALIDATESAMESIZE(A1, ..., An, ...) throws an error if An is not the
%   same size as A1.
%   MATLAB calls size and isequal to determine if all input arguments are
%   the same size.
nargoutchk(0, min(nargin, 1));
if nargin
    sz = size(varargin{1});
    for i = 2:nargin
        if ~isequal(sz, size(varargin{i}))
            ME = MException("JYOE:validators:" + mfilename, ...
                inputname(1) + " must be the same size as " + ...
                inputname(i));
            throwAsCaller(ME);
        end
    end
end
if nargout
    varargout{:} = sz;
end