%% Szukanie lini na obrazie
close all; clear; clc;

a = imread('blobs.png');
[H,T,R] = hough(a);

piki = houghpeaks(H,10);

L = houghlines(a, T, R, piki,"FillGap",3);

subplot(121), imshow(a);
subplot(122), imshow(a); hold on

max_L=0;
n=0;

for k=1:10
    line([L(k).point1(1), L(k).point2(1)], ...
        [L(k).point1(2), L(k).point2(2)], 'color', 'red');
    
    len = sqrt((L(k).point1(1) - L(k).point2(1))^2 + (L(k).point1(2) - L(k).point2(2))^2);

    if len > max_L
        max_L = len;
        n = k;
    end
end

n

line([L(n).point1(1), L(n).point2(1)], [L(n).point1(2), L(n).point2(2)], 'color', 'green');


%% zaszumiony obraz z liniami
a = imread('Data/ebsd_12.png');
a = double(a)/255;
[Nz, Nx] = size(a);

XT = fftshift(fft2(a));
WA = abs(XT);
%BS = 1./()

fx = linspace(-0.5, 0.5, Nx);

[FX, FZ] = meshgrid(fx,fx);

f = sqrt(FX.^2 + FZ.^2);

BS = 1./(1 + (f.*0.02)./(f.^2 - 0.069^2)^4);

an = real(ifft2(ifftshift(BS.*XT)));

subplot(121), imshow(an);
%subplot(122), imagesc(fx, fx, log(WA + 0.0001)); axis equal;

an = imadjust(an);

subplot(121), imshow(an);

bin = an > 0.9 | an< 0.5;
bin = bwareaopen(bin, 50);
bin = imclearborder(bin);

bin = imclose(bin, ones(3));

bin = imopen(bin ,ones(2));
bin = imclose(bin, ones(3));

bin = bwmorph(bin, 'thin', inf);
bin = bwmorph(bin, 'spur', 4);

subplot(122), imshow(bin);

[H,T,R] = hough(bin);

piki = houghpeaks(H,10, 'Threshold', 0.25*max(H(:)));

lin = houghlines(bin, T, R, piki);

Nlin = size(piki,1);

imshow(a);
for k=1:Nlin
    line([lin(k).point1(1), lin(k).point2(1)], ...
        [lin(k).point1(2), lin(k).point2(2)], 'color', 'red');

end

