function [xc,yc,zc] = isolate_chunk(xyz,radius)

    mesh = -radius:radius;
    xc = mesh + floor(xyz(1));
    yc = mesh + floor(xyz(2));
    zc = mesh + floor(xyz(3));
end