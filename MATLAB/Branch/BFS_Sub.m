function [branchPath] = BFS_Sub(grid, adjNode, farthestNode, fireNode, unAccessible)
    
    % Initialize BFS containers
    [gridX, gridY] = size(grid); % dimensions of the graph
    queue = []; % queue container - storing nodes to visit
    visited = zeros(gridX, gridY); % visited containter - Nodes that has been visited
    pred = zeros(gridX, gridY, 2); % predecessor container - Reconstuct path
    
    % Node adjustments for 1-based indexing
    adjNode = adjNode + 1;
    fireNode = fireNode + 1;
    farthestNode = farthestNode + 1;

    % Enqueue the start node and mark as visited
    queue(end+1, :) = adjNode;
    visited(adjNode(1), adjNode(2)) = 1;

    % BFS algorithm
    branchFound = false; %indicate if the branch path is found
    while ~isempty(queue)
        currNode = queue(1, :);
        queue(1, :) = []; % Dequeue

        % Check if the current node is the target/fire node
        if isequal(currNode, fireNode) || isequal(currNode, farthestNode)
            branchFound = true;
            break;
        end

        adjNodes = [1, 0; -1, 0; 0, 1; 0, -1]; % up, down, left, right
        
        % Explore valid adjacent nodes
        for i = 1:4
            newPos = currNode + adjNodes(i, :); %calculates new position
            
            % Check if newPos is within grid bounds, not an obstacle, not visited, and accessible
            if newPos(1) >= 1 && newPos(1) <= gridX && newPos(2) >= 1 && newPos(2) <= gridY && ...
               grid(newPos(1), newPos(2)) ~= -1 && visited(newPos(1), newPos(2)) == 0 && ...
               ~unAccessible(newPos(1), newPos(2))
               
                queue(end+1, :) = newPos; % enqueue the valid adjacent node
                visited(newPos(1), newPos(2)) = 1; % mark as visited
                pred(newPos(1), newPos(2), :) = currNode; % Record predecessor
            end
        end
    end

    branchPath = [];
    if branchFound

         % Determininig the target node for backtracing
        if isequal(currNode, fireNode)
            backtraceNode = fireNode;
        else
            backtraceNode = farthestNode;
        end
        % Backtrace from target node to the adjacent node
        currNode = backtraceNode;

        while ~isequal(currNode, adjNode)
            branchPath = [currNode; branchPath];  % Append current node to branch path
            currNode = squeeze(pred(currNode(1), currNode(2), :))'; % Move to predecessor
        end
        
        % Subtract from the nodes to get correct Nodes
        branchPath = [adjNode-1; branchPath-1];
        
    end
end
