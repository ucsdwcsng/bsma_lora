function [temp,nodes,tdiag_ap] = finish_transmission_full(id,nodes,gateway_position,ts,backoff_duration,tdiag_ap)


temp = []; % [state, ts, id]
cnt = 0;
node = nodes(id);
tdiag_ap = [tdiag_ap; tdiag_ap(size(tdiag_ap,1))-1,ts,id];

nodes = update_channel_state_Full(id,nodes,gateway_position,-1);

if(length(node.packet_queue)>1)
    node.backoff_cnt = 0;
    node.packet_queue = node.packet_queue(2:length(node.packet_queue));
    if(node.packet_queue(1) > ts)
        timeIter = node.packet_queue(1);
    else
        timeIter = ts+backoff_duration;
    end
    temp(1,:) = [1, timeIter,node.id];
    cnt = cnt+1;
end
node.channel_state = nodes(id).channel_state;
nodes(id) = node;
end
