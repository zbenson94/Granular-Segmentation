function [] = viewOutline(IMS_filt,i,IMS_sph1,IMS_cyl,color)
% function [] = viewOutline(IMS_filt,i,IMS_sph,color)
% function [] = viewOutline(IMS_filt,i,IMS_sph1,IMS_sph2,color)

    green = zeros(size(IMS_filt,1),size(IMS_filt,2),3);
    blue  = zeros(size(IMS_filt,1),size(IMS_filt,2),3);
    blue(:,:,1) = 1;
    if(exist('color','var'))
        green(:,:,1) = color(1);
        green(:,:,2) = color(2);
        green(:,:,3) = color(3);
    else
        green(:,:,1) = 1;
    end
    
    imagesc(IMS_filt(:,:,i));
    colormap('gray');
    
    hold on
    % Only draw this if it exists
    if(exist('IMS_sph1','var'))
        iob_p = imerode(imdilate(bwperim(IMS_sph1(:,:,i)),strel('disk',1,8)),strel('disk',1,0));
        h = imshow(blue);
        set(h,'AlphaData',iob_p);
    end
    if(exist('IMS_sph2','var'))
        iob_p = bwperim(IMS_sph2(:,:,i));
        h = imshow(green);
        set(h,'AlphaData',iob_p);
    end
    % Only draw this if it exists
    if(exist('IMS_cyl','var'))
        iob_b = imerode(imdilate(bwperim(IMS_cyl(:,:,i)),strel('disk',1,8)),strel('disk',1,0));
        h = imshow(green);
        set(h,'AlphaData',iob_b);
    end
%     hold off
    drawnow;
end