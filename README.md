# How To Install And Set Up
For our game you need Processing, as well as the "Video", "Deep Vision" and "Sound" libraries. They can be installed by going through the Library Manager. Select “Add Library...” from the “Import Library...” submenu within the Sketch menu. Then search for each of the three libraries by name and install it. See this tutorial for more information. https://processing.org/tutorials/video

# Video
Script:
https://docs.google.com/document/d/1GE6tCZXUdcd7rGT5OHGj7A9yXX6AEfxOuVmjQmmqBSw/edit

# 1. Development Team
 <img src="https://i.imgur.com/lnxVVyN.jpeg" width="500" >

#### From left to right:

| Name    | Role          | Contributions |
|---------|---------------|---------------|
| `Mihir` | Dev Ops Lead  | Built out our tooling and served as our in-house GitHub expert, pioneering our crucial PR-based workflow to minimize Git related issues. |
| `Tom`   | Lead Designer | Created interactive iPad demos for potential levels and provided expert analysis during playtesting. |
| `Ali`   | Scrum Master  | Encouraged team communication and evaluated tasks for sprint prioritization, ensuring smooth workflow. |
| `Yi`    | Developer     | Contributed significantly to game development and shared expertise, enhancing the team's development skills. |
| `Kaiyan`| Developer     | Focused on dynamic tooltips in the tutorial level, improving player comprehension and engagement. |

# 2. Introduction 
### About Oiram:
<div style="text-align: center;">
  <img src="Assets_For_ReadMe/oriamforreport.gif" alt="Oiram Game" width="50">
</div>
<p>
Oiram is a single-player, platform-oriented game that integrates Super Mario-style missions while also incorporating a time-travel feature. Our spaceman must navigate obstacles such as explosives and determine the most efficient path through the game. Drawing inspiration from Nolan's Tenet, the Tardis object allows for time retracement, creating intricately designed, problem-oriented missions.
</p>

### How to Play:
<div style="display: flex; align-items: center; justify-content: center;">
  <p style="margin-right: 20px;">
    <b><i>Use the arrow keys or WASD to direct your spaceman: D/A for lateral movement, W or Up to ascend.</i></b>
  </p>
  <img src="Assets_For_ReadMe/wasd.jpg" alt="WASD Controls">
</div>

**The Mission:**
Navigate levels, dodge obstacles, and interact with objects like gates, switches, and the Tardis to activate mechanisms and portals.

<div style="display: flex; justify-content: space-around; text-align: center;">
  <div style="padding: 10px;">
    <h3>Gates</h3>
    <img src="Game/assets/Static/Door/door1.png" alt="Gates" style="width: auto; height: 100px;">
    <p><i>Act as barriers that can be opened or closed to control player movement.</i></p>
  </div>
  <div style="padding: 10px;">
    <h3>Switches</h3>
    <img src="Game/assets/Static/Button/button1.gif" alt="Switches" style="width: auto; height: 100px;">
    <p><i>Toggle to control various game mechanisms.</i></p>
  </div>
  <div style="padding: 10px;">
    <h3>Tardis</h3>
    <img src="Game/assets/Static/TimeMachine/time1.png" alt="Tardis" style="width: auto; height: 100px;">
    <p><i>Teleportation device that changes the state of the game by altering timelines.</i></p>
  </div>
</div>

**Obstructions:**
Avoid explosives to ensure survival.

**How to Win:**
Master gravity and momentum to navigate past challenges and utilize your past actions for success.

### Oiram Game Inspiration:
Oiram's narrative complexity is inspired by Tenet, the timeless platforming of Super Mario, and the temporal challenges of Braid, offering a unique gameplay experience.

### Why Play Oiram?
Oiram stands out by combining classic platforming with innovative time manipulation and prioritizing accessibility with features tailored to a range of player needs.

# 3. Requirements (15% ~750 words) (Mihir)

- [ ] **Use case diagram.**
    - Include use case diagrams to represent the system functionalities.
- [ ] **User Stories.**
    - List down the user stories.
- [ ] **Early stages design.**
    - Discuss the initial design stages of your game.
