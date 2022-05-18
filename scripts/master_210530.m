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
date                = '210530';
[saveDir,loadDir]   = getDirectories(date);

nCycles = 10;
nScans  = 16;
nFrames = nScans*nCycles;
zmax    = 270;
radius  = 14;
n0      = 21*nScans+2;
% Number of images in the experiment
nImages = n0:n0+nFrames;
%% Get all the positions
for n = nImages
    getPositions(n,saveDir,loadDir,zmax,radius,12,10);
end
% -------------------------------------------------------------------------
%%                      generate the rotating filter
% -------------------------------------------------------------------------
rcyl              = 4.0;                      % radius of hole in pixels
radius            = 14;
nAngles           = 8100;                     % angle resolution
A = rotatingLOGfilter(radius,rcyl,nAngles);
nImages = n0:n0+nFrames;
% -------------------------------------------------------------------------
%%                        extract the orientations
% -------------------------------------------------------------------------
cntr = 1;
for n = nImages
    disp(n);
    load(sprintf('%sIMS_filt_%04d.mat',saveDir,n),'IMS_filt');
    load(sprintf('%sxyz_%04d.mat',saveDir,n),'xyzp');
    ori = getOrientation(IMS_filt,A,xyzp,radius);
    out = [xyzp,ori];
    save(sprintf('%sorientations_new_%04d.mat',saveDir,n),'out');
    cntr = cntr + 1;
end
