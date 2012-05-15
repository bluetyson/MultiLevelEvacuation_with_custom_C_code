function plotFloor(data, floor_idx)
%PLOTFLOOR plot floor

h=subplot(data.floor(floor_idx).building_plot);

set(h, 'position',[(data.floor_count - floor_idx)/data.figure_floors_subplots_w, ...
    0.4, 1/(data.figure_floors_subplots_w+0.1), 0.6 ]);

hold off;
% the building image
imagesc(data.floor(floor_idx).img_plot);
hold on;

%plot options
colormap(data.color_map);
axis equal;
axis manual; %do not change axis on window resize

set(h, 'Visible', 'off')
%title(sprintf('floor %i', floor_idx));

% plot agents
ang = 0:0.1:2*pi;
cosang = cos(ang);
sinang = sin(ang);
for i=1:length(data.floor(floor_idx).agents)
    p = data.floor(floor_idx).agents(i).p;
    r = data.floor(floor_idx).agents(i).r * data.pixel_per_meter;
    %r = norm(agent.v);
    xp = r * cosang;
    yp = r * sinang;
    plot(p(2) + xp, p(1) + yp, 'r');
    %text(agent.pos(2),agent.pos(1),int2str(i));
end

hold off;
end
