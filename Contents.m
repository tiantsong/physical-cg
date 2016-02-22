function Contents

% Geometry Feature Toolbox
% version 1.00, July 2005
% Tian-Tsong Ng, Shih-Fu Chang
% Columbia University
%
% 
% main function
% -------------
% 
% (0) feature_geometry_function - compute geometry feature.
%
% Example:
%  feature = feature_geometry_function('test_image_1.jpg'); 
%
%
% component function
% ------------------
%
% (1) feature_intensity_with_surface_gradient_bessel - compute surface
% gradient feature.
%
% Usages:
%  feature = feature_intensity_with_surface_gradient_bessel(imageFile) 
%  computes feature extracted from joint distribution of the intensity
%  image and the scale-space (scale = 1) surface gradient image, by the means of the
%  rigid body moment. The input "imageFile" is a filepath. The
%  output "feature" is a column vector.
%
% Example:
%  feature =
%  feature_intensity_with_surface_gradient_bessel('test_image_1.jpg'); 
%
% -------
%
% (2) feature_gradient_with_beltrami_bessel - compute beltrami flow feature.
%
% Usages:
%  feature = feature_intensity_with_surface_gradient_bessel(imageFile) 
%  computes feature extracted from joint distribution of the scale-space 
%  (scale = 1) Euclidean gradient image and the scale-space (scale = 1)
%  beltrami flow image, by the means of the
%  rigid body moment. The input "imageFile" is a filepath. The
%  output "feature" is a column vector.
%
% Example:
%  feature = feature_gradient_with_beltrami_bessel('test_image_1.jpg'); 
%
% -------
% 
% (3) feature_gradient_with_secondForm_bessel - compute second fundamental form
% feature.
%
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
% -------
%
% (4) feature_joint_spatial_color_patch - compute color-patch feature.
%
% Usages:
%  feature = feature_joint_spatial_color_patch(imageFile) 
%  computes feature extracted from joint distribution of the joint spatial
%  color local patches, by the means of the rigid body moment. The input 
%  "imageFile" is a filepath. The output "feature" is a column vector.
%
% Example:
%  feature = feature_joint_spatial_color_patch('test_image_1.jpg'); 
%
% -------
%
% (5) feature_grayscale_patch - compute grayscale-patch feature.
%
% Usages:
%  feature = feature_grayscale_patch(imageFile) 
%  computes feature extracted from joint distribution of the grayscale 
%  local patches, by the means of the rigid body moment. The input 
%  "imageFile" is a filepath. The output "feature" is a column vector.
%
% Example:
%  feature = feature_grayscale_patch('test_image_1.jpg'); 
%
% -------

