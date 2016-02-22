function surgrad = ss_surface_gradient_bessel(im,s)

% Usages:
%  surgrad = ss_surface_gradient_bessel(im,s) computes scale-space 
%  surface gradient of the image "im" at scale "s". The
%  output "surgrad" is a matrix.
%
%  The scale-space kernel used is the discrete scale-space kernel with the
%  form of the Bessel function
%
% Example:
%  im = imread('abc.jpg');
%  d = ss_surface_gradient_bessel(im,1); 
%
% By Tian Tsong Ng, July 2005

h = 0.1;

dname = {'x','y'};
d = ss_derivative_bessel(im,dname,s);

scale_E_grad2 = (d{1}.^2 + d{2}.^2)/h^2;

surgrad = sqrt(scale_E_grad2./(1+scale_E_grad2));


