function [angList, xyz] = SpherePoints(n, varargin)
switch varargin{1}
    case 'half'
        n = 2*n;
end
x = 0.1 + 1.2*n;
xyz = [];
angList = [];
val = 1 - (1/(n - 1));
start = -val;
increment = 2*val/(n - 1);
for j = 0:(n - 1)
    s = start + j*increment;
    phi = s*x;
    theta = (pi/2)*sign(s)*(1 - sqrt(1 - abs(s)));
    angList = [angList; [theta, phi]];
end
angList = mod((pi/2 - angList)*180/pi, 360);
xyz = [sind(angList(:, 1)).*cosd(angList(:, 2)), sind(angList(:, 1)).*sind(angList(:, 2)), cosd(angList(:, 1))];
switch varargin{1}
    case 'half'
        badIdx = xyz(:, 3) < 0;
        xyz(badIdx, :) = [];
        angList(badIdx, :) = [];
end