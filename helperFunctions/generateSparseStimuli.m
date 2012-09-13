function stimulusInfo=generateSparseStimuli(q)

xLocations=q.screenRect(3)/q.spnSpotSize;
yLocations=q.screenRect(4)/q.spnSpotSize;
stimulusInfo.stimuliSp=zeros(xLocations, yLocations, q.nStimFrames);
prevSpots=[];
for i=1:q.nStimFrames
    nSpots=round(q.meanSpots+q.stdSpots*randn(1));
    randomSpots=randperm(xLocations*yLocations, nSpots);
    while sum(ismember(randomSpots, prevSpots))>0
        randomSpots=randperm(xLocations*yLocations, nSpots);
    end
    g=zeros(xLocations, yLocations);
    g(randomSpots)=(randi(2, nSpots, 1)-1)*2-1;
    stimulusInfo.stimuliSp(:, :, i)=g;
    prevSpots=randomSpots;
end
end