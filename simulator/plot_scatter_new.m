function plot_scatter_new(dir,nodes,capacity,load_ratio,index, packet_dist,radius)
for iter = 1:size(load_ratio,2)
    x = zeros(1,numel(nodes{index(iter)}));
    y = zeros(1,numel(nodes{index(iter)}));
    for i = 1:numel(nodes{index(iter)})
        x(i) = nodes{index(iter)}(i).x;
        y(i) = nodes{index(iter)}(i).y;
    end

    dotsize = 10; 
    fig(iter) = figure('Position', [100,100,1200,400]);
    subplot(1,3,1);
    z = capacity{index(iter)}(5,:)./packet_dist{index(iter)};
    scatter(x(:), y(:), dotsize, z(:), 'filled');    
    caxis([0 1])
    axis equal
    xlim(3*[-radius,radius]);
    ylim(3*[-radius,radius]);
    zlim([0, 1]);
    xlabel('Distance to AP(km)');
    ylabel('Distance to AP(km)');
    title('ALOHA');
    set(gca,'fontsize', 23);

    subplot(1,3,2);
    z = capacity{index(iter)}(2,:)./packet_dist{index(iter)};
    scatter(x(:), y(:), dotsize, z(:), 'filled');   
    caxis([0 1])
    axis equal
    xlim(3*[-radius,radius]);
    ylim(3*[-radius,radius]);
    zlim([0, 1]);
    xlabel('Distance to AP(km)');
    ylabel('Distance to AP(km)');
    title('CSMA');
    set(gca,'fontsize', 23);

    subplot(1,3,3);
    z = capacity{index(iter)}(7,:)./packet_dist{index(iter)};
    scatter(x(:), y(:), dotsize, z(:), 'filled');   
    caxis([0 1])
    axis equal
    xlim(3*[-radius,radius]);
    ylim(3*[-radius,radius]);
    zlim([0, 1]);
    xlabel('Distance to AP(km)');
    ylabel('Distance to AP(km)');
    title('BSMA');
    set(gca,'fontsize', 23);


    hp4 = get(subplot(1,3,3),'Position');
    colorbar('Position', [hp4(1)+hp4(3)+0.03  hp4(2)+0.1  0.022  hp4(4)-0.2]);
    ratio = sprintf('%2.1f',100*load_ratio(iter));
    saveas(fig(iter),strcat(dir,'/Scatter_v2',num2str(numel(nodes{index(iter)})),'_3.png'));
    filename = [dir,'/scatter_plot_100_load_v2.pdf'];
    filename_fig = [dir,'/scatter_plot_100_load_v2.fig'];
    print_fig(fig(iter),filename,'-dpdf')
    savefig(gcf,filename_fig);
end