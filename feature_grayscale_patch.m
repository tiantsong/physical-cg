function feature = feature_grayscale_patch(imageFile)

% Usages:
%  feature = feature_grayscale_patch(imageFile) 
%  computes feature extracted from joint distribution of the grayscale 
%  local patches, by the means of the rigid body moment. The input 
%  "imageFile" is a filepath. The output "feature" is a column vector.
%
% Example:
%  feature = feature_grayscale_patch('test_image_1.jpg'); 
%
% By Tian Tsong Ng, July 2005


% ## binning matrices

% load(fullfile('patch_model','voronoiCell_template.mat'),...
%     'D','Lamda','normAllCell','A');

load(fullfile('voronoiCell_template.mat'),...
    'D','Lamda','normAllCell','A');

histLength = size(normAllCell,1);

% ##

scaleSpace = 0.5;


totalPatch = 3000;

saveMeanVector = cell(2);
saveDistFromCentriodMean = cell(2);
saveDistFromCentriodVar = cell(2);
saveMomentOfEnertia = cell(2);

tempEnertia = zeros(1,8);

% check whether is a image file name or an image matrix
if ischar(imageFile)
    im = imread(imageFile);
else
    im = imageFile;
end
im = rgb2gray(im);
im = im2double(im);

hx = ss_derivative_gaussian(im,'x',scaleSpace);
hy = ss_derivative_gaussian(im,'y',scaleSpace);

imGrad = sqrt(hx.^2 + hy.^2);

set{1} = imGrad < 0.006 & imGrad > 0.001;
set{2} = imGrad >= 0.006;

for setC = 1:2
    set{setC}([1:5 end-5:end],:) = false;
    set{setC}(:,[1:5 end-5:end]) = false;
end

for setC = 1:2

    [RR RC] = find(set{setC});
    setN = length(RR);

    randI = randperm(setN);
    RR = RR(randI);
    RC = RC(randI);

    tempMatrix = zeros(8,totalPatch);
    loopCount = 1;
    patchCount = 1;

    while patchCount <= totalPatch && loopCount <= setN

        sr = RR(loopCount);
        sc = RC(loopCount);
        loopCount = loopCount + 1;

        x = im(sr-1:sr+1,sc-1:sc+1);
        x = x(:);
        mx = (x - sum(x)/9);
        contrast = mx'*D*mx;
        if contrast > 0
            contrast = sqrt(contrast);
            y = mx/contrast;
            v = Lamda*A'*y;
            tempMatrix(:,patchCount) = v(:);
            patchCount = patchCount + 1;
        end
    end


    tempMatrix = tempMatrix(:,1:patchCount-1)';

    if patchCount-1 > 10

        meanV = mean(tempMatrix,1);

        pointN = size(tempMatrix,1);
        dist2FromCentriod = sum((tempMatrix-meanV(ones(pointN,1),:)).^2,2);

        tempMatrix2 = mean(tempMatrix.^2);
        tempMatrix2Sum = sum(tempMatrix2,2);

        for axisC = 1:8
            tempEnertia(axisC) = tempMatrix2Sum-tempMatrix2(:,axisC);
        end

        saveMeanVector{setC} = meanV;
        saveDistFromCentriodMean{setC} = mean(dist2FromCentriod);
        saveDistFromCentriodVar{setC} = var(dist2FromCentriod);
        saveMomentOfEnertia{setC} = tempEnertia;
    else

        fprintf('setC = %d => patchCount = %d\n',setC,patchCount-1);
        saveMeanVector{setC} = zeros(1,8);
        saveDistFromCentriodMean{setC} = 0;
        saveDistFromCentriodVar{setC} = 0;
        saveMomentOfEnertia{setC} = zeros(1,8);
    end
end

feature = [];

for setC = 1:2
    feature = [feature ; saveMeanVector{setC}(:) ; saveDistFromCentriodVar{setC}(:) ; ...
        saveMomentOfEnertia{setC}(:) ; saveDistFromCentriodMean{setC}(:)];
end




