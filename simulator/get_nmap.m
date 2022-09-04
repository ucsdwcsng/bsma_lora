function nmap = get_nmap(nodes_position, node_id, radius, ratio)
%get_nmap returns the neighbor map for a given node id when the other
%nodes' positions, radius etc are specified.
% :input: nodes_position - in km
% :input: node_id - Id of node whose map we are requesting
% :input: radius - Radius of single base-station deployment in km
% :input: ratio - Hearing range as a function of radius
% :output: nmap - 1 hot vector for neighbors
%


num_nodes = length(nodes_position.x);
nmap = zeros(num_nodes,1);
x1 = nodes_position.x(node_id);
y1 = nodes_position.y(node_id);

for i = 1: num_nodes
    if(i==node_id)
        continue;
    else
        x2 = nodes_position.x(i);
        y2 = nodes_position.x(i);
        r = sqrt((x1-x2)^2+(y1-y2)^2);
        airtime = r/(3*10^5);
        if(r<radius*ratio)
            %                 nmap = [nmap; i, airtime];
            nmap(i) = 1;
        end
    end
end


end

