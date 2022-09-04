function [nmap, distMap] = get_gw_nmap(gateway_position, nodes_position, radius)
%GET_GW_NMAP returns the neighbor map for all gateways when the other
%nodes' positions, radius etc are specified.
% :input: gateway_position - struct
% :input: nodes_position - in km
% :output: nmap - [neighborindex, airtime(seconds)] (numneigbors x 2 vector)
%
numCells = length(gateway_position.x);
num_nodes = length(nodes_position.x);

nmap = zeros(numCells, num_nodes);
distMap = zeros(numCells, num_nodes);

for cellIdx = 1:numCells
    x1Cell = gateway_position.x(cellIdx);
    y1Cell = gateway_position.y(cellIdx);

    for i = 1:num_nodes
        x2 = nodes_position.x(i);
        y2 = nodes_position.y(i);

        r = sqrt((x1Cell-x2)^2+(y1Cell-y2)^2);
        %         airtime = r/(3*10^5);
        distMap(cellIdx,i) = r;
        if(r<radius)
            nmap(cellIdx, i) = 1;
        end
    end
end


end

