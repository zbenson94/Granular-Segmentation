% Load in the different extractions assuming the frames are labeled
function ext = loadExtractions(n0,nFrames,saveDir,doOri,cropbad)

    % Default variables
    if(~exist('cropbad','var'))
        cropbad = false;
    end
    if(~exist('doOri','var'))
        doOri = false;
    end
    
    ext   = [];
    frame = 1;
    for n = n0:n0+nFrames
        disp(['n: ',num2str(n)]); 
        if(doOri)
            load(sprintf('%sorientations_new_%04d.mat',saveDir,n),'out');
        else
            load(sprintf('%sxyz_%04d.mat',saveDir,n),'xyzp');
            out = xyzp;
        end
        if(cropbad)
            load(sprintf('%sgood_IDs_%04d.mat',saveDir,n),'good_IDs');
            if(cropbad == 1)
                out = out((good_IDs>0),:);
            else
                out = out(~(good_IDs>0),:);
            end
        end
        ext = [ext;[out,frame*ones(length(out(:,1)),1)]];
        frame = frame + 1;
    end
end