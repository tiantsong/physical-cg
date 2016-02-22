function feature = feature_intensity_with_surface_gradient_bessel(imageFile)

% Usages:
%  feature = feature_intensity_with_surface_gradient_bessel(imageFile) 
%  computes feature extracted from joint distribution of the intensity
%  image and the scale-space (scale = 1) surface gradient image, by the means of the
%  rigid body moment. The input "imageFile" is a filepath. The
%  output "feature" is a column vector.
%
% Example:
%  feature = feature_intensity_with_surface_gradient_bessel('test_image_1.jpg'); 
%
% By Tian Tsong Ng, July 2005


scaleSpace = 1;

offset = 10;

momDim = 6;
tempProdMoment = zeros(1,momDim*(momDim-1)/2);
tempInertiaMoment = zeros(1,momDim);


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

H = ss_surface_gradient_bessel(im,scaleSpace);
H = H(offset:(end-offset),offset:(end-offset),:);
im = im(offset:(end-offset),offset:(end-offset),:);
height = size(im,1);
width = size(im,2);

H = reshape(H,[height*width 3]);
im = reshape(im,[height*width 3]);

H = H/std(H(:));

vectors = [H(:,1) im(:,1) H(:,2) im(:,2) H(:,3) im(:,3)];
clear H im

vectors2 = vectors.^2;
mag = sqrt(sum(vectors2,2));

% compute mag features

tempMag = [mean(mag) var(mag) skewness(mag) kurtosis(mag)];

% compute normalized quantities

mag(mag==0) = 1;
uVectors = vectors./mag(:,[1 1 1 1 1 1]);

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