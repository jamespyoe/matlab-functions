function tf = istext(text)
% copy of private mathworks function for validating text classes
    tf = (ischar(text) && (isrow(text) || isequal(size(text),[0 0]))) ...
        || isstring(text) || iscell(text) && ...
        matlab.internal.datatypes.isCharStrings(text);
end