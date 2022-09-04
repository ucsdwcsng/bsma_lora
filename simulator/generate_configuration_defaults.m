function[config_params] = generate_configuration_defaults(num_cells, cell_radius_km, num_nodes_cell, offered_load_vec, inter_cell_dist_km, btone_radius_km)
arguments
    num_cells double = 1;
    cell_radius_km double = 2;
    num_nodes_cell double = 1000; % Number of nodes per cell
    offered_load_vec double = 40:40:400;
    inter_cell_dist_km double = [];
    btone_radius_km double = 2;
end

if(isempty(inter_cell_dist_km))
    inter_cell_dist_km = 2*cell_radius_km;
end

config_params.num_cells = num_cells; % Number of cells in the simulation

% Node vector for which you want the simulation to run (per cell)
config_params.vec_nodes = num_nodes_cell;
% Number of packets when operating at 100% load condition
config_params.num_nodes_full_load = 200;
% Number of packets per node (loops over each one)
config_params.packets_vec = offered_load_vec;

config_params.simTime = 80;                % Total Simulation time in Seconds
config_params.packet_duration = 0.2;     % Packet Duration in seconds

config_params.packet_det_late = 0.012;    % Packet detection latency in Seconds
config_params.CAD_late  = 0.008;          % Channel Sensing Latency in Seconds

config_params.backoff_duration = 0.1*config_params.packet_duration; % Fundamental Backoff Duartion in Seconds
config_params.max_backoff_cnt_csma = 8;   % Maximum number of backoffs for CSMA
config_params.max_backoff_cnt_fd = 8;   % maximum number of backoffs for FD

config_params.ratio = 0.3;                % Ratio of the listening range of AP and Nodes
% Radius of each AP's Cell
config_params.radius = cell_radius_km;                 % AP coverage radius in kms

config_params.inter_cell_dist_km = inter_cell_dist_km;

config_params.CE_Thresh = -1;     % Capture Effect Threshold (3 previously)
config_params.reserved = 3;     % reserved


end