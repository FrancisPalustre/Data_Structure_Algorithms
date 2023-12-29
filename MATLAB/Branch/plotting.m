function plotting(fullPath, startNode, endNode, fireNode, obstacles, gridX, gridY)
    % Figure Initilizations
    figure;
    hold on;
    grid on;
    axis equal;
    
    % Coordinate limits
    xlim([0 gridX]);
    ylim([0 gridY]);
    
    ax = gca; %orientated axis
    
    % Axis' colors and transparency
    ax.XColor = 'r';
    ax.YColor = 'r';
    ax.GridAlpha = 1;
    
    % Axis' Labels
    xlabel('x [m]');
    ylabel('y [m]');
    title('BFS');
    
    % Axis' Incrementations
    xticks(0:1:gridX);
    yticks(0:1:gridY);
    
    % Plotting Parameters 

    %path
    plot(fullPath(:, 1), fullPath(:, 2), 'Color', [0, 0.4470, 0.7410], 'LineWidth', 2);
    
    %startNode
    plot(startNode(1), startNode(2), '-s', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    text(startNode(1) + 0.25, startNode(2) + 0.25 , 'Start', 'FontSize', 10);
    
    %endNode
    plot(endNode(1), endNode(2), '-s', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    text(endNode(1) + 0.25, endNode(2) + 0.25, 'End', 'FontSize', 10);
    
    %fireNode
    plot(fireNode(1), fireNode(2), '-s', 'MarkerSize', 10, 'MarkerFaceColor', '#EDB120');
    text(fireNode(1) + 0.25, fireNode(2) + 0.25 , 'Fire', 'FontSize', 10);

    %obstacles
    for i = 1:size(obstacles, 1)
        plot(obstacles(i, 1), obstacles(i, 2), 'ks', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
    end

    %robotNode
    robotNode = plot(startNode(1), startNode(2), '-s', 'MarkerSize', 10, 'MarkerFaceColor', [0.4940 0.1840 0.5560]);
    
    % GIF creation parameters
    gifFilename = 'fire.gif'; 
    gifDelay = 0.5;
    
    % GIF Animation
    for j = 1:size(fullPath, 1)
        set(robotNode, 'XData', fullPath(j, 1), 'YData', fullPath(j, 2)); %updating frame
        drawnow; %redrawing frame after new frame
        pause(gifDelay) %adds delay to replicate animation
        
        % Capture the frame and write it to the GIF
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        
        % Creation of the frames for GIF file and updating
        if j == 1
            %initial creation
            imwrite(imind, cm, gifFilename, 'gif', 'Loopcount', inf, 'DelayTime', gifDelay);
        else
            %subsequent creation
            imwrite(imind, cm, gifFilename, 'gif', 'WriteMode', 'append', 'DelayTime', gifDelay);
        end
        
        % Stop animation when the fire node is reached
        if isequal(fullPath(j, :), fireNode)
            break; 
        end
    end
    
    hold off;
end