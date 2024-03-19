%% zaburzenie na obrazie
a = imread('peppers.png');
[Nz, Nx, kol] = size(a);
a = rgb2gray(a);
a = double(a)/255;

subplot(121), imshow(a);

for i =1:Nz
    for j =1:Nx
        w = (Nz/2 - i);
        k = (Nx/2 - j);
    
        r = sqrt(k.^2 + w.^2);

        a(i,j) = a(i,j) + 0.18*sin(0.4 * pi*r);
    end

end


subplot(122), imshow(a);

