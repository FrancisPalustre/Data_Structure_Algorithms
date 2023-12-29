function farthestNode = farthest_node(grid, startingNodes, unAccessible)
% BFS-Based
    
    % Initialize BFS containers
    [gridX, gridY] = size(grid); % dimensions of the graph
    visited = zeros(size(grid)); % visited containter - Nodes that has been visited
    queue = []; % queue container - storing nodes to visit
    distance = inf(size(grid));  % how many nodes it takes to reach the farthest node
    
    % Adjust for MATLAB's 1-based indexing
    startingNodeIndex = startingNodes + 1;
    queue(end + 1, :) = startingNodeIndex;
    visited(startingNodeIndex(1), startingNodeIndex(2)) = 1;
    distance(startingNodeIndex(1), startingNodeIndex(2)) = 0;
    
    % Initializiation of distance variables
    farthestNode = startingNodes;
    maxDistance = 0;
    
    % Farthest node modification algorithms 
    while ~isempty(queue)
        currNode = queue(1, :);
        queue(1, :) = [];
        
        % Movement of adjNodes
        adjPos = [currNode(1), currNode(2)-1; %down
                  currNode(1), currNode(2)+1; %up
                  currNode(1)+1, currNode(2); %right
                  currNode(1)-1, currNode(2)]; %left
        
        % Traversal of adjNodes
        for i = 1:size(adjPos, 1)
            adjNodes = adjPos(i,:);
            
             % Check if adjNodes is within grid bounds, not an obstacle, and accessible
            if adjNodes(1) >= 1 && adjNodes(1) <= gridX && adjNodes(2) >= 1 && ...
               adjNodes(2) <= gridY && grid(adjNodes(1), adjNodes(2)) ~= -1 && ...
               ~unAccessible(adjNodes(1), adjNodes(2))
                    
                    % Check if adjNodes have not been visited
                    if visited(adjNodes(1), adjNodes(2)) == 0

                        visited(adjNodes(1), adjNodes(2)) = 1; %mark as visited
                        queue(end + 1, :) = adjNodes; %add to queue

                        %the farthest node that has been found
                        distance(adjNodes(1), adjNodes(2)) = distance(currNode(1), currNode(2)) + 1;
                        
                         % Update farthest node if a new max distance is found
                        if distance(adjNodes(1), adjNodes(2)) > maxDistance
                            maxDistance = distance(adjNodes(1), adjNodes(2));
                            farthestNode = adjNodes - 1;
                        end        
                    end
            end
        end
    end
end
