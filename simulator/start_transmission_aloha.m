function [temp,nodes,tdiag_ap] = start_transmission_aloha(id,nodes,ts,packet_duration,tdiag_ap)

temp = []; % [state, ts, id]
node = nodes(id);
temp(1,:) = [2, ts+packet_duration, node.id];
tdiag_ap = [tdiag_ap; tdiag_ap(size(tdiag_ap,1))+1,ts,id];
end