function varargout = orthovecs(varargout)
% ORTHOVECS     reshapes vector input arguments to be vectors in mutually
% orthogonal dimmensions
%   [A1, A2, ..., An] = orthovecs(V1, V2, ..., Vn) returns n arrays A1, A2,
%   ..., An where for 1 <= k <= n, Ak(:) will be equal to Vk(:) and Ak will
%   be a vector in the kth dimmension.

% Input Validation
arguments (Repeating)
    varargout (:, 1)
end
for i = 2:nargout
    varargout{i} = reshape(varargout{i}, ...
        [ones([1 i - 1]) numel(varargout{i})]);
end
