function [ numlines ] = countLines( filename )
%COUNTLINES Count the number of lines in a file
%   by using wc in Unix and a perl script in windows
%   taken from http://stackoverflow.com/a/12176649/1000257

if (isunix) %# Linux, mac
    [~, result] = system( ['wc -l ', filename] );
    numlines = str2double(result);
elseif (ispc) %# Windows
    numlines = str2double( perl('countLines.pl', filename) );
else
    error('Count lines works only on unix or windows operating systems');
end

end