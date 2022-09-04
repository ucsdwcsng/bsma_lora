function [nodes,load,tdiag_ap,tbsig_trig,nodes_sim,gateway_position] = run_simulation_vary_load_scale(num_nodes,num_packets,nodes_position, gateway_position, num_cells)

configurations;


for i = 1:num_nodes*num_cells
    nodes(i).id = i;
    nodes(i).x = nodes_position.x(i);
    nodes(i).y = nodes_position.y(i);
    nodes(i).cellId = nodes_position.cellId(i);
    % Packet Generation using poission distribution
    numCells = num_cells;
    % Arrival rate is not normalized across cells
    arrival_rate = (num_nodes*packet_duration*num_nodes_full_load)/num_packets;
    nodes(i).packet_queue = gen_packets(arrival_rate,num_packets); % Poisson Distribution
    nodes(i).num_packets = length(find(nodes(i).packet_queue<simTime));
    nodes(i).channel_state = 0;
    nodes(i).state = 'idle';
    nodes(i).neighbour_map = get_nmap(nodes_position,i,radius,ratio);
    nodes(i).backoff_cnt = 0;
    nodes(i).total_backoffs = 0;
    nodes(i).total_Backoff_dur = 0;
    nodes(i).dropped_packets = 0;
end

[gateway_position.nmap, gateway_position.distMap] = get_gw_nmap(gateway_position, nodes_position, radius);

n = 0;
for i = 1:num_nodes*num_cells
    n = n+length(find(nodes(i).packet_queue<simTime));
end
load = n;
tdiag_ap = cell(1,3);
nodes_sim = cell(1,3);
tbsig_trig = cell(1,3);

[nodes_sim{1},tdiag_ap{1}] = thru_csma(nodes);
[nodes_sim{2},tdiag_ap{2},tbsig_trig{2}] = thru_full(nodes,gateway_position);
[nodes_sim{3},tdiag_ap{3}] = thru_aloha(nodes);

end
