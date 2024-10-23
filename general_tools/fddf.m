function datpath = fddf(fp)
% FDDF FileDirectoryDataFile in this library, data integral to functions is
% typically stored in Data.mat files colocated with the function files in
% the directory. This function is designed to help retrieve these files in
% a regular manner without making explicit references to the directory
% structure, or changing the working directory of the caller. fddf should
% be called with mfilename("fullpath") provided as an input argument,
%   datpath = fddf(mfilename("fullpath"));
datpath = folderFromPath(fp) + "Data.mat";