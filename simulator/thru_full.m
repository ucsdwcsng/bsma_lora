function [nodes, tdiag_ap, tbsig_trig] = thru_full(nodes,gateway_position)
configurations;
num_nodes = numel(nodes);
tdiag_ap = [0, 0, 0];
tbsig_trig = [0, 0];
array =struct('state', cell(1,num_nodes), 'ts', cell(1,num_nodes), 'id', cell(1,num_nodes));

for i = 1:num_nodes
    array(i).state = 1;
    array(i).ts = nodes(i).packet_queue(1);
    array(i).id = i;
end

T = reshape(struct2array(array),3,[]).';
% [state, ts, id]
T = sortrows(T, 2);

while(size(T,1)>0)

    state = T(1,1);
    id = T(1,3);
    ts = T(1,2);

    if(ts>simTime)
        break;
    end
    if state == 1
        [temp,nodes,tdiag_ap] = start_transmission_full(id,nodes,ts,tdiag_ap,params);
        if(size(temp,1)>0)
            T = [temp;T(2:end,:)];
            T = sortrows(T, 2);
        else
            T = T(2:end,:);
        end
    elseif state == 2
        [temp,nodes,tdiag_ap] = finish_transmission_full(id,nodes,gateway_position,ts,backoff_duration,tdiag_ap);
        if(size(temp,1)>0)
            T = [temp;T(2:end,:)];
            T = sortrows(T, 2);
        else
            T = T(2:end,:);
        end
    elseif state == 3
        nodes = update_channel_state_Full(id,nodes,gateway_position);
        tbsig_trig = [tbsig_trig; ts, id];
        T = T(2:end,:);
    end
end

end