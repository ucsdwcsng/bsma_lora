function capacity = decode_with_capture(nodes,tdiag_ap,packet_duration, gateway_position, CE_Thresh)
num_nodes = numel(nodes);
num_cells = numel(gateway_position.x);

capacity = zeros(1,num_nodes);
for j = 2:size(tdiag_ap,1)-1
    if(tdiag_ap(j,1)-tdiag_ap(j-1,1)==1)    % A packet has arrived at AP
        if(tdiag_ap(j+1,2)-tdiag_ap(j,2)==packet_duration)
            % 
            capacity(tdiag_ap(j,3)) = capacity(tdiag_ap(j,3))+1; % No collision
        else
            coll_nodes = [tdiag_ap(j,3)];
            startEndVec = [1];
            collTimeVec = [tdiag_ap(j,2)];
            i = j+1;
            while(tdiag_ap(j,3)~=tdiag_ap(i,3))
                coll_nodes = [coll_nodes, tdiag_ap(i,3)];
                startEndVec = [startEndVec tdiag_ap(i,1)-tdiag_ap(i-1,1)];
                collTimeVec = [collTimeVec tdiag_ap(i,2)];
                
                i = i+1;
                if(i>size(tdiag_ap,1))
                    break;
                end
            end
            
            % Multiple gateways
            for cellIdx = 1:num_cells
                
                RSS = zeros(1,length(coll_nodes));
                for k = 1:length(coll_nodes)
                    x = nodes(coll_nodes(k)).x;
                    y = nodes(coll_nodes(k)).y;
                    RSS(k) = getRSS(x,y,gateway_position.x(cellIdx),gateway_position.y(cellIdx));
                end
                

                [RSS,idx] = sort(RSS,'descend');
                index = find(idx==1);
                RSS_comp = 10*log10(sum(db2pow(RSS(2:end))));
                
                if(size(coll_nodes,2)==1)
                    if(nodes(coll_nodes(1)).cellId==cellIdx)
                        capacity(tdiag_ap(j,3)) = capacity(tdiag_ap(j,3))+1;
                        break;
                    else
                        continue;
                    end
                elseif((index==1)&&(RSS(1)-RSS_comp>CE_Thresh))
                    if(nodes(coll_nodes(1)).cellId==cellIdx)
                        capacity(tdiag_ap(j,3)) = capacity(tdiag_ap(j,3))+1;
                        break;
                    else
                        continue;
                    end
                end
            end
        end
    end
end
end