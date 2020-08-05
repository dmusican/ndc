% NORMALLY DISTRIBUTED CLUSTERS data generator.
% Generate a series of random centers for multivariate normal
% distributions. Randomly generate a fraction for this center, i.e. what
% fraction of points we will get from this center. Randomly generate a
% separating plane. Based on plane, choose classes for centers. Then
% randomly generate the points from the distributions. Can increase
% inseparability by increasng variances of distributions. We will get
% measure of "true" separability by looking at how many points ended up
% on the opposite sides of the line.
% All values are taken as integers for simplicity.
%
% Copyright (C) 2000 David R. Musicant and Olvi L. Mangasarian.
% Version 1.0
% This software is free for academic and research use only.
% For commercial use, contact musicant@cs.wisc.edu.

rand('state',91225);
randn('state',19481);
lowBound = -50;
highBound =50;
nCenters = 20;
nCols = 32;
nRows = 20000;
nTestRows = 0.01 * nRows;
nBufferPoints = 100000;
nExpandFactor = 10;    % How much to stretch the covariance matrix
sTrainFile = 'outtrain.txt';
sTestFile = 'outtest.txt';

% Generate the centers according to a uniform distibution.
mCenters = round(lowBound + rand(nCenters,nCols)*(highBound-lowBound));

% Generate the variances and covariances randomly to create a matrix for
% each center
mCovariance = zeros(nCols,nCols);
cCovariance = cell(nCenters,1);
for i = 1:nCenters,
  mRootCovariance = nExpandFactor *  ...
      rand(nCols,nCols)*(highBound-lowBound) / 50;
  cCovariance{i} = mRootCovariance' * mRootCovariance;
end;
    
% Determine what proportion of points will come from each center, then
% create a cdf to use in deciding which to generate.
vPointFraction = rand(nCenters,1);
vPointFraction = vPointFraction / sum(vPointFraction);
vPointCdf = zeros(1,nCenters);
for i = 1:nCenters,
  vPointCdf(i) = sum(vPointFraction(1:i));
end;

% Create a random separating plane.
w = -2 + rand(nCols,1)*4;
gamma = lowBound / 10 + rand * (highBound-lowBound)/10;

% Now choose which classes to which each center belongs
vCenterClasses = sign(mCenters * w - gamma * ones(nCenters,1));
vZeroSpots = find(vCenterClasses==0);
vCenterClasses(vZeroSpots) = ones(length(vZeroSpots),1);

% Prepare output file
flatfile([],sTrainFile,0);
flatfile([],sTestFile,0);

% Now go through and begin generating random points.
% Do it twice: once for testing, once for training.

for nDataset = 1:2,
  
  if (nDataset==1)
    nRowsLeft = nRows;
    sOutputFile = sTrainFile;
    nTotRows = nRows;
  else
    nRowsLeft = nTestRows;
    sOutputFile = sTestFile;
    nTotRows = nTestRows;
  end;
  
  nMisclass = 0;
  nTrainingClass1 = 0;
  nTrainingClassm1 = 0;

  while (nRowsLeft > 0)
    disp(sprintf('Rows left = %d',nRowsLeft));
    nRowsNow = min(nBufferPoints,nRowsLeft);
    nRowsLeft = nRowsLeft - nRowsNow;
    mNewPoints = zeros(nRowsNow,nCols);
    vPointCenters = zeros(nRowsNow,1);
    
    % Determine which center each point should belong to
    vRandomNumbers = rand(nRowsNow,1);
    for i = nCenters:-1:1,
      vCenterMatch = (vRandomNumbers <= vPointCdf(i));
      vPointCenters([vCenterMatch]) = i;
    end;
    
    % Create a vector of training classes for each point
    vTrainingClasses = zeros(nRowsNow,1);
    
    % Within each class, generate an appropriate number of random points.
    for i = 1:nCenters,
      vIndices = (vPointCenters==i);
      nPoints = sum(vIndices);
      vTrainingClasses(vIndices) = vCenterClasses(i);
      mNewPoints(vIndices,:) = round( ...
	  mvnrnd(mCenters(i,:),cCovariance{i},nPoints));
      
      % Count how many points are incorrectly classified
      vFitClass = sign(mNewPoints(vIndices,:) * w - gamma * ...
	  ones(nPoints,1));
      vZeroSpots = find(vFitClass==0);
      vFitClass(vZeroSpots) = ones(length(vZeroSpots),1);
      nMisclass = nMisclass + sum(vFitClass~=vCenterClasses(i));
    end;    %for
    
    % Output the data points to disk
    flatfile([mNewPoints vTrainingClasses],sOutputFile,1);
    nTrainingClass1 = nTrainingClass1 + sum(vTrainingClasses==1);
    nTrainingClassm1 = nTrainingClassm1 + sum(vTrainingClasses==-1);
    
  end;  %while

  disp(sprintf('Percent separable estimate = %4.2f%%\n',100*(1-nMisclass/nTotRows)));
  disp(sprintf('Number class  1 points = %d\n',nTrainingClass1));
  disp(sprintf('Number class -1 points = %d\n',nTrainingClassm1));

end; %for-nDataset


