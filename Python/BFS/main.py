def BFS(newGraph, startNode, desiredNode):
    visited = [] #array to keep track of visited nodes
    queue = [] #array to track paths that needs to be traversed

    queue.append(startNode) ##looking at start node neighbors first

    while queue: #while queue isn't empty
        path = queue.pop(0) #start path is the first node and removing it
        
        currNode = path[-1] #set tail of path as current
        
        if currNode not in visited:
            visited.append(currNode) #marking current node as visited now
    
            #neighbors of current node  
            #directed nodes showin in graph variable
            adjNodes = newGraph[currNode]

            for neighbor in adjNodes:
                newPath = list(path) #generate list of new path
                newPath.append(neighbor) #adding current node to path list
                queue.append(newPath) #store current path to queue to get tail
                
                if neighbor == desiredNode: #if reached, return the path
                    return newPath
                
    return [] #no path detected
    
def pathFunction (newGraph, startNode, desiredNode):
    path = BFS(newGraph, startNode, desiredNode)
    print (path)
    
    if path == []: #if path doesn't exist
        print("No path")

def removeEdges(graph, removeArr):
    for edges in removeArr: #edges of nodes
        
        #Gets the the neighbor of the current node and removes
        #the edges connecting the two
        for neighbor in graph[edges]: 
            graph[neighbor].remove(edges)
            
        graph[edges] = [] #clearing AL for that node
    
    return graph

if __name__ == "__main__":
    
    graph = {
        "1" : ["2","9"],
        "2" : ["3","10","1"],
        "3" : ["4","11","2"],
        "4" : ["5","12","3"],
        "5" : ["6","13","4"],
        "6" : ["7","14","5"],
        "7" : ["8","15","6"],
        "8" : ["16","7"],
        "9" : ["10","17","1"],
        "10" : ["11","18","9","2"],
        "11" : ["12","19","10","3"],
        "12" : ["13","20","11","4"],
        "13" : ["14","21","12","5"],
        "14" : ["15","22","13","6"],
        "15" : ["16","23","14","7"],
        "16" : ["24","15","8"],
        "17" : ["18","25","9"],
        "18" : ["19","26","17","10"],
        "19" : ["20","27","18","11"],
        "20" : ["21","28","19","12"],
        "21" : ["22","29","20","13"],
        "22" : ["23","30","21","14"],
        "23" : ["24","31","22","15"],
        "24" : ["32","23","16"],
        "25" : ["26","33","17"],
        "26" : ["27","34","25","18"],
        "27" : ["28","35","26","19"],
        "28" : ["29","36","27","20"],
        "29" : ["30","37","28","21"],
        "30" : ["31","38","29","22"],
        "31" : ["32","39","30","23"],
        "32" : ["40","31","24"],
        "33" : ["34","41","25"],
        "34" : ["35","42","33","26"],
        "35" : ["36","43","34","27"],
        "36" : ["37","44","35","28"],
        "37" : ["38","45","36","29"],
        "38" : ["39","46","37","30"],
        "39" : ["40","47","38","31"],
        "40" : ["48","39","32"],
        "41" : ["42","49","33"],
        "42" : ["43","50","41","34"],
        "43" : ["44","51","42","35"],
        "44" : ["45","52","43","36"],
        "45" : ["46","53","44","37"],
        "46" : ["47","54","45","38"],
        "47" : ["48","55","46","39"],
        "48" : ["56","47","40"],
        "49" : ["50","57","41"],
        "50" : ["51","58","49","42"],
        "51" : ["52","59","50","43"],
        "52" : ["53","60","51","44"],
        "53" : ["54","61","52","45"],
        "54" : ["55","62","53","46"],
        "55" : ["56","63","54","47"],
        "56" : ["64","55","48"],
        "57" : ["58","49"],
        "58" : ["59","57","50"],
        "59" : ["60","58","51"],
        "60" : ["61","59","52"],
        "61" : ["62","60","53"],
        "62" : ["63","61","54"],
        "63" : ["64","62","55"],
        "64" : ["63","56"]
    }
    
    removeArr = [] #Array to hold removed nodes
    
    #Asking input for node removal
    num = int(input("How many nodes to remove: "))
    
    if num != 0:
        print("List them:")
    
        #Adding in node 1,2,3,...n that you want to remove
        for i in range(num):
            removedNodes = input("Node "+ str(i+1) + ": ")
            removeArr.append(str(removedNodes)) #adding input into remove array
    
    #Creation of graph with changed setup
    graph = removeEdges(graph, removeArr)

    ##Setting up the start node and goal node
    startNode = "7"
    desiredNode = "43"

    pathFunction(graph, startNode, desiredNode) 
