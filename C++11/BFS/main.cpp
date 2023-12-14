#include <iostream>

//BFS Libraries
#include <unordered_map>
#include <vector>
#include <queue>
#include <algorithm> //used for find()

using namespace std;

vector<string> BFS(unordered_map<string, vector<string>> newGraph, string startingNode, string desiredNode) {
    //Creating containers of visited and queued values
    vector<string> visited;
    queue<vector<string>> queue;

    queue.push({startingNode}); //starting the queue with our starting node

    while (!queue.empty()) {
        vector<string> path = queue.front(); //first item in queue
        queue.pop();//removes it

        string currNode = path.back();//tailed node becomes current node

	//iteratoes through a set to find the current vakue in the path
        vector<string>::iterator findCurr = find(visited.begin(), visited.end(), currNode);

        if (findCurr == visited.end()) {
            visited.push_back(currNode);//marks as visited

            vector<string> adjNodes = newGraph[currNode]; //nearby nodes of current
            
	    for (const string& neighbor : adjNodes) {//iterates the adjNodes
        	vector<string> newPath = path;
                newPath.push_back(neighbor); //add neighbor to newPath vector
                queue.push(newPath); //adds resultant path to queue

                if (neighbor == desiredNode) {//if desired found, return current path
                    return newPath;
                }
            }
        }
    }
    return {};
}

unordered_map<string, vector<string>> removeEdges(unordered_map<string, vector<string>> graph, vector<string> removeVec) {
    for (const string& edges : removeVec) {//for every edges of the current node...
        for (const string& adjNodes : graph[edges]) {//for every node of those edges...
			
		//disconnects the connected nodes from current edge
		vector<string>::iterator removeNode = remove(graph[adjNodes].begin(), graph[adjNodes].end(), edges);

            graph[adjNodes].erase(removeNode, graph[adjNodes].end()); //getting rid of edges
        }
        graph[edges].clear(); //removing current node
    }
    return graph;
}

void roboMove(unordered_map<string, vector<string>> newGraph, string startNode, string desiredNode) {
    vector<string> carPath = BFS(newGraph, startNode, desiredNode);

    //Couts the generated path
    for (const string& node : carPath) {
        cout << node << " "; 
    } cout << endl;
}

int main()  {	
    unordered_map <string, vector <string>> graph = {
            {"1", {"2","5"}},
			{"2", {"3","6","1"}},
			{"3", {"4","7","2"}},
			{"4", {"8","3"}},
			{"5", {"6","1","9"}},
			{"6", {"5","10","7","2"}},
			{"7", {"6","11","8","3"}},
			{"8", {"12","7","4"}},
			{"9", {"10","13","5"}},
			{"10", {"11","14","9","6"}},
			{"11", {"12","15","10","7"}},
			{"12", {"8","11","6"}},
			{"13", {"14","9"}},
			{"14", {"15","10","13"}},
			{"15", {"16","11","14"}},
			{"16", {"15","12"}}
      };
		
	//Setting parameters for path traversal
        string startingNode =" ";
        string desiredNode = " ";
        
        cout << "Starting Node: ";
        cin >> startingNode;
        
        cout << "\nDesired Node: ";
        cin >> desiredNode;

        int nodeRemoval =0;

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

	//Resultant graph after changes
        unordered_map <string, vector<string>> newGraph = removeEdges(graph, removeVec);

        roboMove(newGraph, startingNode, desiredNode);
		
    return 0;
}
