% Function that takes as inputs an image (matrix of pixel
% values), a scale factor in the x direction and a scale factor 
% in the y direction. Both scale factors have to be positive integers. 
% Returns a zero-padded matrix of the scaled dimensions..

function padded_im = padding(image, x, y)
  padded_im = zeros(size(image, 1)*y+1, size(image, 2)*x+1);
  for i=1:size(image, 1)
    for j=1:size(image, 2)
      padded_im(y*i, x*j) = image(i, j);
    end
  end

