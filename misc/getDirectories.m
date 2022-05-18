function [saveDir,loadDir] = getDirectories(date)


    if(ispc)
        saveDir = ['Z:\twoholeanalysis\',date,'\'];
        % location of raw data on Granular NAS
        loadDir = ['Z:\ExperimentsRawData\CyclicCompressionTwoHoles\Experiment_',date,'\'];
    else
        saveDir = ['/Volumes/GranularExperimentsData/twoholeanalysis/',date,'/'];
        % location of raw data on Granular NAS
        loadDir = ['/Volumes/GranularExperimentsData/ExperimentsRawData/CyclicCompressionTwoHoles/Experiment_',date,'/'];
    end
    if(~exist(saveDir,'dir'))
        mkdir(saveDir);
    end
    
end
