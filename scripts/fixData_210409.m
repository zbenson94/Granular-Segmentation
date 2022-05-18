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
n0      = 6480;
% Number of images in the experiment
nImages = n0:n0+nFrames;


load(sprintf('%sIMS_filt_%04d.mat',saveDir,n0),'IMS_filt');
%%

xyz = loadExtractions(n0,0,saveDir,1);
xyz_fixed = xyz;
% xyz_fixed = getBadContacts(xyz,24);
disp(size(xyz_fixed));
%%
[~,IMS_sph] = drawcyl(IMS_filt,xyz_fixed(:,1:3),[],radius-2,0,0);
%%
close all
green = zeros(size(IMS_filt,1),size(IMS_filt,2),3);
green(:,:,2) = 1;
figure(1);
movegui(gcf,[200,200]);
for i = 1:size(IMS_filt,3)
    imagesc(IMS_filt(:,:,i));
    colormap('gray');
    hold on
    
    iob_p = bwperim(IMS_sph(:,:,i));
    h = imshow(green);
    set(h,'AlphaData',iob_p);
    
    hold off
    drawnow;

end
