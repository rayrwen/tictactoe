function [] = make_fig(play_mat, comp_mat)
  close all

  % play_mat = [1,0,0;0,0,1;0,0,1];
  % comp_mat = [0,1,0;0,1,0;0,0,0];

  figure
  axis off
  hold all
  pos = [0.2, 0.5, 0.8];

  for i = 1:3
    for j = 1:3
      if play_mat(i,j) == 1
        text(pos(j),1-pos(i), 'PLAY', 'units', 'normalized', 'FontSize', 30, ...
          'Color', 'blue', 'HorizontalAlignment','center')
      end
      if comp_mat(i,j) == 1
        text(pos(j),1-pos(i), 'COMP', 'units', 'normalized', 'FontSize', 30, ...
          'Color', 'red', 'HorizontalAlignment','center')
      end
    end
  end
