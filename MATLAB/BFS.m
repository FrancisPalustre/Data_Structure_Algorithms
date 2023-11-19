% Start and end nodes
startNode = [0, 2]; % [y,x]
endNodes = [6, 6]; 

% Grid dimensions
gridX = 6;
gridY = 6;

% Obstacles [y,x]
obstacles = [0, 3; 
             1, 1; 
             1, 2; 
             6, 0; 
             3, 1; 
             5, 5;
             5, 4;
             3, 2;
             4, 3];

% Grid initializations
grid = zeros(gridX + 1, gridY + 1);

% Setting obstacles for grid
for i = 1:length(obstacles)
    grid(obstacles(i, 1) + 1, obstacles(i, 2) + 1) = -1;
end

% BFS containers
queue = []; % queue container
visited = zeros(gridX + 1, gridY + 1); % visited container
pred = zeros(gridX + 1, gridY + 1, 2); % predecessor container

% Storing first node in queue and marking as visited
queue(end+1,:) = startNode + 1;
visited(startNode(1) + 1, startNode(2) + 1) = 0.1;

% BFS algorithm
pathFound = false;
while ~isempty(queue)
    currNode = queue(1,:); % getting first node from queue
    queue(1,:) = []; % remove from queue

    % Check if endNode and currNode are the same
    if isequal(currNode, endNodes + 1)
        pathFound = true;
        break;
    end

    % Exploring adjNodes
    adjNodes = [1, 0; -1, 0; 0, 1; 0, -1]; % up, down, left, right
    for i = 1:4
        newPos = currNode + adjNodes(i,:);
        % Check whether node is obstacle or visited
        if newPos(1) >= 1 && newPos(1) <= gridX + 1 && newPos(2) >= 1 && newPos(2) <= gridY + 1 && ...
           grid(newPos(1), newPos(2)) ~= -1 && visited(newPos(1), newPos(2)) == 0
            % top line checks if within grid bounds, bottom checks if it is
            % obstacles

            queue(end+1,:) = newPos; % enqueue
            visited(newPos(1), newPos(2)) = 1; % mark as visited
            pred(newPos(1), newPos(2), :) = currNode; % store in predecessor container
        end
    end
end

% Backtrace to find final path
path = [];
if pathFound
    currNode = endNodes + 1;

    while ~isequal(currNode, startNode + 1)
        path = [currNode - 1; path];
        currNode = squeeze(pred(currNode(1), currNode(2), :))';
    end
    path = [startNode; path];
end

% Plotting final graph/path
if ~isempty(path)
    plot(path(:, 2), path(:, 1), 'LineWidth', 2.0);
    hold on;
end

% Plotting start and end nodes
plot(startNode(2) , startNode(1) , '-s', 'MarkerSize', 8, 'MarkerFaceColor', 'g'); 
text(startNode(2) + 0.25, startNode(1) + 0.25 , 'Start', 'FontSize', 10);

plot(endNodes(2) , endNodes(1), '-s', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
text(endNodes(2) + 0.25, endNodes(1) + 0.25, 'End', 'FontSize', 10);

% Plotting obstacles
for i = 1:size(obstacles, 1)
    plot(obstacles(i, 2), obstacles(i, 1), 'ks', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
end

% Grid settings
grid on;
ax = gca;
ax.XColor = 'r';
ax.YColor = 'r';
ax.GridAlpha = 1;
axis equal;

xlabel('x [m]');
ylabel('y [m]');
title('BFS');

xlim([0 gridX]);
ylim([0 gridY]);

hold off;