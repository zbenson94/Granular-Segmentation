function C = logfilter2D(IMG,radius,numAngles)
    % Author: Zackery A. Benson
    % ----
    % Returns a rotating LOG filter to extract orientations
    % IMG is the input image
    % radius corresponds to the size of the filament
    % numAngles is the amount of angles used
    % ----
    % returns a 3D matrix with the third dimension being the convolution at 
    % that specific angle.
    % ----
    mesh  = -2*radius:2*radius;
    [X,Y] = meshgrid(mesh);

    C = zeros([size(IMG),numAngles]);

    theta = linspace(0,pi,numAngles);

    rsq  = X.*X + Y.*Y;

    for i = 1:numAngles
        % rotate the meshgrid
        Xr   = X*cos(theta(i)) + Y*sin(theta(i));
        % LOG kernel
        filt = -exp(-rsq/(2*radius*radius));
        filt = filt.* (Xr.*Xr - radius*radius)/radius^4;
        % run the convolution
        C(:,:,i) = imfilter(IMG,filt);
    end
end

