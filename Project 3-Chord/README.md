# Project 3

### Group members:

**Haolan Xu(34326768)**

**Jiangan Chen(36765451)**

### Requirements(We set <u>m</u> in our project as 10):

1. What is working
   We first created nodes randomly, then used the SHA-1 and Mod: 2<sup>m</sup>(m is set by us) to put them all on a circle named Chord Ring, and in the Chord Ring, every node knows who are its predecessor and successor. For the fingertable, we calculated it at first and stored it. With the fingertable, the nodes can hop to where the keys are with O(log<sub>2</sub>(N)). And we define the number of request as the number of keys that every node need to produce randomly. An node may hop different times to find each key, and we record the times of hops and get the average of them as the result for this node, then we get the average of results for all nodes, which is the final output of our code.

2. What is the largest network you managed to deal with?

   The number of nodes depends on **m**, in our project, when m = 10, the biggest number of nodes is 45.

3. The output in our project


| Number of Nodes | Number of Requests | The average number of hops |
| :-------------: | :----------------: | :------------------------: |
|        4        |         2          |            1.25            |
|        4        |         3          |            1.11            |
|        4        |         4          |            1.12            |
|       14        |         2          |            2.00            |
|       14        |         3          |            2.33            |
|       14        |         4          |            2.36            |
|       24        |         2          |            3.23            |
|       24        |         3          |            3.01            |
|       24        |         4          |            3.34            |





