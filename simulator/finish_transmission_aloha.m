function [temp,nodes,tdiag_ap] = finish_transmission_aloha(id,nodes,ts,tdiag_ap)

temp = []; % [state, ts, id]
node = nodes(id);
tdiag_ap = [tdiag_ap; tdiag_ap(size(tdiag_ap,1))-1,ts,id];
cnt = 0;
if(length(node.packet_queue)>1)
    cnt = 1;
    node.packet_queue = node.packet_queue(2:length(node.packet_queue));
    if(node.packet_queue(1) > ts)
        tsIter = node.packet_queue(1);
    else
        tsIter = ts;
    end
    temp(1,:) = [1, tsIter, node.id];
end

nodes(id) = node;
end