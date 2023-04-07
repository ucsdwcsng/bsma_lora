

%%
clearvars;
close all;

% Deployment parameters
num_cells = 1; % Number of cells
cell_radius_km = 1; % Cell radius for devices deployment
num_nodes_cell = 100; % Number of devices per cell
hearing_ratio = 0.33*2; % Hearing range for devices

% MAC Parameters (when applicable)
backoff_vec = 0.1;
pkt_duration = 0.1234;

% Latency Parameters
cad_latency_vec = 0.0035;
pkt_det_latency_vec = 0.0045;

% Offered load parameters
offered_load_vec = [25 50 100 200];


%%
rng_gen_idx = 1;
rng(rng_gen_idx)

tic
for backoff_ind=1:length(backoff_vec)
    for cad_ind = 1:length(cad_latency_vec)
        for pkt_det_ind = 1:length(pkt_det_latency_vec)

            % (num_cells, cell_radius_km, num_nodes_cell, offered_load_vec, inter_cell_dist_km, btone_radius_km)
            config_params = generate_configuration_defaults(num_cells,cell_radius_km,num_nodes_cell,offered_load_vec,1);
            config_params.packet_duration = pkt_duration;
            config_params.backoff_duration = backoff_vec(backoff_ind)*pkt_duration;
            config_params.CAD_late = cad_latency_vec(cad_ind);
            config_params.packet_det_late = pkt_det_latency_vec(pkt_det_ind);
            config_params.ratio = hearing_ratio;
            config_params.simTime = config_params.vec_nodes*config_params.packet_duration*config_params.num_nodes_full_load;
            config_params.rng_gen_idx = rng_gen_idx;
            generate_configuration_varying_load(config_params);

            configurations;
            total_load = zeros(1,length(packets_vec));    % To store the Load generated per simulation setting
            nodes = cell(1,length(packets_vec));          % To store the nodes parameters
            tdiag_ap = cell(1,length(packets_vec));       % To store the time diagram at AP
            nodes_sim = cell(1,length(packets_vec));      % To store the node parameters after simulations
            tbsig_trig = cell(1,length(packets_vec));
            gateways_sim = cell(1,length(packets_vec));
            [nodes_position, gateway_position] = deploy(vec_nodes, radius, inter_cell_dist_km, num_cells);

            for i = 1:length(packets_vec)
                [nodes{i},total_load(i),tdiag_ap{i},tbsig_trig{i},nodes_sim{i},gateways_sim{i}] = ...
                    run_simulation_vary_load_scale(vec_nodes,packets_vec(i),nodes_position,gateway_position,num_cells);
            end

            % Save the simulation results
            c = clock;
            str = strcat(num2str(c(1)),'-',num2str(c(2)),'-',num2str(c(3)),'-',num2str(c(4)),'-',num2str(c(5)));

            cd results;
            mkdir(str);
            cd(str);
            save('all_variables.mat');
            cd ..;
            cd ..;

            % process and plot all the results
            plots_vary_load;
        end
    end
end
toc

