function feature = feature_joint_spatial_color_patch(imageFile)

% Usages:
%  feature = feature_joint_spatial_color_patch(imageFile) 
%  computes feature extracted from joint distribution of the joint spatial
%  color local patches, by the means of the rigid body moment. The input 
%  "imageFile" is a filepath. The output "feature" is a column vector.
%
% Example:
%  feature = feature_joint_spatial_color_patch('test_image_1.jpg'); 
%
% By Tian Tsong Ng, July 2005



% ## binning matrices

% load(fullfile('patch_model','voronoiCell_template.mat'),...
%     'D','Lamda','normAllCell','A');

load(fullfile('voronoiCell_template.mat'),...
    'D','Lamda','normAllCell','A');

histLength = size(normAllCell,1);


cross0 = [-1 , 1 ;
    0 , 0];
cross45 = [1 , -1 ;
    -1, 1];
cross90 = [0 , 0;
    -1 , 1];
cross145 = [1 , -1 ;
    1 , -1];

cross{1} =  cross45;
cross{2} =  cross0;
cross{3} =  cross145;
cross{4} =  cross90;


% ##

scaleSpace = 0.5;

totalPatch = 3000;

saveMeanVector = cell(2);
saveDistFromCentriodMean = cell(2);
saveDistFromCentriodVar = cell(2);
saveMomentOfEnertia = cell(2);

% check whether is a image file name or an image matrix
if ischar(imageFile)
    im = imread(imageFile);
else
    im = imageFile;
end
im = im2double(im);

grayIm = rgb2gray(im);

hx = ss_derivative_gaussian(grayIm,'x',scaleSpace);
hy = ss_derivative_gaussian(grayIm,'y',scaleSpace);

I = hx == 0;
dummyhx = hx;
dummyhx(I) = 10^-10;

hdir = round(atan(hy./dummyhx)/(pi/4));
hdir(hdir==-2) = 2;
hdir = hdir + 2;

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

        crossM = cross{hdir(sr,sc)};

        a1 = im(sr+crossM(1,1),sc+crossM(2,1),:);
        a2 = im(sr,sc,:);
        a3 = im(sr+crossM(1,2),sc+crossM(2,2),:);

        x = [a1(:) ; a2(:) ; a3(:)];

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

        tempMatrix2 = tempMatrix.^2;
        tempMatrix2Sum = sum(tempMatrix2,2);

        for axisC = 1:8
            tempEnertia(axisC) = mean(tempMatrix2Sum-tempMatrix2(:,axisC));
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


