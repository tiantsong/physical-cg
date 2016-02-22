function d = ss_derivative_bessel(im,dname,s,accuracy_order)

% Usages:
%  d = ss_derivative_bessel(im,dname,s) computes multiple scale-space 
%  derivatives of the image "im" at scale "s" in one go specified 
%  as in "dname" cell, in the form 'o','x',y','xy','yx','xx' and 'yy'. The
%  output "d" is a cell.
%
%  d = ss_derivative_bessel(im,dname,s,single) computes a single
%  scale-space derivative where "dname" is a string and output "d" is a
%  matrix
%
% Example:
%  d = ss_derivative_bessel(im,{'x','y'},1) return d = {dx,dy}
%  d = ss_derivative_bessel(im,'x',1,true) return d = dx
%
% By Tian Tsong Ng, July 2005

if ~exist('accuracy_order','var')
    accuracy_order = 8;
end    

if s > 0
    x = -10:10; T = besseli(x,s,1);
    im = imfilter(im,T'*T,'symmetric','same','corr');
end

% discrete 1d derivative filter of order n
d1_2  = [-1/2 0 1/2];
d1_4  = [1/12 -2/3 0 2/3 -1/12];
d1_6  = [-1/60 3/20 -3/4 0 3/4 -3/20 1/60];
d1_8  = [1/280 -4/105 1/5 -4/5 0 4/5 -1/5 4/105 -1/280];

d2_2  = [1 -2 1];
d2_4  = [-1/12 4/3 -5/2 4/3 -1/12];
d2_6  = [1/90 -3/20 3/2 -49/18 3/2 -3/20 1/90];
d2_8  = [-1/560 8/315 -1/5 8/5 -205/72 8/5 -1/5 8/315 -1/560];

eval(sprintf('d1 = d1_%d;',accuracy_order));
eval(sprintf('d2 = d2_%d;',accuracy_order));

% d3 = [-0.5,1,0,-1,0.5];
% d4 = [1,-4,6,-4,1];

if ~iscell(dname)
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
else
    d = cell(1,length(dname));

    for dC = 1:length(dname)
        switch dname{dC}
            case 'o'
                d{dC} = im;
            case 'x'
                d{dC} = imfilter(im,d1,'symmetric','same','corr');
            case 'y'
                d{dC} = imfilter(im,d1(:),'symmetric','same','corr');
            case 'xx'
                d{dC} = imfilter(im,d2,'symmetric','same','corr');
            case 'yy'
                d{dC} = imfilter(im,d2(:),'symmetric','same','corr');
            case 'xy'
                d{dC} = imfilter(im,d1'*d1,'symmetric','same','corr');
            case 'yx'
                d{dC} = imfilter(im,d1'*d1,'symmetric','same','corr');
            otherwise
                fprintf('d order not found\n');
        end
    end
end
