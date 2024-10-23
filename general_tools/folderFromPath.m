function folder = folderFromPath(fp)
% FOLDERFROMPATH takes a file path and returns that file path with the file
% name removed. The returned char vector folder is the path to the folder
% containing that file.

% NOTE: passing the name of a file in the working directory of the caller
% will pass argument validation, but without a directory structure
% folderFromPath returns an empty char array
arguments
    fp char {mustBeFile}
end
% returns the substring of the filepath fp from the first character up to
% and excluding the last filesep character ('\' or '/' depending on OS) 
folder = fp(1:find(fp == filesep, 1, "last")-1);