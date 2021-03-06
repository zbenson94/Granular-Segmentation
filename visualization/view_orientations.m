% -------------------------------------------------------------------------
% Author: ZAB
% DATE:   17 February 2020
% -------------------------------------------------------------------------
% This will make part of a figure for the paper
% -------------------------------------------------------------------------
line='-------------------------------------------------------------------';

% location of the codes on LosertLab NAS
addpath(genpath('Z:\lib\MATLAB\ImageAnalysis'));

date                = '210409';
[saveDir,loadDir]   = getDirectories(date);
%%
radius  = 14;

load([saveDir,'tracks_beginning.mat'],'tracks');
n = 17;

% load([saveDir,'orientations_',num2str(n),'.mat'],'ori');

load([saveDir,'ori_tracks_beginning.mat'],'ori_tracks');

xyz = tracks(tracks(:,5)==n,1:3);
ori = ori_tracks(ori_tracks(:,7)==n,1:6);
    
file = [loadDir,'Scan_',num2str(n),'.hdf5'];

tic
load(sprintf('%sIMS_filt_%04d.mat',saveDir,n),'IMS_filt');
[IMS_cyl,IMS_sph] = drawcyl(IMS_filt,xyz,ori,radius,4,1);

%%
green = zeros(size(IMS_filt,1),size(IMS_filt,2),3);
green(:,:,1) = 1;
figure(1);
for i = 200
    imagesc(IMS_filt(:,:,i));
    colormap('gray');
    hold on
    
    iob_p = bwperim(IMS_sph(:,:,i));
    h = imshow(green);
    set(h,'AlphaData',iob_p);
    
    iob_b = bwperim(IMS_cyl(:,:,i));
    h = imshow(green);
    set(h,'AlphaData',iob_b);
    hold off
    drawnow;

end

saveas(gcf,'X:\Zack\papers\experiments\Figures\figure3.svg');
%%
figure(4);
imagesc(A(:,:,radius+1,5000))
drawnow;
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------