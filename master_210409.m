% -------------------------------------------------------------------------
%   Author: ZAB
%   Date:   19 May 2021
% -------------------------------------------------------------------------
%% Add the directories to the PATH
% -------------------------------------------------------------------------
if (ispc)
    addpath(genpath('X:\Zack\lib\MATLAB\ImageAnalysis'));
else
    addpath(genpath(['/Volumes/GranularExperimentsData/',...
                        'Zack/lib/MATLAB/ImageAnalysis']));
end


% Experiment date
date                = '210409';
[saveDir,loadDir]   = getDirectories(date);

nCycles = 10;
nScans  = 16;
nFrames = nScans*nCycles;
zmax    = 270;
radius  = 14;
n0      = 6417;
% Number of images in the experiment
nImages = n0:n0+nFrames;
% -------------------------------------------------------------------------
%% Get all the positions
% -------------------------------------------------------------------------
for n = nImages
%     load(sprintf('%sIMS_filt_%04d.mat',saveDir,n),'IMS_filt');
    getPositions(n,saveDir,loadDir,zmax,radius,12,10);
end
% -------------------------------------------------------------------------
%%                      generate the rotating filter
% -------------------------------------------------------------------------
rcyl       = 4.5;                  % radius of hole in pixels
radius     = 13;                   % radius of the bead
nAngles    = 8100;                 % angle resolution
A          = rotatingLOGfilter(radius,rcyl,nAngles);
% -------------------------------------------------------------------------
%%                        extract the orientations
% -------------------------------------------------------------------------
cntr = 1;
for n = nImages
    fprintf('%04d\n',n);
    
    load(sprintf('%sIMS_filt_%04d.mat',saveDir,n),'IMS_filt');
    load(sprintf('%sxyz_%04d.mat',saveDir,n),'xyzp');
    
    ori = getOrientation(IMS_filt,A,xyzp,radius);
    out = [xyzp,ori];
    
    save(sprintf('%sorientations_%04d.mat',saveDir,n),'out');
    cntr = cntr + 1;
end