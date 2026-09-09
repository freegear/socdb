% Function that takes as inputs integers x and y.
% Returns a box filter mask which has y rows and x columns of 1s.

function result = box (x, y)
  result = ones(y, x);
