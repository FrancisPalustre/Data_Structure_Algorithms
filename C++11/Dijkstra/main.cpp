#include <iostream>

//Random number generation 
#include <cstdlib> 
#include <time.h> 

//Dijkstra Libraries
#include <queue>
#include <algorithm>
#include <unordered_map>
#include <vector>

using namespace std;

unordered_map<string, unordered_map<string, int>> randWeights (unordered_map<string, unordered_map<string, int>> graph) {
	srand(time(0)); //generates new numbers for every execution based on node
    for (auto &node : graph) {//for every node in the graph...
		for (auto &adjNodes : node.second) { //for every neighbor node, referencing the value of the pair 
			adjNodes.second = rand() % 100; //generates a random number between 1-99
		}
	}
	return graph;
}

vector<string> Dijkstra(unordered_map<string, unordered_map<string, int>> graph, string startNode, string desiredNode) {
    priority_queue<pair<int, string>, vector<pair<int, string>>, greater<pair<int, string>>> pq; //stores smallest distance
    
    //store the shortest distance found
    unordered_map<string, int> distances;
    
    //store the predecessor of shortest path
    unordered_map<string, string> predecessors;
    
    vector<string> visited; //store visited
    
    //initialize distances to infinity and set distance of start node to 0
    for (const auto &node : graph) {
        distances[node.first] = numeric_limits<int>::max();
    } distances[startNode] = 0;
    
    pq.push({0, startNode}); //add start node to pq w/ initial value of 0
    
    while (!pq.empty()) {
        //get the node's value with the smallest distance from the priority queue
        string currNode = pq.top().second;
        pq.pop();
        
        //skips if node already has been visited
        vector<string>::iterator visitedNode = find(visited.begin(), visited.end(), currNode);
        if (visitedNode != visited.end()) {
            continue;
        }
        
        //mark this node as visited
        visited.push_back(currNode);
        
        for (const auto neighbor : graph[currNode]) { //for every neighbor of currNode..
            
            string neighborNode = neighbor.first; //grabbing neighboring node of pair
            int edgeWeight = neighbor.second; //grabbing value of neighbor from pair
            int newDistance = distances[currNode] + edgeWeight; //calculates that changed distance
            
            //if newDistance is less than current distance of neighbor
            if (newDistance < distances[neighborNode]) {
                
                //updating values w/ new set
                distances[neighborNode] = newDistance;
                predecessors[neighborNode] = currNode;
                
                pq.push({newDistance, neighborNode}); //storing new nodes into queue
            }
        }
    }
    
    //reorganizes path since current is last to first, converting to first to last
    vector<string> path;
    for (string at = desiredNode; at != ""; at = predecessors[at]) {
        path.push_back(at);
    }
    reverse(path.begin(), path.end());
    return path;
}

void roboMove(unordered_map<string, unordered_map<string, int>> graph, string startNode, string desiredNode) {
	vector<string> roboPath =  Dijkstra(graph, startNode, desiredNode);

	//couts the generated path
    cout << "\nPath: ";
	for (const string node : roboPath) {
    	cout << node << " "; 
	} cout << endl;
}

unordered_map<string, unordered_map<string, int>> removeEdges(unordered_map<string, unordered_map<string, int>> graph ,vector<string> removeVec) {
	for (const string node : removeVec) {  //for every node in the removeVec...
        for (const auto edge : graph[node]) {  //for every edge of the current node... (auto is used so I dont have to type out iterator)
            string adjNode = edge.first;  //get the adjacent node's key
            graph[adjNode].erase(node);  //remove the edge from the adjacent node to the current node
        }
        graph[node].clear();  //remove all edges from the current node
    }
	return graph;
}

