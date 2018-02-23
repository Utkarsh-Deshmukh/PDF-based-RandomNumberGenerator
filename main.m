clear;  close all;  clc

numSamples = 9e5;                   % This is the number of random samples to generate. ideally this number would be infinity. select a large number.
numReqBins = 100;                   % This is the number of bins needed. the output will be a random number between 1 and numReqBins
numOriBins = numReqBins*10;         % Selecting a large number of bins for the input. this is a uniformly sampled random data

params.distributionType = 'sinusoid';       % this is the shape of output distribution.     available options:  'Gaussian', 'sinusoid', 'DampedSinusoid', 'sincWave', 'log'

if(strcmp(params.distributionType, 'Gaussian'))
    distribution = fspecial('gaussian', [numReqBins, 1], 7);
elseif(strcmp(params.distributionType, 'sinusoid'))
    x = 10*linspace(0,180, numReqBins);
    distribution = sind(x);
elseif(strcmp(params.distributionType, 'DampedSinusoid'))
    x = 10*linspace(0,180, numReqBins);
    distribution = exp(-x/800) .* sind(x);
elseif(strcmp(params.distributionType, 'sincWave'))
    x = 2*linspace(1,360, numReqBins/2);
    distribution = [fliplr(sind(x)./x), sind(x)./x];
elseif(strcmp(params.distributionType, 'log'))
    x = 2*linspace(1,360, numReqBins);
    distribution = log(x);
end
    
distribution = distribution - min(distribution);    % shifting the distribution such that it is non negative.
distribution = distribution/sum(distribution);      % normalising the distribution such that its sum is 1
weights = floor(distribution * numOriBins);         % Generating bucket weights

%%Create Dictionary
dict = zeros(sum(weights),1);
count = 0;
for(i=1:numel(weights))
    for(j=1:weights(i))
        count = count + 1;
        dict(count) = i;
    end
end

% initialising the outputs.
inputHist = zeros(numOriBins,1);
outputHist = zeros(numReqBins,1);
oriSamplesRec = randi(sum(weights), [numSamples, 1]);       % These are the input samples generated using a uniform distribution random number generator

% Generate random samples.
output = zeros(numSamples, 1);
for(i=1:numSamples)
    currSample = oriSamplesRec(i);
    inputHist(currSample) = inputHist(currSample) + 1;
    output(i) = dict(currSample);                           % This is the output random samples. They will have the desired distribution.
    outputHist(dict(currSample)) = outputHist(dict(currSample)) + 1;    % This is the histogram of the output random samples. This is to validate whether the distribution of the output match the required distribution.
end


% visualise
subplot(3,1,1);bar(inputHist);  xlabel('input value', 'fontsize', 13); ylabel('number of occurrences', 'fontsize', 13);    title('distribution of the input random numbers', 'fontsize',15);
subplot(3,1,2);plot(distribution); xlabel('samples number', 'fontsize', 13); ylabel('desired number of occurrences', 'fontsize', 13);    title('desired distribution ', 'fontsize',15);
subplot(3,1,3);bar(outputHist); xlabel('output value', 'fontsize', 13); ylabel('number of occurrences', 'fontsize', 13);    title('distribution of the generated random numbers', 'fontsize',15);
