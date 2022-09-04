% clear all;
function[] = generate_configuration_varying_load(params)

if(nargin == 0)
    num_cells = 1;
    vec_nodes = 10;       % Node vector for which you want the simulation to run
    num_nodes_full_load = 200;     % Number of packets when operating at 100% load condition
    packets_vec = 40:40:400;           % Number of packets per node
    
    simTime = 80;                % Total Simulation time in Seconds
    packet_duration = 0.2;     % Packet Duration in seconds
    
    packet_det_late = 0.012;    % Packet detection latency in Seconds
    CAD_late  = 0.008;          % Channel Sensing Latency in Seconds
    
    backoff_duration = 0.1*packet_duration; % Fundamental Backoff Duartion in Seconds
    max_backoff_cnt_csma = 8;   % Maximum number of backoffs for CSMA
    max_backoff_cnt_fd = 8;   % maximum number of backoffs for FD
    
    ratio = 0.3;                % Ratio of the listening range of AP and Nodes
    radius = 1;                % AP coverage radius in kms
    
    CE_Thresh = 3;      % Capture Effect Threshold
    reserved = 3;     % reserved
else
    num_cells = params.num_cells; % Number of cells in the simulation
    
    inter_cell_dist_km = params.inter_cell_dist_km;
    
    vec_nodes = params.vec_nodes;       % Node vector for which you want the simulation to run
    num_nodes_full_load = params.num_nodes_full_load;     % Number of packets when operating at 100% load condition
    packets_vec = params.packets_vec;           % Number of packets per node
    
    simTime = params.simTime;                % Total Simulation time in Seconds
    packet_duration = params.packet_duration;     % Packet Duration in seconds
    
    packet_det_late = params.packet_det_late;    % Packet detection latency in Seconds
    CAD_late  = params.CAD_late;          % Channel Sensing Latency in Seconds
    
    backoff_duration = params.backoff_duration; % Fundamental Backoff Duartion in Seconds
    max_backoff_cnt_csma = params.max_backoff_cnt_csma;   % Maximum number of backoffs for CSMA
    max_backoff_cnt_fd = params.max_backoff_cnt_fd;   % maximum number of backoffs for FD
    
    ratio = params.ratio;                % Ratio of the listening range of AP and Nodes
    radius = params.radius;                % AP coverage radius in kms
    
    CE_Thresh = params.CE_Thresh;       % Capture Effect Threshold
    reserved = params.reserved;     % reserved
    rng_gen_idx = params.rng_gen_idx;
    
end
save("configurations_vls.mat")
end