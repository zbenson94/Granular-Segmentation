function [ori0,ori1] = fixRotations(ori_tracks,t0,tf)

    if(tf > 1)
        % Compute the rotation matrices
        ori0 = ori_tracks(ori_tracks(:,7) == t0,1:6);
        ori1 = ori_tracks(ori_tracks(:,7) == tf,1:6);

        % Fix the flips
        ori1_fixed = zeros(size(ori1));

        d0 = abs(dot(ori0(:,1:3),ori1(:,1:3),2));
        d1 = abs(dot(ori0(:,1:3),ori1(:,4:6),2));

        ori1_fixed(d1>d0,1:3)  = ori1(d1>d0,4:6);
        ori1_fixed(d1>d0,4:6)  = ori1(d1>d0,1:3);

        ori1_fixed(d1<=d0,1:3) = ori1(d1<=d0,1:3);
        ori1_fixed(d1<=d0,4:6) = ori1(d1<=d0,4:6);

        % Fix 180 flips
        d0 = dot(ori0(:,1:3),ori1_fixed(:,1:3),2);
        d1 = dot(ori0(:,4:6),ori1_fixed(:,4:6),2);

        ori1_fixed(d0<0,1:3)  = -ori1_fixed(d0<0,1:3);
        ori1_fixed(d1<0,4:6)  = -ori1_fixed(d1<0,4:6);
        
%         % ORTHONORMALIZE
%         dProd =  dot(ori1_fixed(:,1:3),ori1_fixed(:,4:6),2);
%         tmp = zeros(size(ori1_fixed(:,1:3)));
%         tmp(:,1) = ori1_fixed(:,4) - dProd .* ori1_fixed(:,1);
%         tmp(:,2) = ori1_fixed(:,5) - dProd .* ori1_fixed(:,2);
%         tmp(:,3) = ori1_fixed(:,6) - dProd .* ori1_fixed(:,3);
%         
%         tmp(:,1) = tmp(:,1) ./ sqrt(dot(tmp,tmp,2));
%         tmp(:,2) = tmp(:,2) ./ sqrt(dot(tmp,tmp,2));
%         tmp(:,3) = tmp(:,3) ./ sqrt(dot(tmp,tmp,2));
% 
%         ori1_fixed(:,4:6) = tmp;
    end


    if(tf == 1)    
        ori0 = ori_tracks(ori_tracks(:,7) == tf,1:6);
% 
%         % ORTHONORMALIZE
%         dProd =  dot(ori0(:,1:3),ori0(:,4:6),2);
%         tmp = zeros(size(ori0(:,1:3)));
%         tmp(:,1) = ori0(:,4) - dProd .* ori0(:,1);
%         tmp(:,2) = ori0(:,5) - dProd .* ori0(:,2);
%         tmp(:,3) = ori0(:,6) - dProd .* ori0(:,3);
%         
%         tmp(:,1) = tmp(:,1) ./ sqrt(dot(tmp,tmp,2));
%         tmp(:,2) = tmp(:,2) ./ sqrt(dot(tmp,tmp,2));
%         tmp(:,3) = tmp(:,3) ./ sqrt(dot(tmp,tmp,2));
%         ori0(:,4:6) = tmp;
        ori1 = ori0;
    else
        ori1 = ori1_fixed;
    end

end
