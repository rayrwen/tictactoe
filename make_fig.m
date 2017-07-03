function [] = make_fig(play_mat, comp_mat, play_shape, comp_shape)
%   play_mat = [1,0,0;0,0,1;0,0,1];
%   comp_mat = [0,1,0;0,1,0;0,1,0];
%   play_shape = 'X'; comp_shape = 'O';
 
  figure(99)
  axis([0 1 0 1])
  hold on
  pos = [0.2, 0.5, 0.8];
  
  for i = [0.35, 0.65]
    x = linspace(0,1);
    y = ones(100).*i;
    plot(x,y,'-k', 'LineWidth', 0.6);
    plot(y,x,'-k', 'LineWidth', 0.6);
  end

  for i = 1:3
    for j = 1:3
      if play_mat(i,j) == 1
        text(pos(j),1-pos(i), play_shape, 'units', 'normalized', 'FontSize', 30, ...
          'Color', 'blue', 'HorizontalAlignment','center')
      end
      if comp_mat(i,j) == 1
        text(pos(j),1-pos(i), comp_shape, 'units', 'normalized', 'FontSize', 30, ...
          'Color', 'red', 'HorizontalAlignment','center')
      end
    end
  end
  
  axis off
