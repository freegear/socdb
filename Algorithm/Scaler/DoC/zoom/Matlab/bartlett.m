% Function that takes as inputs integers x and y.
% Returns a bartlett filter mask which has 2y-1 rows and 2x-1 columns.

function result = bartlett(x, y)
  row_vect = zeros(1, x*2-1);
  col_vect = zeros(y*2-1, 1);

  x_len = length(row_vect);
  for i=1:x_len
    if (i <= x)
      row_vect(i) = i;
    else
      row_vect(i) = x_len-i+1;
    end
  end

  y_len = length(col_vect);
  for i=1:y_len
    if (i <= y)
      col_vect(i) = i;
    else
      col_vect(i) = y_len-i+1;
    end
  end

  result = 1/(x*y) .* (col_vect * row_vect);



