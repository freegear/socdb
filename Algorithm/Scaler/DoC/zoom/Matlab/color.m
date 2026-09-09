% loads the clown image
load clown.mat;
% display the clown image
imshow(X, map);
% break the image into its 3 color planes
[r, g, b] = ind2rgb(X, map);

% scale each color plane using the box filter
r2 = scaleIm(r, 2, 2, 1);
g2 = scaleIm(g, 2, 2, 1);
b2 = scaleIm(b, 2, 2, 1);

% scale each color plane using the Bartlett filter
r3 = scaleIm(r, 2, 2, 2);
g3 = scaleIm(g, 2, 2, 2);
b3 = scaleIm(b, 2, 2, 2);

figure;
imshow(r2, g2, b2);

figure;
imshow(r3, g3, b3);

