
dir = strcat(pwd,'/results/',str);

max_num_packets = simTime/packet_duration;

capacity = cell(1,length(packets_vec));
packet_dist = cell(1,length(packets_vec));
cap = zeros(length(packets_vec),8);
fairness = zeros(length(packets_vec),8);
for i = 1:length(packets_vec)
    if(exist('tbsig_trig','var'))
        capacity{i} = cal_capacity(nodes{i},tdiag_ap{i},tbsig_trig{i},packet_duration,gateways_sim{i},CE_Thresh);
    else
        capacity{i} = cal_capacity(nodes{i},tdiag_ap{i},[],packet_duration,gateways_sim{i},CE_Thresh);
    end
    packet_dist{i} = zeros(1,vec_nodes*num_cells);
    for j = 1:vec_nodes*num_cells
        packet_dist{i}(j) = nodes{i}(j).num_packets;
    end
    for j = 1:size(fairness,2)
        weighted_cap = capacity{i}(j,:)./packet_dist{i};
        %         weighted_cap = capacity{i}(j,:);
        cap(i,j) = sum(capacity{i}(j,:));
        fairness(i,j) = ((sum(weighted_cap)^2)/(sum(weighted_cap.*weighted_cap)))/(vec_nodes*num_cells);
    end
end



%% new throughput plot
fig1 = figure();
fig1.Position = [40 40 1000 750];
fig1.Position = [40 40 600*2 400*2];
max_num_packets = simTime/packet_duration;
plot((packets_vec*100)/num_nodes_full_load,100*cap(:,7)/max_num_packets,'linewidth',7);
hold on;
plot((packets_vec*100)/num_nodes_full_load,100*cap(:,2)/max_num_packets,'-.','linewidth',7);
plot((packets_vec*100)/num_nodes_full_load,100*cap(:,5)/max_num_packets,':','linewidth',7);

xlabel('Offered Load per Cell(%)');
ylabel('Throughput(%)');
legend('BSMA','CSMA','ALOHA','location','best');
grid on;
grid minor;
set(gca,'fontsize', 42);
saveas(fig1,strcat(dir,'/1000_nodes_norm_xput.png'));
filename = [dir,'/throughput_with_load.pdf'];
filename_fig = [dir,'/throughput_with_load.fig'];
print_fig(fig1,filename,'-dpdf')
savefig(gcf,filename_fig)

fprintf("Absolute Throughput: %.2f %",100*cap(:,7)/max_num_packets);
fprintf("Gain over CSMA %.2f, ALOHA %.2f\n",(100*cap(:,7)/max_num_packets)./(100*cap(:,2)/max_num_packets),...
    (100*cap(:,7)/max_num_packets)./(100*cap(:,5)/max_num_packets));


%%
load_ratio = [1.00];
index = [1]; % Need to input manually

actual_load = zeros(3, length(packets_vec));
for i = 1:3
    for j = 1:length(packets_vec)
        for k = 1:numel(nodes_sim{j}{i})
            actual_load(i,j) = actual_load(i,j)+nodes_sim{j}{i}(k).num_packets-nodes_sim{j}{i}(k).dropped_packets;
        end
    end
end

plot_scatter_new(dir,nodes,capacity,load_ratio,index, packet_dist,radius);
plot_scatter_hexagon(dir,nodes,capacity,load_ratio,index, packet_dist,radius,gateway_position);

pkt_time = params.packet_duration;
plot_energy(dir, nodes_sim, actual_load, packets_vec,pkt_time,cap);
