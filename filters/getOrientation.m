function [out,con,xyz] = getOrientation(IMS,A,Result,radius)

% Get the xyz positions of the spherical surface
nAngles = length(A(1,1,1,:));
[~,xyz] = SpherePoints(nAngles,'full');
nBeads  = length(Result(:,1));
mesh    = -radius:radius;
[X,Y,Z] = meshgrid(mesh);
sph = X.*X + Y.*Y + Z.*Z <= radius^2 ;  % zero the surrounding fluid
%--------------------------------------------------------------------------
%                       MEMORY PREALLOCATION
%--------------------------------------------------------------------------
angles      = gpuArray(zeros(nBeads,6));               % Orientation
%--------------------------------------------------------------------------
%           BEGIN LOOPING THROUGH BEADS TO EXTRACT ORIENTATIONS
%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
% In order to save time, it might be beneficial to find all [phi theta]
% combinations that are perpendicular to the [phi,theta] that was extracted
% initially -- use a cross product
% -------------------------------------------------------------------------
% Plane perpendicular to a vector is given by the following equation: 
%           
%       vector = < a b c > = < sin(theta)cos(phi) 
%                              sin(theta)sin(phi)
%                              cos(theta) > 
%       
%       a x + b y + c z == 0 ;  sin(theta0)sin(theta) * 
%                        (cos(phi)cos(phi0) + sin(phi)sin(phi0)) + 
%                                   c cos(theta0)
%               
%   eq = sin(theta0)sin(theta)cos(phi0 - phi) + cos(theta)cos(theta0) == 0            
% -------------------------------------------------------------------------
IMS_bin = gpuArray(IMS);
gpuA    = gpuArray(A);
x = xyz(:,1);
y = xyz(:,2);
z = xyz(:,3);

tic
% loop through beads
for i = 1:size(Result,1) 
    if(mod(i,1000)==0)
        disp(i);
        toc
        tic
    end
    % isolate the pixels corresponding to the bead
    [xc,yc,zc] = isolate_chunk(Result(i,1:3),radius);
    
    % Invert the image
    BEAD = IMS_bin(xc,yc,zc);
    BEAD = max(BEAD(:)) - BEAD;
    BEAD = BEAD.*sph;
    % Convolution
    B = reshape(repmat(BEAD,1,1,1,...
        nAngles),...
        [size(BEAD),nAngles]);
    con     = squeeze(sum(sum(sum(gpuA.*B,1),2),3)); % apply the filter
    % ---------------------------------------------------------------------
    % Find the maximum value in the convolution
    % ---------------------------------------------------------------------
    angles(i,1:3) = xyz(con==max(con(:)),:);
    % ---------------------------------------------------------------------
    % constraint that the other hole is perpendicular to the other
    % ---------------------------------------------------------------------
    mat             = x.*angles(i,1) + y.*angles(i,2) + z.*angles(i,3); 
    bin             = (mat <= 1e-1 & mat >= -1e-1);
    xyz_red         = xyz(bin,:);
    zz              = con(bin);
    angles(i,4:6)   = xyz_red(zz==max(zz),:);
end
toc

%--------------------------------------------------------------------------
%                   REMOVE FAILED EXTRACTIONS AND SAVE
%--------------------------------------------------------------------------
out = gather(angles);
end