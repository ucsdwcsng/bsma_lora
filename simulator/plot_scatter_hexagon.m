function plot_scatter_hexagon(dir,nodes,capacity,load_ratio,index, packet_dist,radius,gateway_position)
%PLOT_SCATTER_HEXAGON Summary of this function goes here
%   Detailed explanation goes here
for iter = 1:size(load_ratio,2)
    x = zeros(1,numel(nodes{index(iter)}));
    y = zeros(1,numel(nodes{index(iter)}));
    for i = 1:numel(nodes{index(iter)})
        x(i) = nodes{index(iter)}(i).x;
        y(i) = nodes{index(iter)}(i).y;
    end
    
    numCells = numel(gateway_position.x);
    cellBoundaryCircle = radius*exp(1j*[0:0.01:(2*pi)]);
    cellBoundaryCircleMat = zeros(numCells,numel(cellBoundaryCircle));
    for idx = 1:numCells
        cellBoundaryCircleMat(idx,:) = cellBoundaryCircle + gateway_position.x(idx) + 1j*gateway_position.y(idx);
    end
    
    circleCentroid = mean(gateway_position.x) + 1j*mean(gateway_position.y);
    

    dotsize = 30; 
    
    figure(9); clf;
    z = capacity{index(iter)}(7,:)./packet_dist{index(iter)};
    scatter(x(:), y(:), dotsize, z(:), 'filled');  
    hold on
    for idx = 1:numCells
        plot(real(cellBoundaryCircleMat(idx,:)), imag(cellBoundaryCircleMat(idx,:)), 'r-')
    end
    plot(gateway_position.x,gateway_position.y,'kx','MarkerSize',12);
    
    hold off
    caxis([0 1])
    axis equal
    xlim(2*[-radius,radius]+ real(circleCentroid));
    ylim((1+2/sqrt(3))*[-radius,radius] + imag(circleCentroid));
    zlim([0, 1]);
    xlabel('Pos - x (km)');
    ylabel('Pos - y (km)');
    set(gca,'fontsize', 42);
    plot_magic('aspect_ratio',[1 1],'pixelDensity',600,'fontSize',36, 'lineWidth',5,'gridFlag','off','minorGridFlag','off');

    filename = [dir,'/scatter_plot_cells.pdf'];
    filename_fig = [dir,'/scatter_plot_cells.fig'];
    print_fig(gcf,filename,'-dpdf')
    savefig(gcf,filename_fig);

end