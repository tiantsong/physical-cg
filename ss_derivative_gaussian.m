function d = ss_derivative_gaussian(im,dname,s)

% Usages:
%  d = ss_derivative_gaussian(im,dI,s) computes scale-space 
%  derivatives of the image "im" at scale "s" as specified 
%  the "dname" string, in the form of 'o','x',y','xy','yx','xx' and 'yy'. 
%  The output "d" is a scale-space derivative image.
%
% Example:
%  im = imread('abc.jpg');
%  d = ss_derivative_gaussian(im,'x',1) return d = dx
%
% By Tian Tsong Ng, July 2005


dim3 = size(im,3);

kernel = ss_get_kernel_gaussian(s,dname);
d = zeros(size(im,1),size(im,2),dim3);

for channel = 1:dim3
    d(:,:,channel) = conv2(im(:,:,channel),kernel,'same');
end