% Node Initilization
startNode = [0, 8];
endNode = [8, 2]; 
fireNode = [6, 6];

% Grid dimensions
gridX = 8;
gridY = 8;

% Obstacles [x,y]
obstacles = [
    2, 8; 
    2, 7; 
    2, 6; 
    1, 6;

    0, 3; 
    1, 3;
    2, 3;
    3, 3;
    3, 2;
    3, 1;

    5, 0;
    5, 1;
    5, 3;
    6, 3;
    7, 3;
    8, 3;

    5, 6;
    5, 7;
    6, 7;
    7, 7;
    7, 6;

    6, 8;
];
% Grid initializations
grid = zeros(gridX, gridY);

% Matrix initialization to tracked marked spaces
unAccessible = false(size(grid)); %determing what spaces algorithm can visit

% Counter initialization
counter =0; %used to keep track of how many spaces are marked in unAccessible

% Setting obstacles for grid
for i = 1:size(obstacles, 1)
    %marking obstacle coords in grid
    grid(obstacles(i, 1)+1, obstacles(i, 2)+1) = -1;
    
    %marking obstacle coords in unAccessible grid
    obstaclePos = obstacles(i, :) + 1;
    unAccessible(obstaclePos(1), obstaclePos(2)) = true;
    
    counter = counter + 1; %incrementing counter
end

% Generates the starting path for traversal
primaryPath = BFS(grid, startNode, endNode);

% Adding primaryPath nodes into unAccessible grid/container
for i = 1:size(primaryPath, 1)
    node = primaryPath(i, :) + 1;
    unAccessible(node(1), node(2)) = true;
    counter = counter + 1;
end

% Initialize fullPath array to store the complete traversal path
fullPath = [];

% Explore adjacent nodes to the primary path and create branches
for i = 1 : length(primaryPath)
    %current node in primary path represented by current index
    currNode = primaryPath(i,:);
    
    fullPath = [fullPath; currNode]; %add current node to fullPath
    
    %possible movements that a node can do
    movement = [0, -1; 0, 1; -1, 0; 1, 0];
    
    % Check each adjacent node for possible branching
    for j = 1:size(movement,1)
        
        adjNodes = currNode + movement(j,:);%adjNode calculations 
        
         % Check if adjacent node is within grid bounds and not an obstacle
        if adjNodes(1) >= 0 && adjNodes(1) <= gridX && adjNodes(2) >= 0 && ...
            adjNodes(2) <= gridY && grid(adjNodes(1) + 1, adjNodes(2) + 1) ~= -1
            
             % Check if adjacent node is not part of the primary path or unAccessible
            if ~ismember(adjNodes, primaryPath, 'rows') && ...
                ~unAccessible(adjNodes(1) + 1, adjNodes(2) + 1)
                    
                % Find the farthest node from the adjacent node and
                % generate a branch path
                farthestNode = farthest_node(grid, adjNodes, unAccessible);
                branchPath = BFS_Sub(grid, adjNodes, farthestNode, fireNode, unAccessible);
                    
                % Update unAccessible with nodes from the branch path
                for z = 1:size(branchPath, 1)
                    node = branchPath(z, :) + 1;
                    unAccessible(node(1), node(2)) = true;
                    counter = counter + 1;
                end

                % Append the branch path and its reverse to the fullPath
                fullPath = [fullPath; branchPath; branchPath(end:-1:1, :)];
                
                % Return to the current node after exploring the branch
                fullPath = [fullPath; currNode];
            end
        end
    end
end

% Continue exploration until all accessible nodes are visited
% Comments are applied the same as the first branch traversal
while counter ~= numel(grid)

    % Explore adjacent nodes of the fullPath and create and subBranches
    for i = 1 : length(fullPath)
         currNode = fullPath(i,:);
         movement = [0, -1; 0, 1; -1, 0; 1, 0];
    
         for j = 1:size(movement,1)
             adjNode = currNode + movement(j,:);
    
            if adjNode(1) >= 0 && adjNode(1) <= gridX && adjNode(2) >= 0 && ...
                adjNode(2) <= gridY && grid(adjNode(1) + 1, adjNode(2) + 1) ~= -1
                
                if ~ismember(adjNode, fullPath, 'rows') && ...
                    ~unAccessible(adjNode(1) + 1, adjNode(2) + 1)

                   farthestNode = farthest_node(grid, adjNode, unAccessible);
                   branchPath = BFS_Sub(grid, adjNode, farthestNode, fireNode, unAccessible);
    
                   for k = 1:size(branchPath, 1)
                        node = branchPath(k, :) + 1;
                        unAccessible(node(1), node(2)) = true;
                        counter = counter +1;
                   end
                   
                   branchPath = [branchPath; branchPath(end:-1:1, :)];
                   fullPath = [fullPath(1:i, :); branchPath; fullPath(i:end, :)];
                   
                end
            end
         end
    end
end 

% Plotting the final result
plotting (fullPath, startNode, endNode, fireNode, obstacles, gridX, gridY)