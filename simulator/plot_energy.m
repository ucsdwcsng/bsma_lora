function plot_energy(dir, nodes_sim, actual_load, vec_nodes,pkt_time,capacity)

backoff_count_csma = zeros(1, length(vec_nodes));
backoff_count_full = zeros(1, length(vec_nodes));
backoff_count_aloha = zeros(1, length(vec_nodes));

for i = 1:length(vec_nodes)
    for j = 1:numel(nodes_sim{i}{1})
        backoff_count_csma(i) = backoff_count_csma(i)+nodes_sim{i}{1}(j).total_backoffs;
    end

    for j = 1:numel(nodes_sim{i}{2})
        backoff_count_full(i) = backoff_count_full(i)+nodes_sim{i}{2}(j).total_backoffs;
    end

    for j = 1:numel(nodes_sim{i}{3})
        backoff_count_aloha(i) = backoff_count_aloha(i)+nodes_sim{i}{3}(j).total_backoffs;
    end
end


backoff_count_csma = backoff_count_csma;
backoff_count_full = backoff_count_full;
backoff_count_aloha = backoff_count_aloha;

csma_load = actual_load(1,:);
fd_load = actual_load(2,:);
aloha_load = actual_load(3,:);

energy_per_cad = 0.03*0.003;
tx_power = 0.33;
energy_per_pkt = pkt_time*tx_power;
total_energy_csma = backoff_count_csma*energy_per_cad + csma_load*energy_per_pkt;
total_energy_fd = backoff_count_full*energy_per_cad + fd_load*energy_per_pkt;
total_energy_aloha = backoff_count_aloha*energy_per_cad + aloha_load*energy_per_pkt;


fig = figure();
fig.Position = [40 40 800 600];
plot(100*vec_nodes/vec_nodes(length(vec_nodes)/2),1000*total_energy_aloha./capacity(:,7)','linewidth',5);
hold on;
plot(100*vec_nodes/vec_nodes(length(vec_nodes)/2),1000*total_energy_csma./capacity(:,2)','linewidth',5,'LineStyle','--');
plot(100*vec_nodes/vec_nodes(length(vec_nodes)/2),1000*total_energy_fd./capacity(:,5)','linewidth',5,'LineStyle',':');
xlabel('Offered Load(%)');
ylabel('Average Energy(mJ)');
legend('BSMA','CSMA','ALOHA','location','northwest');
hold off;
grid on;
xlim([20 200])
ylim([0 200])
grid minor;
set(gca,'fontsize', 30);
saveas(fig,strcat(dir,'/avg_energy_per_pkt.png'));
filename = [dir,'/avg_energy_per_pkt_v3.pdf'];
filename_fig = [dir,'/avg_energy_per_pkt_v3.fig'];
print_fig(fig,filename,'-dpdf')
savefig(gcf,filename_fig)
end