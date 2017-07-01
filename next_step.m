function [play_mat, comp_mat, status] = next_step(play_mat, comp_mat)
% Represent players' and computers' move by two 3x3 matrices

  num_empty = 0;
  [w, h] = size(play_mat);
  for i = 1:w
    for j = 1:h
      if play_mat(i,j) == 0 && comp_mat(i,j) == 0
        num_empty = num_empty + 1;
        ind_empty(num_empty,:) = [i,j];
      end
    end
  end

  next = ind_empty(int8(ceil(rand * num_empty)), :);
  comp_mat(next(1), next(2)) = 1;

  status = see_who_wins(play_mat, comp_mat);
end