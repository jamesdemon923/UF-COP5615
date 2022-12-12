# Project 4:

### Group members:

**Haolan Xu(34326768)**

**Jiangan Chen(36765451)**

### Environment:

**Windows 11**

**IntelliJ**

### Implement:

#### Initialize

Run the modules in this order:

**server:init().** This initializes the server process

**simulator:init(N).** This initializes the simulator process, and N denotes the total number of virtual twitter users. And you can set any number from 1 ~ 5000

**client:init().** This initializes the client process, means that you could create your own account, log in, tweet, retweet, subscribe, do anything with the client process

On the terminal you’ll see different moves denoted with different numbers

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps1.jpg) 

You could type in 1 to register your own account

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps2.jpg) 

You can type in 2 to log in your account

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps3.jpg) 

If you type in the wrong user name you’ll get an error

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps4.jpg) 

Also if you type in the right user name but wrong password you’ll get an error

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps5.jpg) 

If you remember your user name and password correctly you’ll log into the account

If you didn’t run “simulator:init(N)” previously, you are the only user in the whole net. In this case, tweeting, subscribing, and querying wouldn’t mean anything, so it is recommended that you run “simulator:init(N)” first to create some virtual users.

For example, we initialize 10 virtual users

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps6.jpg) 

Now they are all logged in. In consideration of convenience, we’ve created an administrator who could see all the user names, all the passwords, all the online status and all the tweets

Simply use “admin” and “phil0” to log in(because it was default), and you’ll see all the virtual users

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps7.jpg) 

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps8.jpg) 

You can see everyone is online, because nobody logged out yet

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps9.jpg) 

You can see all the tweets they sent. Because these tweets are generated randomly, it makes sense that 10 virtual users generate 3 tweets

#### Client

In this part we’ve implemented all the functionalities

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps10.jpg) 

Basically all the operations from the keyboard go into the client session, then sent to the server session, then user sees the result from the terminal

#### Server

Server receives two kinds of information, one from keyboard, the other from virtual users, but the server treats them the same

#### Simulator

Simulator basically does all the creating work. Simulator session has a simulatorControl thread, who leads all the moves. All the commands are sent from the simulatorControl thread, and when a move is completed, the virtual user will send back a message to inform the main thread that this user is done. Also simulatorControl thread does the time calculation, and all the output pertaining to virtual users

#### Performance

**10 users**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps11.jpg) 

**50 users**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps12.jpg) 

**100 users**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps13.jpg) 

**500 users **

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps14.jpg) 

**1000 users**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps15.jpg) 

**2000 users**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps16.jpg) 

**3000 users**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps17.jpg) 

**4000 users**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps18.jpg) 

**5000 users**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps19.jpg) 

### Output(Test with)

**Register**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps20.jpg) 

**Tweet with none/hashtag/mention**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps21.jpg) 

**Subscribe**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps22.jpg) 

**Query hashtag/mention/user's subscriber**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps23.jpg) 

**Connect/disconnect/liveview**

![img](file:///C:\Users\James\AppData\Local\Temp\ksohtml121872\wps24.jpg) 
