![logo](https://user-images.githubusercontent.com/52884069/128723241-695ab0a2-fa93-46a3-ad35-3da025cd965d.png)
# 🎮 CODEMON - Educational Game

## Table of Contents
- [About](#about)
- [Getting Started](#getting_started)
- [History](#history)
- [How to Play](#how_to_play)
  - [Commands](#commands)
  - [Challenges](#challenges)
  - [Challenge - Logic Gate](#challenge_1)
  - [Challenge - Question and Answer](#challenge_2)
  - [Challenge - Algorithm Analysis](#challenge_3)
  - [Boss - Bubble Sort](#boss)
- [How to Create New Challenges](#how_to_create_new_challenges)

## About <a name = "about"></a>
This is a educational RPG game developed in Godot Game Engine in 2D pixel art. The main goal is introduce the fundamentals of programing, such as concept about variables and yours types, the arithmetic operator, the logic operator, control flow and the last challenge the bubble sort algorithm (BOSS). The game is for a single player, with the concept of exploration and RPG adventure in discovering new areas, challenging and capturing all codemons, completing missions and finally defeating the terrible bubble to restore order to the world. The player controls the character Jimmy who must solve the challenges offered by the codemons, according to the guidelines given by the NPCs during the journey.

## Getting Started <a name = "getting_started"></a>
Access the following link and download the “.zip” file with the name of the operating system installed on the machine that will run the game (ex. windows_x64.zip).
After downloading, you must extract and run the “Codemon” file to start the game.

Note: Linux is necessary to make it executable first.
```chmod +x Codemon.x86_64```

## History <a name = "history"></a>

![history](https://user-images.githubusercontent.com/52884069/128772988-62830d44-ebe8-4178-851b-51df7bf92364.png)

This is a story of Jimmy, a freshman at the Code Academy, who has a desire to capture every known codemon. In his first class Jimmy arrives late, being only in the room him and Dr. Compiler that understands Jimmy's delay and explains how the current situation in the Code World is, and tells that the bubble, the codemon capable of keeping order in the world; was attacked by some virus that affected its algorithm causing disorder among codemons. Then, Dr. Compiler is sending all his academics into the field to challenge the codemons and bring order back to the world, but as Jimmy is a freshman, Dr. Compiler will pay more attention to his adventure, guiding and explaining each codemon.

## How to Play <a name = "how_to_play"></a>
The player takes control of the avatar Jimmy that, through keyboard and mouse actions, will allow movement, interaction with NPCs and the execution of challenges. The game camera will follow the main character within the scenario, leaving the player free to make the decision of the direction he wants to take.
 
### Commands <a name = "commands"></a>
| Key | Description |
|--|--|
| Mouse Left Click | Interaction on Challenges |
| Up | Move Forward |
| Left| Move to Left |
| Down| Move Backward|
| Right| Move to Right |
| E | Interaction |
| ESC | Open the Menu |
| B | Open the Bestiary |
| Q | Open the Quest List |
| I | Open the Inventory|
| M | Open the Map |


### Challenges <a name = "challenges"></a>

![map](https://user-images.githubusercontent.com/52884069/128778385-305fec49-53aa-4b83-9ec5-eff77d0f7d41.png)

As a learning sequence and context with the game, the content structure and phased interaction were structured:
  1. **Code Academy**, begin of the game, transmits to the player the plot and interaction tutorials;
  2. **Variables Forest**, the first contact with the challenges of questions and answers and logic gates, as well as the learning tutorials about each variable;
  3. **Operators Mountain**, the first contact with first-level algorithm analysis challenges and learning tutorials about each arithmetic operator;
  4. **Condicionals Beach**, the first contact with second level algorithm analysis challenges and with learning tutorials about each logical operator;
  5. **Control Desert**, the first contact with third-level algorithm analysis challenges and learning tutorials on each control command;
  6. **Bubble Room**, the ultimate challenge with interactive bubble algorithm and bubble sort learning tutorial.

### Challenge - Logic Gate <a name = "challenge_1"></a>

![logic_gate](https://user-images.githubusercontent.com/52884069/128776113-b3f66229-783f-47cf-ab49-f0ccd8b7bee4.png)

In order for the player to be able to capture a codemon, he must have enough energy to start a challenge, requiring at least 20% energy. When starting a challenge, it is consequently reduced by 10% of the energy bar, if the player answers incorrectly the challenge is penalized with 10% more of his energy. All challenges provide the option to run away, which allows the player to exit the challenge without taking the penalty. One way to recover lost energy is with the logic gate challenges provided by character Plug. The challenge does not generate any punishment if the user makes a mistake, it consists of the trial and error model in setting the input values. When transmits 1 as an output will recharge 10% the notebook battery, being possible to continue recharging the energy bar or return to the game interface.

### Challenge - Question and Answer <a name = "challenge_2"></a>

![question_and_answer](https://user-images.githubusercontent.com/52884069/128776611-a6525aac-9c0b-49f4-8b1c-d63cabd3f941.png)

The player have to answer the questions of the variable type codemons in the Forest of Variables to enable their capture. The questions consist of the possibility of 3 answers, being up to the player to know which one is correct, if the chosen answer is incorrect, the game will provide feedback to the player. For variability and increased challenge, each variable type codemon will have 3 distinct questions, and the sequence of alternatives will be randomly provided.

### Challenge - Algorithm Analysis <a name = "challenge_3"></a>

![algorithm_analysis](https://user-images.githubusercontent.com/52884069/128777056-0d72e716-8e67-4b81-b73a-fd5d8e8fa2c9.png)

The player will have to perform is to understand the algorithms provided by codemons such as arithmetic operators, logical operators and control commands, being divided into 3 levels of difficulty. The challenge is to correctly use codemons and their values to result in the correct value of the provided function, being able to use variables that represent triangles, arithmetic operators that represent squares and logical operators that represent hexagons.
On the first level are algorithms modeled for arithmetic operator type codemons, which will challenge the player in Operators Mountain. The second level are algorithms modeled for logic operator type codemons, on Conditional Beach and the third level algorithms modeled for control flow on Control Desert.

### Boss - Bubble Sort <a name = "boss"></a>

![bubble_sort](https://user-images.githubusercontent.com/52884069/128777885-808ba50e-d525-4e72-8196-9e51d43f4f2a.png)

As a last challenge, the player interacts with the swaps of the bubble algorithm, being divided into two steps with the following sequence, the ordering of variables of type int and the ordering of variables of type string. The challenge is to present to the player 5 codemons inside bubbles with their values described, aiming to order the values presented in ascending order. In the last swap of each iteration, the bubble that held the last codemon is burst, so the player cannot swap again with that value. In total there will be 4 iterations of swaps, in the last iteration all codemons will have popped bubbles and a feedback will be presented to the player if the sequence was performed correctly.

## How to Create New Challenges <a name = "how_to_create_new_challenges"></a>
