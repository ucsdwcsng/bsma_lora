function [temp,nodes,tdiag_ap] = start_transmission_full(id,nodes,ts,tdiag_ap,params)

[backoff_duration, CAD_late, CE_Thresh, max_backoff_cnt_csma, max_backoff_cnt_fd,...
    num_cells, num_nodes_full_load, packet_det_late,...
    packet_duration, packets_vec, radius, ratio, rng_gen_idx,...
    reserved, simTime, vec_nodes, xreach_matrix, xreach_th] = parseConfigurations(params);


temp = []; % [state, ts, id]
cnt = 0;
node = nodes(id);
if(node.channel_state==0)
    temp(1,:) = [2, ts+packet_duration+CAD_late, node.id];
    temp(2,:) = [3, ts+CAD_late+packet_det_late, node.id];
    cnt = cnt+1;
    tdiag_ap = [tdiag_ap; tdiag_ap(size(tdiag_ap,1))+1,ts+CAD_late,id];

else
    if node.backoff_cnt < max_backoff_cnt_fd
        node.backoff_cnt = node.backoff_cnt+1;
        backoff_time = backoff_duration*randi([1, 2^(min(4, node.backoff_cnt))],1);
        node.total_backoffs = node.total_backoffs+1;
        node.total_Backoff_dur = node.total_Backoff_dur+backoff_time;
        temp(1,:) = [1, ts+backoff_time+CAD_late, node.id];
        cnt = cnt+1;
    else
        if(length(node.packet_queue)>1)
            node.dropped_packets = node.dropped_packets+1;
            node.backoff_cnt = 0;
            node.packet_queue = node.packet_queue(2:length(node.packet_queue));
            if(node.packet_queue(1) > ts+CAD_late)
                tsIter = node.packet_queue(1);
            else
                tsIter = ts+backoff_duration+CAD_late;
            end
            temp(1,:) = [1, tsIter, node.id];
            cnt = cnt+1;
        end
    end
end
nodes(id) = node;
end
