function [grad,Beltrami] = ss_beltrami_bessel(im,s)

% Usages:
%  [grad,Beltrami] = ss_beltrami_bessel(im,s) computes scale-space 
%  Beltrami flow vector of the image "im" at scale "s". The
%  output "grad" is Euclidean gradient image, "Beltrami" is beltrami flow
%  vector (3 components) image.
%
%  The scale-space kernel used is the discrete scale-space kernel in the
%  form of the Bessel function
%
% Example:
%  im = imread('abc.jpg');
%  [grad,Beltrami] = ss_beltrami_bessel(im,1); 
%
% By Tian Tsong Ng, July 2005

v = {'x','y'};
I = ss_derivative_bessel(im,v,s);

grad = sqrt(I{1}.^2 + I{2}.^2);

G = cell(2,2);

G{1,1} = 1 + sum(I{1}.^2,3);
G{1,2} = sum(I{1}.*I{2},3);
G{2,1} = G{1,2};
G{2,2} = 1 + sum(I{2}.^2,3);

groot = sqrt(G{1,1}.*G{2,2} - G{1,2}.^2);

Beltrami = zeros(size(im,1),size(im,2),3);

for n = 1:3
    B = 0;
    for diff = 1:2
        temp = 0;
        for m = 1:2
            temp = temp + G{diff,m}.*I{m}(:,:,n);
        end
        B = B + common_derivative(groot.*temp,v{diff});
    end
    Beltrami(:,:,n) = B./groot;
end

