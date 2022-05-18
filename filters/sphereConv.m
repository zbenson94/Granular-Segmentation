function Result = sphereConv(IMS,CrIM,radius,sigma,thresh,areaThresh)

mesh    = -radius:radius;
[X,Y,Z] = meshgrid(mesh);
sFilt   = size(X);
sIMS    = size(IMS);

% Preallocate the FFTN memory
A   = zeros(sFilt + sIMS + [1 1 1]);
B   = zeros(size(A));

% Create the gaussian filter
r       = sqrt(X.*X + Y.*Y + Z.*Z);
gfilt   = exp(-(r-radius).*(r-radius) / (2*sigma^2));
gfilt   = gfilt / sum(gfilt(:));
gfilt   = -gfilt.*(r-radius)/sigma^2;

% Do the convolution
B(1:sFilt(1),1:sFilt(2),1:sFilt(3)) = gfilt;
A(1:sIMS(1),1:sIMS(2),1:sIMS(3))    = IMS;
C   = ifftn(fftn(B).*fftn(A));
C   = C(sFilt(1):sIMS(1),...
        sFilt(2):sIMS(2),...
        sFilt(3):sIMS(3));

% Threshold for the beads
L    = bwlabeln(C > thresh);
reg  = regionprops(L,'Area');

% Threshold on the area
idx = find([reg.Area]>=areaThresh);
s   = regionprops(bwlabeln(ismember(L,idx)),'PixelIdxList','PixelList');

Result = zeros(numel(s),4);
disp(['Found:',num2str(numel(s)),' beads']);

% Find the CoM of all the grains
for k = 1:numel(s)
    idx   = s(k).PixelIdxList;
    pvall = double(CrIM(idx)) + 0.0001;
    ptot  = sum(pvall);
    x     = s(k).PixelList(:,1);
    y     = s(k).PixelList(:,2);
    z     = s(k).PixelList(:,3);
    
    ybar  = sum(x.*pvall)/ptot+radius;
    xbar  = sum(y.*pvall)/ptot+radius;
    zbar  = sum(z.*pvall)/ptot+radius;
    
    Result(k,:) = [xbar ybar zbar ptot];
    
end    
end