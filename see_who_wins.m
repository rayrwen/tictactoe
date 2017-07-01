function status = see_who_wins(play_mat, comp_mat)
  % Status == 0 : continue
  %           1 : player wins
  %           2 : computer wins
  %           3 : draw
  % 
  % For now: assume we have n x n tic-tac-toe board,
  % i.e. w == h
  [w, h] = size(play_mat);
  
  status = 0;

%   Check if the game is finished
  if play_mat + comp_mat == ones(w)
      status = 3;
      return
  end

%   Check horizontal / vertical 1s
  for i = 1:w
    if isequal(comp_mat(i,:), ones(1,w)) || isequal(comp_mat(:,i), ones(w,1))
        status = 2;
        return 
    end
    if isequal(play_mat(i,:), ones(1,w)) || isequal(play_mat(:,i), ones(w,1))
        status = 1;
        return
    end
  end

%   Check diagonal 1s
  if isequal(diag(comp_mat), ones(w,1)) || isequal(comp_mat(w:w-1:end-1), ones(1,w))
      status = 2;
      return 
  end

  if isequal(diag(play_mat), ones(w,1)) || isequal(play_mat(w:w-1:end-1), ones(1,w))
      status = 1;
      return
  end

end