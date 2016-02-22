function feature = feature_geometry_function(imageFile)

% Usages:
%
%  feature = feature_geometry_function(imageFile)
%  compute geometry features of 192 dimensions from an imageFile.
%
% Example:
%  feature = feature_geometry_function('test_image_1.jpg'); 
%
% By Tian Tsong Ng, July 2005

feature = [];

temp = feature_intensity_with_surface_gradient_bessel(imageFile);
feature = [feature ; temp(:)];

temp = feature_gradient_with_beltrami_bessel(imageFile);
feature = [feature ; temp(:)];

temp = feature_gradient_with_secondForm_bessel(imageFile);
feature = [feature ; temp(:)];

temp = feature_joint_spatial_color_patch(imageFile);
feature = [feature ; temp(:)];

temp = feature_grayscale_patch(imageFile);
feature = [feature ; temp(:)];