- [ ] **Ideation processing.**
    - Explain how the ideation process was conducted.
- [ ] **Reflections for future development.**
    - Share any reflections or insights that could influence future development.

# 4. Design (15% ~750 words) (Kai/Mihir/Tom)

- [ ] **System architecture (Kai/Mihir).**
    - Describe the system architecture planned and used.
- [ ] **Class diagrams (Mihir).**
    - Provide class diagrams to represent the static structure of the system.
- [ ] **Behavioural diagrams (Mihir - might need help on this).**
    - Include behavioural diagrams to showcase the dynamic aspects of the system.

# 5. Implementation

Before starting any of our challenges, we needed to create a basic platformer. First, we created a `GameObject` from which all physical items in the game inherit, as well as a `Player` (which includes specific player behaviour) and a `PlayerController` (which includes the logic for how the player is controlled).

While not one of our official challenges, we found that programming collisions and basic movement were initially quite tricky. For example, our initial approach to jumping caused an issue where users could jump infinitely by holding down the button. Our eventual implementation involved a variable within the `Player` set when they were on the ground. We also included velocity and acceleration variables. For collisions, initially, we had an approach involving an ENUM, several for loops, and several if statements. This approach was verbose and unreliable (occasionally players would fall through the floor!) Our final approach was much simpler and involved using the height and width of the game object, with the conditional collisions logic (for example, pressing the button opens the door) stored inside the `interactDynamicItems` method.

### Challenges

1. **Implementing the reverse time mechanic**

   This was by far the hardest task. We wanted to store not just the locations of the previous player, but also have that player interact with the environment (for example, opening doors.) We created a `PastPlayer` class containing a Linked List of the player's previous locations. We used a frame variable to keep track of time within the object.

   The bomb was even more complex. We created explode and unexplode animations, and we also overrode the `checkCollisions` function to have a broader blast radius.

2. **Level Design and balance**

   We realized early on that we wanted to build the level map in an extensible way, so the `Map` class contains a function that reads a text file representing the map. This allowed maximal flexibility whilst developing our maps, especially as core game mechanics like jump height were being changed. We opted not to use procedural generation, as we felt control was important given the puzzle-solving nature of the game. This is because we found that many decisions, like where a button is located, can profoundly affect a player's ability to complete a particular puzzle.
   
    <img src="https://i.imgur.com/0kD1yRU.png" width="500" >
    <img src="https://i.imgur.com/Suklhby.png" width="500" >
    
   This level designer was very helpful when in playtesting. For example, one user found the jump in the tutorial level too challenging to complete, but with a few keystrokes, we were able to change it and immediately gather feedback that the same user found it easier.
   
4. **Accessibility**

   Accessibility was a really important aspect for us, as we have team members with personal experience of their disability locking them out of games. So, we built a way to play the game without keyboard input. Players can lean left and right and make a noise to jump. This was implemented through a machine vision and audio library. Input from the webcam is taken and if the user's head is detected on one side of the screen, the character moves that way. The main challenge of this was efficiency, the first library we used was too slow, as it was doing pose detection. We switched to just detecting the head position, and the game worked. Audio input was taken using Processing’s sound library, and if it spikes over a certain level a jump signal is sent to the player character.

   Whilst the `AlternativeController` class contains about 100 lines of code, it required us to add only a few lines to the rest of the game (from the perspective of the player controller, it is just a few more variables that it handles in the same way as a button press.) This shows that many games that use simple keyboard inputs could have accessibility modes like this one.

   In playtesting, some non-disabled players preferred controlling the character this way. This is known as the curb-cut effect; a feature originally built for accessibility can be useful for other players.

# 6. Evaluation (15% ~750 words) (Tom)

- [ ] **One qualitative evaluation (your choice).**
    - Conduct and describe a qualitative evaluation of the game.
- [ ] **One quantitative evaluation (of your choice).**
    - Conduct and describe a quantitative evaluation of the game.
- [ ] **Description of how code was tested.**
    - Explain the methods used to test the code.

# 7. Process (15% ~750 words) - (Ali)

## Collaboration

