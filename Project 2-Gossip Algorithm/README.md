# Project 2

### Group members:

**Haolan Xu(34326768)**

**Jiangan Chen(36765451)**

### Requirements:

1. What is working
   We used different data structures in different topologies. First we have different types of nodes, that means in different topologies, the arguments that the nodes carry are different. Basically we generate different Names for different threads, to get unique pids so that when a thread receives rumor, he can know who his neighbors are and send rumor to them. In full topology, neighbors are just all the threads other than self. In this topology we simply use serial numbers to represent different nodes. In 2D topology it's a bit more complex. We used coordinates to represent diffenrent nodes. For example, node (4, 3) could only access these nodes: (3, 2), (3, 3), (3, 4), (4, 2), (4, 4), (5, 2), (5, 3), (5, 4), by doing so we have a list of coordinate operations for (4, 3) to get to his neighbors, so that every time when a node needs to get a neighbor id, we randomly pick a operation in the operation list, then we get the coordinate of the neighbor, then we get pid and we pass rumor onto that node. In imperfect 2D it's basically the same. In line topology, every node could only access their previous node and the next node so the operation list would be (-1, 1), that means we randomly let the node pass rumor forward or backward. For two different algorithm we just implemented them as the requirements.

2. What is the largest network you managed to deal with for each type of topology and algorithm?
   
   **For Gossip**
   
   |  **Topologies**   | Largest Nodes |
   | :---------------: | :-----------: |
   |   Full Network    |    260000     |
   |      2D Grid      |    260000     |
   |       Line        |    260000     |
   | Imperfect 3D Grid |    260000     |
   
   **For Push-Sum**
   
   |  **Topologies**   | Largest Nodes |
   | :---------------: | :-----------: |
   |   Full Network    |    260000     |
   |      2D Grid      |    260000     |
   |       Line        |    260000     |
   | Imperfect 3D Grid |    260000     |
   
   
   
3. For each type of topology and algorithm, draw the dependency of convergence time as a function of the size of the network

   **Gossip**

   |              |   100   |   500    |   1000   |   5000    |   10000   |   50000   |  100000  |
   | :----------: | :-----: | :------: | :------: | :-------: | :-------: | :-------: | :------: |
   | gossip-full  | 27.4432 | 118.4768 | 323.072  | 1279.2832 | 2035.0976 | 8679.424  | 18662.3  |
   |  gossip-2D   | 11.1616 | 30.6176  | 88.4736  | 149.7088  | 255.5904  | 341.2992  | 858.112  |
   | gossip-line  |  5.632  |  6.7584  |  6.4512  |  5.4272   |  5.5296   |   6.144   |  7.168   |
   | gossip-imp2D | 38.5024 | 124.3136 | 156.0576 | 935.1168  | 1495.3472 | 5869.4656 | 12000.26 |
   
   ![image-20221009134722818](C:\Users\James\AppData\Roaming\Typora\typora-user-images\image-20221009134722818.png)
   
   **Push-Sum**

|                |    10    |    50     |   100    |     500     |    1000     |
| :------------: | :------: | :-------: | :------: | :---------: | :---------: |
| push-sum-full  | 335.1552 | 2298.9824 | 9326.49  | 116903.424  | 236892.672  |
|  push-sum-2D   | 358.8096 | 7186.2272 | 27454.16 | 516318.208  | 1861466.833 |
| push-sum-line  | 385.3312 | 2033.2544 | 3863.347 |  7096.6272  |  8697.1392  |
| push-sum-imp2D | 389.632  | 6504.8576 | 27137.23 | 135072.5632 | 375171.072  |

![image-20221009135926739](C:\Users\James\AppData\Roaming\Typora\typora-user-images\image-20221009135926739.png)
