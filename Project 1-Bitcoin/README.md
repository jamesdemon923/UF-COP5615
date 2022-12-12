# Project 1

### Group members:

**Haolan Xu(34326768)**

**Jiangan Chen(36765451)**

### Requirements:

1. Size of the work unit that you determined results in the best performance for your implementation and an explanation of how you determined it. The size of the work unit refers to the number of sub-problems that a worker gets in a single request from the boss.

   We used 8 actors in our implementation at first. But when we increase this number to 12, 16, Real time to CPU time ratio lifts. Considering the time used for mining, we decide the number of actors is 16. This behavior varies for different number of required leading zeroes. We determine this number by hit and trial method.

2. The result of running your program for input 4
   OUTPUT:
   0000d36c0223fd53a90b17ac599f36a2bc6db900e50d6d436a00a4d29c781965            haolan$2~7
   0000089746229b48418fb04bc9b402a22a5f94dbc0128e9b0c7ca3b45c6d9d5d            jiangan'S<v{~LzO

   ![image-20220923164138819](C:\Users\James\AppData\Roaming\Typora\typora-user-images\image-20220923164138819.png)

3. The running time for the above as reported by time for the above and report the time. The ratio of CPU time to REAL TIME tells you how many cores were effectively used in the computation. If you are close to 1 you have almost no parallelism (points will be subtracted).
   
   OUTPUT:
   
   0000a24adff7bf4ae46c437a9c3666fd86faa12d196a9854624dd3ace5630500            haolanZ#=X1_a
   CPU time: 1.329 seconds
   real time: 0.633 seconds
   Ratio: 2.0995260663507107 
   
4. The coin with the most 0s you managed to find.
   7 0s
   00000007d50727a62c07a3dc46f33385f9c52e6c45085228b2452277b44b8700            jiangansfeRp

5. The largest number of working machines you were able to run your code with.
   1, we haven't achieved the connection between different terminals(computers).

