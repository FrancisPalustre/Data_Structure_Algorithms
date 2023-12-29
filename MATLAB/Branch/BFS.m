function [primaryPath] = BFS (graph, startNode, endNode)

    % Initialize BFS containers
    [graphX, graphY] = size(graph); % dimensions of the graph
    queue = []; % queue container - storing nodes to visit
    visited = zeros(graphX, graphY); % visited containter - Nodes that has been visited
    pred = zeros(graphX, graphY, 2); % predecessor container - Reconstuct path
    
    % Enqueue the start node and mark as visited
    queue(end+1, :) = startNode + 1; % adjusting for MATLAB 1-indexing
    visited(startNode(1) + 1, startNode(2) + 1) = 0.1; % mark start node as visited

    % BFS algorithm
    primaryPathFound = false; % indicate if path is found
    while ~isempty(queue)
        currNode = queue(1, :); %set currNode as first item in queue
        queue(1, :) = []; %remove the first node from queue

        % Check if the current node is the end node
        if isequal(currNode, endNode + 1)
            primaryPathFound = true;
            break;
        end

        % Adjacent node movements: up, down, left, right
        adjNodes = [1, 0; -1, 0; 0, 1; 0, -1]; 
        for i = 1:4
            newPos = currNode + adjNodes(i, :); % Calculate new position

            % Check if newPos is within graph bounds, not an obstacle, and not visited
            if newPos(1) >= 1 && newPos(1) <= graphX && newPos(2) >= 1 && newPos(2) <= graphY && ...
               graph(newPos(1), newPos(2)) ~= -1 && visited(newPos(1), newPos(2)) == 0
                
                queue(end+1, :) = newPos; % Enqueue the valid adjacent node
                visited(newPos(1), newPos(2)) = 1; % Mark as visited
                pred(newPos(1), newPos(2), :) = currNode; % Record predecessor
            end
        end
    end

    % Backtrace to find primary path
    primaryPath = [];
    if primaryPathFound
        currNode = endNode + 1; %backtracing from the end node
        while ~isequal(currNode, startNode + 1)
            primaryPath = [currNode - 1; primaryPath]; %append current node to path
            currNode = squeeze(pred(currNode(1), currNode(2), :))'; %go to predecessor nodes
        end
        primaryPath = [startNode; primaryPath]; % add start node to front of path
end
