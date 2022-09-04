function [nodes_position,gateway_position] = deploy(num_nodes, radius, inter_cell_distance, num_cells)
%DEPLOY Multi-cell network deployment with N nodes in r km of radius
arguments
    num_nodes
    radius
    inter_cell_distance
    num_cells double = 1;
end
assert(num_cells<=7 , 'Does not support more than 7 cells');

x =zeros(1,num_nodes*num_cells);
y = zeros(1, num_nodes*num_cells);
cellIDVec = zeros(1,num_nodes*num_cells);

% Using roots of unity for tiling
cellCenterVec = [0 exp([1/6:1/6:1]*2j*pi)] * inter_cell_distance;
gatewaySignalReach = radius/sqrt(3); % Unused


for cellId = 1:num_cells
    for i = 1:num_nodes
        x_t = 2*radius*(rand(1)-0.5);
        y_t = 2*radius*(rand(1)-0.5);
        while(~(sqrt(x_t^2+y_t^2)<radius)&&(x_t~=0||y_t~=0))
            x_t = 2*radius*(rand(1)-0.5);
            y_t = 2*radius*(rand(1)-0.5);
        end
        x((cellId-1)*num_nodes + i) = x_t + real(cellCenterVec(cellId));
        y((cellId-1)*num_nodes + i) = y_t + imag(cellCenterVec(cellId));
        cellIDVec((cellId-1)*num_nodes + i) = cellId;
    end
end

nodes_position = struct('x',x,'y',y,'cellId',cellIDVec);
gateway_position = struct('x',real(cellCenterVec(1:num_cells)),'y',imag(cellCenterVec(1:num_cells)),'signalReach',gatewaySignalReach);
fig = scatter(nodes_position.x,nodes_position.y);
hold on;
for cellId = 1:num_cells
    scatter(real(cellCenterVec(cellId)),imag(cellCenterVec(cellId)),'filled');
end
hold off;
grid on
grid minor


end

