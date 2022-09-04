function [nodes] = update_channel_state_Full(id,nodes,gateway_position,direction)
%update_channel_state_Full updates the channel state of all nodes in the
%same cell. It also updates the channel states of neighbors in other cells
%
arguments
    id
    nodes
    gateway_position
    direction double = 1;
end

node = nodes(id);
cellTriggerOneHot = find(gateway_position.nmap(:,id));
radiusTrigger = gateway_position.distMap(:, id);

for i = 1:numel(nodes)
    nodeTruth = node.neighbour_map(i);
    myRadius = gateway_position.distMap(:, i);
    radiusTruth = myRadius < 1 ;%radiusTrigger * 1.1;
    cellTruth = any(gateway_position.nmap(cellTriggerOneHot,i) & radiusTruth(cellTriggerOneHot));

    if(cellTruth || nodeTruth)
        nodes(i).channel_state = nodes(i).channel_state + direction;
    end
end

end