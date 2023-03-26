# bugs
Small QML game with bugs (ladybugs)

A little game I wrote to reuse the PS4 controller I have. Since QtGamepad is not working with two PS4 controller simultaneously, I used QJoysticks instead - thanks to [alex-spataru](https://github.com/alex-spataru "more info") for writing it.
My focus when I wrote the game was not to have a perfectly clean code, but on experimenting with some techniques, like joystick control (PS controller), collision detection, dynamic object creation, having a model in C++ (at least for the bugs), using a state machine for the game logic, loading/saving high score data, etc.

In the game you have two bugs (each controlled by a PS4 controller) that are trying to escape from birds that are flying over and that are trying to eat them. The birds have different sizes, speeds, directions, etc. The game starts with one bird and at the beginning of each level another bird appears. Each bug has three lifes. The bugs can collect items to gain a life or to get invincible for an amount of time. The game ends when both bugs are out of lifes.

Have fun!
