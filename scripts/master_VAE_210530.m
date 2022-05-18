% -------------------------------------------------------------------------
%   Author: ZAB
%   Date:   19 May 2021
% -------------------------------------------------------------------------
%%
if (ispc)
    addpath(genpath('X:\Zack\lib\MATLAB\ImageAnalysis'));
else
    addpath(genpath(['/Volumes/GranularExperimentsData/',...
                        'Zack/lib/MATLAB/ImageAnalysis']));
end

date                = '210530';
[saveDir,loadDir]   = getDirectories(date);

zmax    = 270;
radius  = 14;
%% Get all the positions
for n = [500]
    getPositionsforVAE(n,saveDir,loadDir,zmax,radius,12,10);
end
%%

for n = 17
    getPositionsforVAE(n,saveDir,loadDir,zmax,radius);
    load(sprintf('%sIMS_filt_%04d.mat',saveDir,n));
    load(sprintf('%sxyz_VAE_%04d.mat',saveDir,n));
    [~,IMS_sph] = drawcyl(IMS_filt,xyzp,ori,radius,0,0);
end
%%
green = zeros(size(IMS_filt,1),size(IMS_filt,2),3);
green(:,:,1) = 1;
figure(1);
for i = 50
    imagesc(IMS_filt(:,:,i));
    colormap('gray');
    hold on
    
    iob_p = bwperim(IMS_sph(:,:,i));
    h = imshow(green);
    set(h,'AlphaData',iob_p);
    
    hold off
    drawnow;

end
