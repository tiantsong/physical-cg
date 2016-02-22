function [grad,eValue1,eValue2] = ss_secondForm_bessel(im,s)

% Usages:
%  [grad,eValue1,eValue2] = ss_secondForm_bessel(im,s) computes scale-space 
%  second fundamental form of the image "im" at scale "s". The
%  output "grad" is Euclidean gradient image, "eValue1" is the first eigenvalue
%  image, and "eValue2" is the second eigenvalue image.
%
%  The scale-space kernel used is the discrete scale-space kernel in the
%  form of the Bessel function
%
% Example:
%  im = imread('abc.jpg');
%  [grad,eValue1,eValue2] = ss_secondForm_bessel(im,1); 
%
% By Tian Tsong Ng, July 2005


v = {'x','y','xx','yy','xy'};
I = ss_derivative_bessel(im,v,s);

hx2 = I{1}.^2;
hy2 = I{2}.^2;
grad2 = hx2 + hy2;
grad = sqrt(grad2);

% K = (hxx.*hyy - hxy.^2)./((1+ hx.^2 + hy.^2).^2);
% H = 0.5*((1+hx.^2).*hyy - 2*hx.*hy.*hxy + (1+hy.^2).*hxx)./((1+hx.^2+hy.^2).^(3/2));

K = (I{3}.*I{4} - I{5}.^2)./((1 + grad2).^2);
H = 0.5*((1+hx2).*I{4} - 2*I{1}.*I{2}.*I{5} + (1+hy2).*I{3})./((1 + grad2).^(3/2));

A = sqrt(abs(H.^2 - K));

eValue1 = H + A;
eValue2 = H - A;
