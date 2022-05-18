function A = rotatingLOGfilter(radius,rcyl,nAngles)
% -------------------------------------------------------------------------
% Returns a 4D rotating LOG filter
% -------------------------------------------------------------------------
mesh            = -radius:radius;     % meshgrid values
l               = length(mesh);       % length of the meshgrid values
[X,Y,Z]         = meshgrid(mesh);     % meshgrid

% Angle points
[~, xyz]  = SpherePoints(nAngles, 'full');

% Preallocate filter memory
A        = zeros(l,l,l,nAngles);   

for k = 1:nAngles
    
        if(abs(dot(xyz(k,:),[0,0,1])) < 1)
            [Xr,Yr,Zr]   = alignZaxis(xyz(k,:),X,Y,Z);
        else
            Xr = X;
            Yr = Y;
            Zr = Z;
        end
        % LOG function
        rsq     = Xr.*Xr + Yr.*Yr;
        rsigma  = 0.5*(radius+rcyl);
        zfilt   = exp(-(Zr-rsigma).^2/(2*(rsigma/2.0).^2));
        zfilt   = zfilt + exp(-(Zr+rsigma).^2/(2*(rsigma/2.0).^2));
        
        gfilt   = exp(-rsq / (2 * rcyl ^ 2 )).* zfilt ;
        gfilt   = gfilt .* (X.*X + Y.*Y + Z.*Z < radius*radius);
        gfilt   = gfilt / sum(gfilt(:));
        gfilt   = -gfilt .* (Xr.*Xr + Yr.*Yr - rcyl^2 ) / rcyl ^ 4;
        A(:,:,:,k) = gfilt;
end
end
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
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------