int main() {
	//AL of current 8x8 Graph
	unordered_map<string, unordered_map<string, int>> graph = {
        	{"1", {{"2", 1}, {"7", 1}}},
        	{"2", {{"1", 1}, {"8", 1}, {"3", 1}}},
        	{"3", {{"2", 1}, {"9", 1}, {"4", 1}}},
        	{"4", {{"3", 1}, {"10", 1}, {"5", 1}}},
        	{"5", {{"4", 1}, {"11", 1}, {"6", 1}}},
        	{"6", {{"5", 1}, {"12", 1}}},
        
        	{"7", {{"13", 1}, {"8", 1}, {"1", 1}}},
        	{"8", {{"14", 1}, {"9", 1}, {"2", 1}, {"7", 1}}},
        	{"9", {{"15", 1}, {"10", 1}, {"3", 1}, {"8", 1}}},
	        {"10", {{"16", 1}, {"11", 1}, {"4", 1}, {"9", 1}}},
	        {"11", {{"17", 1}, {"12", 1}, {"5", 1}, {"10", 1}}},
	        {"12", {{"18", 1}, {"11", 1}, {"6", 1}}},
        
	        {"13", {{"19", 1}, {"14", 1}, {"7", 1}}},
	        {"14", {{"20", 1}, {"15", 1}, {"8", 1}, {"13", 1}}},
	        {"15", {{"21", 1}, {"16", 1}, {"9", 1}, {"14", 1}}},
	        {"16", {{"22", 1}, {"17", 1}, {"10", 1}, {"15", 1}}},
	        {"17", {{"23", 1}, {"18", 1}, {"11", 1}, {"16", 1}}},
	        {"18", {{"24", 1}, {"17", 1}, {"12", 1}}},
        
	        {"19", {{"25", 1}, {"20", 1}, {"13", 1}}},
	        {"20", {{"26", 1}, {"21", 1}, {"14", 1}, {"19", 1}}},
	        {"21", {{"27", 1}, {"22", 1}, {"15", 1}, {"20", 1}}},
	        {"22", {{"28", 1}, {"23", 1}, {"16", 1}, {"21", 1}}},
	        {"23", {{"29", 1}, {"24", 1}, {"17", 1}, {"22", 1}}},
	        {"24", {{"30", 1}, {"23", 1}, {"18", 1}}},
        
	        {"25", {{"31", 1}, {"26", 1}, {"19", 1}}},
	        {"26", {{"32", 1}, {"27", 1}, {"20", 1}, {"25", 1}}},
	        {"27", {{"33", 1}, {"28", 1}, {"21", 1}, {"26", 1}}},
	        {"28", {{"34", 1}, {"29", 1}, {"22", 1}, {"27", 1}}},
	        {"29", {{"35", 1}, {"30", 1}, {"23", 1}, {"28", 1}}},
	        {"30", {{"36", 1}, {"29", 1}, {"24", 1}}},
	        
	        {"31", {{"32", 1}, {"23", 1}}},
	        {"32", {{"33", 1}, {"26", 1}, {"31", 1}}},
	        {"33", {{"34", 1}, {"27", 1}, {"32", 1}}},
	        {"34", {{"35", 1}, {"28", 1}, {"33", 1}}},
	        {"35", {{"36", 1}, {"29", 1}, {"34", 1}}},
	        {"36", {{"35", 1}, {"30", 1}}}
    };

	//Setting parameters for path traversal
    	string startingNode = "";
    	string desiredNode = " ";
	int nodeRemoval =0;
        
	cout << "Starting Node: ";
	cin >> startingNode;
	        
	cout << "Desired Node: ";
	cin >> desiredNode;
	
	cout << "\nHow many nodes to remove: ";
	cin >> nodeRemoval;
    
	//vector that houses the nodes/edges you
	//want to remove from graph
    	vector <string> removeVec;
    	string input = "";
        
	cout << "\nList:" <<endl;
    
	for (int i =0; i < nodeRemoval; i++) {
        	cout << "Node " << i+1 << ": ";
        	cin >> input;
        	removeVec.push_back(input);    
     	}

	//Resultant graph after removing edges
	graph = removeEdges(graph, removeVec);

	//Resultant graph with the new weighted values
	graph = randWeights(graph);

	roboMove(graph, startingNode, desiredNode);

    return 0;
}