Our first few meetings were conducted in person. This allowed maximal flexibility as we discussed various design ideas and got to know each other. In fact, our first meeting ever was at a restaurant, and we focused exclusively on getting to know each other and our gaming histories. We connected in person at the end of each Monday morning lab, and divided up that week’s tasks using a variant of planning poker. (We noticed that development tasks would take different people different amounts of time, so we attempted to give harder tasks to faster coders even out how much time people spent on the game.)

<img src="https://i.imgur.com/eQKRT9U.jpeg" width="250">

Over the holidays, we switched to doing scrum-style stand-up meetings (at least 3 times a week) over Microsoft Teams. This proved very effective. In contrast to our in-person meetings, which could be very long, these tended to be shorter and more agenda-driven - we would focus on what work needed to be done and by whom. This allowed people to work asynchronously in a way that seemed to reduce stress whilst still having frequent check-in points to ask for help or to pair program.

Early on, we had to decide which game to build. To do this, we used a [ranked preferences voting tool](https://www.rankedchoices.com/), which allowed each of us to express our preferences anonymously. 

Analyzing our process, we noticed an interesting trend in the burndown report. For our three holiday sprints we set deadlines for the end of the week. This led to a few "heroic efforts" as people implemented their work before the deadline. (Note that there is some reporting bias in this, as we credited work done over the weekend to the previous Friday.) We mitigated this slightly in the final week of the holiday sprints, where we further decomposed the tasks (average story points per task went from 7 to 2.)
<img src="https://i.imgur.com/6JbR5n4.png" width="500">


## Tools and Techniques

We experimented with a variety of different tools during the development.

For our meetings, we used a Google doc in reverse chronological order (a stack, not a queue!) This allowed us a space to add text, images, and diagrams flexibly and ensured that the most useful content was at our fingertips.

<img src="https://i.imgur.com/GlRhWhe.png" width="250">

We initially used the Kanban board built into GitHub. However, as development became more complicated, we noticed that people were misunderstanding the requirements of the task, leading to wasted development time. We decided to switch to the running Google doc that we used for meetings as it allowed us to use a variety of media (text, images of paper prototypes etc) to describe the task requirements. This was significantly more flexible, and our PR workflow meant it was still very easy to track what work had been done for analysis purposes. It also reduced the number of places people needed to look for information - everything was centralized in one document.

<img src="https://i.imgur.com/cdjpaHN.png" width="250">

We used Pull Requests extensively. Our process involved creating a PR and having another team member review it before it could be merged in. This helped enforce good coding standards and reduced the likelihood of committing buggy code.

WhatsApp was our primary communication method, which we used to coordinate meetings, ask for feedback on PRs, and ask for help.

<img src="https://i.imgur.com/FUcBUNE.png" width="250">

Pair programming was something that we used frequently. Since Yi had previous experience with game development, pair programming with him allowed us all to get up to speed with some of the techniques that we would later rely on. He would act as the tactician and we would be the helm. Early on we did a variant of pair programming where we used the VS Code plugin Live Share to collaborate on the same code in real-time. This allowed for very fast coding development early on and meant our meetings were more “working sessions” than meetings.

## Agile Discussion

We adopted an agile methodology, allowing us to build the game slowly based on user feedback. This was very effective, especially since many of us had little knowledge of game development. However, we did encounter some issues. Early on, the pressure to get a feature "working" overrode the desire to create long-term, maintainable code. You can see this with the collision detections, the initial code had to be rewritten to be extensible. We addressed this by implementing a workflow based on pull requests and code reviews. Inspired by industry best practices, code reviews allowed each of us to uplevel our skills and write significantly better code as measured by cyclomatic complexity (which decreased by 79% between the 3rd week of the project and the 7th.)


# 8. Conclusion (10% ~500 words) (Tom)

- [ ] **Reflect on project as a whole.**
    - Provide an overview reflection of the entire project.
- [ ] **Lessons learned.**
    - Share key lessons learned throughout the project.
- [ ] **Reflect on challenges.**
    - Reflect on the challenges faced and how they were overcome.
- [ ] **Future work.**
    - Discuss any plans or ideas for future work on the project.
