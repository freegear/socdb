% Function that scales down an image with a given method.
% It takes as inputs an image, scale factors x and y,
% and and a method specifier. x and y have to be positive
% integers. Returns the image shrunk by the factors in the
% appropriate dimensions using the specified filter.

function result = scaleDown(image, x, y, method)
  % if method = 1 --> box filter
  % if method = 2 --> bartlett filter

  if (method == 1)
    newim = conv2(image, 1/(x*y)*box(x, y));
    u = 1;
    i = 1;
    while i <= size(newim, 1),
      j = 1;
      v = 1;
      while j <= size(newim, 2),
        result(u, v) = newim(i, j);
        v = v + 1;
	j = j + x;
      end
      u = u + 1;
      i = i + y;
    end
  end

  if (method == 2)
    newim = conv2(image, 1/(x*y)*bartlett(x, y));
    u = 1;
    i = 1;
    while i <= size(newim, 1),
      j = 1;
      v = 1;
      while j <= size(newim, 2),
        result(u, v) = newim(i, j);
        v = v + 1;
	j = j + x;
      end
      u = u + 1;
      i = i + y;
    end
  end
