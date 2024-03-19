%% literki e
close all; clear; clc;
a = imread('Data/tekst2.png');

a = a(:,:,2) < 230;

%a = imopen(a, ones(3));

subplot(121), imshow(a);

e = a(155:176,69:88);

subplot(122), imshow(e);

xc = real(ifft2( fft2(a) .* fft2(rot90(e,2), 295, 573)));

prog = 0.999*max(xc(:));
wynik = xc > prog;
wynik = imdilate(wynik, strel('arbitrary', [1 1 1 1 1 1 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 ; 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0]));

wynik = imreconstruct(wynik, a);
wynik = imoverlay(a, wynik, 'r');

subplot(122), imshow(wynik);

%% literki r
close all; clear; clc;
a = imread('text.png');
[Nz, Nx] = size(a)

subplot(121), imshow(a);

r = a(11:23,63:71);

subplot(122), imshow(r);

xc1a = real( ifft2( fft2(a) .* fft2( rot90(r,2), 256, 256)));
xc1b = real( ifft2( fft2(1-a) .* fft2( rot90(1-r,2), 256, 256)));
xc1 = xc1a + xc1b;

xc2a = real(ifft2( fft2(a) .* fft2(rot90(r,3), 256, 256)));
xc2b = real(ifft2( fft2(1-a) .* fft2(rot90(1-r,3), 256, 256)));
xc2 = xc2a + xc2b;

prog1 = 0.999*max(xc1(:));
prog2 = 0.999*max(xc2(:));
wynik1 = xc1 > prog1;
wynik2 = xc2 > prog2;

wynik = wynik1 | wynik2;

wynik = imdilate(wynik, strel('arbitrary', [1 1 1 1 1 0 0 0 0 0 0 ; 0 0 0 0 0 0 0 0 0 0 0 ; 0 0 0 0 0 0 0 0 0 0 0 ; 0 0 0 0 0 0 0 0 0 0 0]));
wynik = imclearborder(wynik);

wynik = imreconstruct(wynik, a);
wynik = imoverlay(a, wynik, 'r');

subplot(122), imshow(wynik);
