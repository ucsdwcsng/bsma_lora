function [backoff_duration, CAD_late, CE_Thresh, max_backoff_cnt_csma, max_backoff_cnt_fd,...
    num_cells, num_nodes_full_load, packet_det_late,...
    packet_duration, packets_vec, radius, ratio, rng_gen_idx,...
    reserved, simTime, vec_nodes, xreach_matrix, xreach_th] = parseConfigurations(params)
%PARSECONFIGURATIONS Function to unpack the params structure
%   Detailed explanation goes here

num_cells = params.num_cells; % Number of cells in the simulation

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

CE_Thresh = params.CE_Thresh;      % Capture Effect Threshold
reserved = params.reserved;     % reserved
rng_gen_idx = params.rng_gen_idx;

xreach_matrix = [];
xreach_th = 0;
end