function [IMS_cyl,IMS_sph] = drawcyl(IMS,xyz,radius,rcyl)

% If the cylinder size is given, then I make the cylinders.
if(~exist('rcyl','var'))
    doOri = false;
else
    doOri = true;
end

% Draws the cylinders for visualization
nSphere = length(xyz(:,1));
IMS_cyl = zeros(size(IMS));
IMS_sph = IMS_cyl;
mesh    = -radius:radius;
[X,Y,Z] = meshgrid(mesh,mesh,mesh);
for n = 1:nSphere
   
    xcord = mesh + round(xyz(n,1));
    ycord = mesh + round(xyz(n,2));
    zcord = mesh + round(xyz(n,3));
   
    if(doOri)
        % location of the first axis
        [Xr,Yr,Zr] = alignZaxis(xyz(n,4:6),X,Y,Z);
        cyl1       = (Xr.^2 + Yr.^2 <= rcyl^2 ) & ...
                      Xr.^2 + Yr.^2 + Zr.^2 <= radius^2;
                  
        % location of the other axis
        [Xr,Yr,Zr] = alignZaxis(xyz(n,7:9),X,Y,Z);
        cyl2       = (Xr.^2 + Yr.^2 <= rcyl^2 ) & ...
                      Xr.^2 + Yr.^2 + Zr.^2 <= radius^2;
                  
        IMS_cyl(xcord,ycord,zcord) = ...
            IMS_cyl(xcord,ycord,zcord) + cyl1 + cyl2;
    end
    % Creates the spheres
    sph = (X.*X + Y.*Y + Z.*Z) <= radius*radius;
    IMS_sph(xcord,ycord,zcord) = ...
            IMS_sph(xcord,ycord,zcord) + sph;      

end
end