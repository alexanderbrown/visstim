function stimulusInfo = sparseNoise(q)
% This function displays a drifting retinotopy stimulus, untriggered
%
% Inputs:
%
%   q - structure with all parameters entered in to or calculated in
%   VisStimAlex
%
% Ouput:
stimulusInfo=setstimulusinfobasicparams(q);
stimulusInfo=generateSparseStimuli(q,stimulusInfo);

Screen('FillRect', q.window, 0); %fill with black as a signal for the diode
Screen('Flip', q.window);
KbWait();                   %Wait for keypress to start
WaitSecs(1);

Screen('FillRect', q.window, 127); %fill with grey
Screen('Flip', q.window);
tic        %start the timer
WaitSecs(q.baseLineTime) %and wait during baseline
stimulusInfo.actualBaseLineTime=toc;

for i=1:q.nStimFrames;
    [r,c,v]=find(stimulusInfo.stimuliSp(:,:,i));
    v=convertSpotStateGreyscale(v)';
    v=cat(1, v, v, v);
    
    Screen('FillRect', q.window, 127);
    Screen('DrawDots', q.window, cat(2, r, c)'*q.spnSpotSize, q.spnSpotSize, v,[],1);
    Screen('Flip', q.window);
    stimulusInfo.stimuli(i).startTime=toc;
    for delay=2:round(q.spotTime/q.ifi)         %Wait the requested time by calculating the correct
        Screen('FillRect', q.window, 127);      %number of screen flips, and executing them.
        Screen('DrawDots', q.window, cat(2, r, c)'*q.spnSpotSize, q.spnSpotSize, v,[],1);
        Screen('Flip', q.window);       
    end     
    %Quit only if 'esc' key was pressed
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('escape')), error('escape'), end
end

Screen('FillRect', q.window, 0); %fill with black as a signal for the diode
Screen('Flip', q.window);
stimulusInfo.experimentEndTime=toc;
WaitSecs(1);