function d = common_derivative(im,dname)

% Usages:
%  d = common_derivative(im,dname) computes discrete
%  derivatives of the image "im" as specified 
%  "dname" string in the form 'o','x',y','xy','yx','xx' and 'yy'. The
%  output "d" is a matrix.
%
% Example:
%  d = common_derivative(im,'x') return d = dx
%
% By Tian Tsong Ng, July 2005

% discrete 1d derivative filter of order n
d1 = [-0.5,0,0.5];
d2 = [1,-2,1];
% d3 = [-0.5,1,0,-1,0.5];
% d4 = [1,-4,6,-4,1];

switch dname
    case 'o'
        d = im;
    case 'x'
        d = imfilter(im,d1,'symmetric','same','corr');
    case 'y'
        d = imfilter(im,d1(:),'symmetric','same','corr');
    case 'xx'
        d = imfilter(im,d2,'symmetric','same','corr');
    case 'yy'
        d = imfilter(im,d2(:),'symmetric','same','corr');
    case 'xy'
        d = imfilter(im,d1'*d1,'symmetric','same','corr');
    case 'yx'
        d = imfilter(im,d1'*d1,'symmetric','same','corr');
    otherwise
        fprintf('d order not found\n');
end
