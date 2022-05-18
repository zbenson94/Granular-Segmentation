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
pre                 = 'end';
[saveDir,loadDir]   = getDirectories(date);

nCycles = 10;
nScans  = 16;
nFrames = nScans*nCycles;
zmax    = 270;
radius  = 14;
n0      = 21*nScans + 2;
doOri   = 1;
% Number of images in the experiment
nImages = n0:n0+nFrames;
% -------------------------------------------------------------------------
%%                      load the extractions here
% -------------------------------------------------------------------------
ext                 = loadExtractions(n0,nFrames,saveDir,doOri);
% -------------------------------------------------------------------------
%%                    center of mass tracking code
% -------------------------------------------------------------------------
param.dim   = 3;
param.mem   = 0;
param.good  = nFrames+1;
param.quiet = 0;
tracks      = ubertrack(ext,5,param);
%% Fix orientations now
for n = 2:max(tracks(:,11))
    [~,ori1] = fixRotations(tracks(:,5:12),n-1,n);
    tracks(tracks(:,11)==n,5:10) = ori1;
end
%%
disp(max(tracks(:,12)));
save(sprintf('%stracks.ori.%s.%02d.mat',saveDir,pre,nCycles),'tracks');
