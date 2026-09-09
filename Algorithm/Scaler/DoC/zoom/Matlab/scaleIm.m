% Function that scales up an image with a given method.
% It takes as inputs an image, scale factors x and y,
% and and a method specifier. x and y have to be positive
% integers. Returns the image enlarged by the factors in the
% appropriate dimensions using the specified filter.

function result = scaleIm(image, x, y, method)
  % if method = 1 --> box filter
  % if method = 2 --> bartlett filter

  if (method == 1)
    result = conv2(padding(image, x, y), box(x, y));
  end

  if (method == 2)
    result = conv2(padding(image, x, y), bartlett(x, y));
  end
