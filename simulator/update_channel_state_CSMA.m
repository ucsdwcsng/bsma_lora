function nodes = update_channel_state_CSMA(id, nodes)
node = nodes(id);
for i = 1:size(node.neighbour_map,1)
    if(node.neighbour_map(i))
        nodes(i).channel_state = nodes(i).channel_state+1;
    end
end
end