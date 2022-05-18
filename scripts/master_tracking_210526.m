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
date                = '210526';
pre                 = 'start';
[saveDir,loadDir]   = getDirectories(date);

nCycles = 10;
nFrames = 16;
zmax    = 270;
radius  = 14;
n0      = 17;
%%
for i = 1:nCycles
n0 = 21*16+2 + (i-1)*nFrames;
% -------------------------------------------------------------------------
%                      load the extractions here
% -------------------------------------------------------------------------
ext                 = loadExtractions(n0,nFrames,saveDir,0,1);
% -------------------------------------------------------------------------
%                    center of mass tracking code
% -------------------------------------------------------------------------
param.dim   = 3;
param.mem   = 0;
param.good  = nFrames+1;
param.quiet = 0 ;
tracks      = ubertrack(ext,8,param);
disp(max(tracks(:,6)));
save(sprintf('%stracks.%s.%04d.mat',saveDir,pre,n0),'tracks');
end
% -------------------------------------------------------------------------
%%                      generate the rotating filter
% -------------------------------------------------------------------------
rcyl       = 4.5;                  % radius of hole in pixels
radius     = 13;                   % radius of the bead
nAngles    = 8100;                 % angle resolution
A          = rotatingLOGfilter(radius,rcyl,nAngles);
% -------------------------------------------------------------------------
%% Get the orientations for each track
% -------------------------------------------------------------------------
for i = 1:nCycles
n0 = 21*16+2 + (i-1)*nFrames;
load(sprintf('%stracks.%s.%04d.mat',saveDir,pre,n0),'tracks');
% -------------------------------------------------------------------------
%                         extract the orientations
% -------------------------------------------------------------------------
cntr = 1;
ori_tracks = [];
for n = 0:nFrames
    disp(n);
    load(sprintf('%sIMS_filt_%04d.mat',saveDir,n0+n),'IMS_filt');
%     load(sprintf('%sxyz_%04d.mat',saveDir,n),'xyzp');
    xyzp = tracks(tracks(:,5)==n+1,:);
    ori = getOrientation(IMS_filt,A,xyzp,radius);
    out = [xyzp(:,1:3),ori,xyzp(:,4:6)];
    ori_tracks = [ori_tracks;out];
    cntr = cntr + 1;
end

save(sprintf('%stracks.ori.%s.%04d.mat',saveDir,pre,n0),'ori_tracks');


end
%% Fix orientations now
for i = 1:nCycles
    n0 = 21*16+2 + (i-1)*nFrames;

    load(sprintf('%stracks.ori.%s.%04d.mat',saveDir,pre,n0),'ori_tracks');
    tracks = ori_tracks;
    for n = 2:max(tracks(:,11))
        [~,ori1] = fixRotations(tracks(:,[4,5,6,7,8,9,11,12]),n-1,n);
        tracks(tracks(:,11)==n,4:9) = ori1;
    end
    save(sprintf('%stracks.ori.fixed.%s.%04d.mat',saveDir,pre,n0),'tracks');
end