function plot_reliability(dir,cap,actual_load,num_nodes)
max_num_nodes = num_nodes(length(num_nodes));
fig = figure('units','normal','Position', [0.1,0.1,0.8,0.8]);
plot(num_nodes,100*cap(:,1)./actual_load(1,:)','linewidth',2);
hold on;
plot(num_nodes,100*cap(:,2)./actual_load(1,:)','linewidth',2);
plot(num_nodes,100*cap(:,4)./actual_load(2,:)','linewidth',2);
plot(num_nodes,100*cap(:,5)./actual_load(2,:)','linewidth',2);
plot(num_nodes,100*cap(:,7)./actual_load(3,:)','linewidth',2);
xlabel('number of nodes');
ylabel('Reliability');
legend('CSMA no capture','CSMA capture','ALOHA no capture','ALOHA capture','Full Duplex','location','northwest');
hold off;
title('Reliability');
grid on;
grid minor;
set(gca,'fontsize', 18);
saveas(fig,strcat(dir,'/reliability.png'));
end