function sz = ss_get_kernel_gaussian(s,dname)

% Usages:
%  sz = ss_get_kernel_gaussian(s,dname) computes scale-space 
%  gaussian derivative kernel at scale "s" as specified 
%  the "dname" string, in the form of 'o','x',y','xy','yx','xx' and 'yy'. 
%  The output "d" is a scale-space derivative kernel
%
% Example:
%  im = imread('abc.jpg');
%  d = ss_get_kernel_gaussian(1,'x');
%
% By Tian Tsong Ng, July 2005

[x,y] = meshgrid(-50:50);

switch dname 
    case 'o'        
        z = 1/(2*pi*s^2)*exp(-(x.^2+y.^2)/(2*s^2));        
    case 'x'        
        z = (-1/(2*pi*(s^4)))*x.*exp(-(x.^2+y.^2)/(2*s^2));        
    case 'y'        
        z = -1/(2*pi*s^4)*y.*exp(-(x.^2+y.^2)/(2*s^2));        
    case 'xx'        
        z = 1/(2*pi*s^6)*(x.^2-s.^2).*exp(-(x.^2+y.^2)/(2*s^2));        
    case 'yy'        
        z = 1/(2*pi*s^6)*(y.^2-s.^2).*exp(-(x.^2+y.^2)/(2*s^2));        
    case {'xy','yx'}
        z = 1/(2*pi*s^6)*(x.*y).*exp(-(x.^2+y.^2)/(2*s^2));        
end

zI = abs(z)>10^-12;
xI = any(zI,1);
yI = any(zI,2);

% ensure symmetry

xI = xI(:) | flipud(xI(:));
yI = yI(:) | flipud(yI(:));

% avoid hole in the center

x_index = find(xI);
y_index = find(yI);

min_x_index = min(x_index);
min_y_index = min(y_index);

max_x_index = max(x_index);
max_y_index = max(y_index);

xI(min_x_index:max_x_index) = true;
yI(min_y_index:max_y_index) = true;

% sample the center

sz = z(xI,yI);
