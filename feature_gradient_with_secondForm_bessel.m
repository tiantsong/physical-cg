function feature = feature_gradient_with_secondForm_bessel(imageFile)

% Usages:
%  feature = feature_intensity_with_surface_gradient_bessel(imageFile) 
%  computes feature extracted from joint distribution of the scale-space 
%  (scale = 1) Euclidean gradient image and the scale-space (scale = 1)
%  second fundamental form eigenvalue images, by the means of the
%  rigid body moment. The input "imageFile" is a filepath. The
%  output "feature" is a column vector.
%
% Example:
%  feature = feature_gradient_with_secondForm_bessel('test_image_1.jpg'); 
%
% By Tian Tsong Ng, July 2005



scaleSpace = 1;

offset = 10;

momDim = 9;
tempProdMoment = zeros(1,momDim*(momDim-1)/2);
tempInertiaMoment = zeros(1,momDim);
allOne = ones(1,momDim);

tempMag = [];
tempNInertia = [];
tempNCentroid = [];
tempNProd = [];


% check whether is a image file name or an image matrix
if ischar(imageFile)
    im = imread(imageFile);
else
    im = imageFile;
end
im = im2double(im);
height = size(im,1);
width = size(im,2);

[im,e1,e2] = ss_secondForm_bessel(im,scaleSpace);

e1 = e1(offset:(end-offset),offset:(end-offset),:);
e2 = e2(offset:(end-offset),offset:(end-offset),:);

im = im(offset:(end-offset),offset:(end-offset),:);
height = size(im,1);
width = size(im,2);

e1 = reshape(e1,[height*width 3]);
e2 = reshape(e2,[height*width 3]);
im = reshape(im,[height*width 3]);

e1 = e1/std(e1(:));
e2 = e2/std(e2(:));
im = im/std(im(:));

vectors = [e1(:,1) e2(:,1) im(:,1) e1(:,2) e2(:,2) im(:,2) e1(:,3) e2(:,3) im(:,3)];
clear e1 e2 im

vectors2 = vectors.^2;
mag = sqrt(sum(vectors2,2));

% compute mag features

tempMag = [mean(mag) var(mag) skewness(mag) kurtosis(mag)];


% compute normalized quantities

mag(mag==0) = 1;
uVectors = vectors./mag(:,allOne);

uVectors2 = mean(uVectors.^2,1);
uvectorsSum = sum(uVectors2);

for hC = 1:momDim
    tempInertiaMoment(hC) = uvectorsSum - uVectors2(hC);
end

tempNInertia = tempInertiaMoment;

% compute normalized moment of product

momC = 1;
for rr = 1:momDim
    for cc = (rr+1):momDim
        tempProdMoment(momC) = mean(uVectors(:,rr).*uVectors(:,cc));
        momC = momC + 1;
    end
end

tempNProd = tempProdMoment;

% compute normalized centroid

tempNCentroid = mean(uVectors,1);

feature = [tempMag(:) ; tempNInertia(:) ; tempNProd(:) ; tempNCentroid(:)];

