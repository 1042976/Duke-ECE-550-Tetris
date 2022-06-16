# TETRIS

### **Baseline (68%)**

The biggest portion of your grade will come from a baseline TETRIS game described below. The main gameplay (moving blocks) must be displayed on a VGA screen to receive points.

**I/O (12%)**

Your game should include I/O for the players to control the movement of falling pieces. - Level 1 6%: using the buttons/switches on the FPGA
 \- Level 2 12%: using PS2 keyboard

**Falling Pieces of Different Shapes (17%)**

Your game should have pieces of different shapes that fall at a rate of at least 2 Hz (i.e. refresh every 0.5 seconds) until it reaches the bottom.

\- Level 1 9%: at least one shape with 4 or more squares
 \- Level 2 13%: at least three shapes with 4 or more squares; at least one of them can’t be

a rectangle
 \- Level 3 17%: at least five shapes with 4 or more squares; at least two of them can’t be a

rectangle

**Clear/Manage Lines (17%)**

Once a line is filled, all squares on this line should be cleared. If the top of the box (play area) is reached, the game will stop.

\- Level 1 5%: the game stops if the top of the box is reached.
 \- Level 2 9%: line can be cleared but squares on higher lines do not drop to fill in the empty

space
 \- Level 3 17%: line can be cleared and squares on higher lines can drop

**Rotation (10%)**

The player should be able to rotate the shapes in 90 degrees granularity.
 \- Level 1 5%: shapes can be rotated in 90 degrees granularity without using the processor - Level 2 10%: shapes can be rotated in 90 degrees granularity using the processor

**Scores (12%)**

Your game should show the user a score for the current game. - Level 1 7%: score is shown on the FPGA
 \- Level 2 12%: score is shown on the VGA screen

Using Processor: You have to use the provided processor to implement at least 2 tasks out of these 5 tasks. Otherwise, your implementation points will be deducted by 20%.

**Add-ons (17%)**

The rest of the implementation points come from your add-on features. You can implement any combinations of add-ons to get the 17%. As with the baseline points, your score will depend on the quality of your implementation, with the maximum score noted in parentheses next to each add-on option. Note that you cannot exceed 17% for add-ons. If you do attempt multiple add-ons, we will grade the best of the add-ons that add to 17% (again, see the grading example below for clarification).

**Interrupts (12%)**

Using processor (you will have to modify it), allow the user to interrupt the current game, e.g., the user can press a key to pause the game and resume, or to use a wild-card to eliminate all lines.

**Controller (12%)**

Build your own physical game controller and using GPIO on the FPGA to control movement and rotation.

**Pseudo-Random Block Placement (12%)**

Rather than hard-coding/pre-computing the placement of blocks in a new level, create a pseudo- random method of placing blocks in the level.

**Leaderboard (5%)**

Record scores for all games played in the current session and allow the user to display a leaderboard showing the top 3 players with some kind of identification (e.g., time).

**Speed Power-Up (5%)**

Cause the speed of block falling to increase/decrease as a result of a specific chain of events in your game (e.g. trigger a speed power-up after some type of game event).

**Demo (15%)**

Your demo will be comprised of the following tasks:

- A 5-minute presentation to the instructor, the instructional specialist and other students in

  ECE 550

- A real-time demo to the instructional specialist to showcase all functionalities that you have

  accomplished

  The presentation will be 5-minute ONLY. You are expected to prepare a PPT to facilitate your presentation. Please clearly highlight your novel ideas and accomplishments in your presentation.

  Your presentation will be graded based on your ability to articulate technical information in a concise and cohesive manner. Every group member must substantially participate in the presentation.

### **Add-Ons**

**Interrupts:** Leo modified the processor to cause the game to pause when he hits the “P” key on the keyboard. However, the pause key does not work when a player is moving blocks. He would get a score between 0 to 12% because he attempted interrupts, but the TAs decided to give him **8%**.

**Pseudo-Random Block Placement:** In Leo’s game, different block layouts exist with different playthroughs. He used data from user input through the keyboard and a series of processor arithmetic operations to “randomly” layout blocks in his game. **12%
 Leaderboard:** Leo tracks the scores for all games played in the current session and offers the option to display a leaderboard showing the top 3 scores, identified by the time at which the game with that score ended. **5%**

**Add-ons Subtotal = Max(8%, 12%) + 5% = 12% + 5% = 17%
 Implementation Score = Baseline + Add-ons = 42% + 17% = 59% (Out of 85%)**



### Our Grade: 91/100
