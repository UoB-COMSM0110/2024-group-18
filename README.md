# How To Install And Set Up
For our game you need Processing, as well as the "Video", "Deep Vision" and "Sound" libraries. They can be installed by going through the Library Manager. Select “Add Library...” from the “Import Library...” submenu within the Sketch menu. Then search for each of the three libraries by name and install it. See this tutorial for more information. https://processing.org/tutorials/video

# 1. Development Team

- [ ] **Who’s in your team + team photo.**
    - Include the names and roles of team members.
  
 <img src="https://i.imgur.com/lnxVVyN.jpeg" width="500" >

- [ ] **Team breakdown + team role (import from prev branch).**
    - Detail each team member's role.

# 2. Introduction (5% ~250 words) (Mihir)

- [ ] **Describe your game, what is based on, what makes it novel?**
    - Briefly introduce the game.
- [ ] **Describe Game.**
    - Provide a detailed description of the game mechanics and objectives.
- [ ] **Based on (Braid, Tenet…).**
    - Explain the inspiration behind the game.
- [ ] **Stand out.**
    - Highlight what makes your game unique.

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

Before we could start any of our challenges, we needed to create a basic platformer. First, we created a `GameObject` which all physical items in the game inherit from, as well as a `Player` (which includes specific player beheviour) and `PlayerController` (which included the logic for how the player is controlled.)

While not one of our official challenges, we found that programming collisions and basic movement was initially quite tricky. For example, with jumping, we had problems with an approach where users could jump infinitely by holding down the button. Our eventual implementation involved a variable within the player that was set when they were on the ground. We also included velocity and acceleration variables. For collisions, initially we had an approach involving an ENUM, several for loops, and several if statements. This approach was verbose and unreliable (occasionally players would fall through the floor!) Our final approach was much simpler and involved using the height and width of the game object, with the conditional collisions logic (for example, that pressing a button opens a store) stored inside the `interactDynamicItems` method.

### Challenges

1. **Implementing the reverse time mechanic**

   This was by far the hardest task. We wanted to store not just the locations of the previous player, but also have that player interact with the environment (for example, opening doors.) We created a `PastPlayer` class, which contains a Linked List of their previous locations. We used a frame variable to keep track of time within the object.

   The bomb was even more complex. We created explode and unexplode animations, and we also overrode the `checkCollisions` function to have a broader blast radius.

2. **Level Design and balance**

   For the level map, we realized early on that we wanted to build it in an extensible way, so the `Map` class contains a function which reads a text file which represents the map. This allowed maximal flexibility whilst developing our maps, especially as core game mechanics like jump height were being changed. We opted to not use procedural generation, as we felt control was important given the puzzle-solving nature of the game. This is because we found that many decisions, like where a button is located, can have a profound effect on a players ability to complete a particular puzzle.
   
    <img src="https://i.imgur.com/0kD1yRU.png" width="500" >
    <img src="https://i.imgur.com/Suklhby.png" width="500" >
    
   This level designer was very helpful when in playtesting. For example, one user found the jump in the tutorial level too challenging to complete, but with a few keystrokes we were able to change it and immediately gather feedback that the same user found it easier.
   
4. **Accessibility**

   Accessibility was a really important aspect for us, as we have team members with personal experience of their disability locking them out of games. So we built a way to play the game with no keyboard input at all. Players can lean left and right and make a noise to jump. This was implemented through a machine vision and audio library. Input from the webcam is taken and if the user's head is detected on one side of the screen, the character moves that way. The main challenge of this was efficiency, the first library we used was too slow, as it was doing pose detection. We switched to just detecting the head position, and the game worked. Audio input was taken using Processing’s sound library, and if it spikes over a certain level a jump signal is sent to the player character.

   Whilst the `AlternativeController` class contains about 100 lines of code, it required us to add only a few lines to the rest of the game (from the perspective of the player controller, it is just a few more variables that it handles in the exact same way as a button press.) This shows that many games that use simple keyboard inputs could have accessibility modes like this one.

   In playtesting, some non-disabled players actually preferred controlling the character this way. This is known as the curb-cut effect; a feature originally built for accessibility can be useful for other players.

# 6. Evaluation (15% ~750 words) (Tom)

- [ ] **One qualitative evaluation (your choice).**
    - Conduct and describe a qualitative evaluation of the game.
- [ ] **One quantitative evaluation (of your choice).**
    - Conduct and describe a quantitative evaluation of the game.
- [ ] **Description of how code was tested.**
    - Explain the methods used for testing the code.

# 7. Process (15% ~750 words) - (Ali)

 Teamwork.
###Roles###
    We never defined official roles, but looking back, some specialities appeared. 
    - Yi, developer who built out large parts of the game, whilst also acting as a subject matter expert, teaching all of us how to be better game developers.
    - Kaiyan, developer, especially focused on the dynamic tooltips in the tutorial level that resulted in far more players being able to understand the game.
    - Ali, scrum master, tended to be the one to encourage communication through team members through meetings and write requirements and tasks in the Google doc. 
    - Tom, lead designer, regularly created interactive iPad demos of what a level could look like and provided expert analysis when playtesting levels.
    - Mihir, Dev Ops lead, built out our tooling and was our in-house GitHub expert, providing support and pioneering our crucial PR based workflow that meant we had few git related issues!
    
###Collaboration###
    Our first few meetings were conducted in person. This allowed maximal flexibility as we discussed various design ideas and got to know each other. In fact, our first meeting ever was done at a restaurant, and focused exclusively on getting to know each other and our gaming histories. We connected in person at the end of each Monday morning lab, and divided up that week’s tasks using a variant of planning poker. (We noticed that development tasks would take different people different amounts of time, so we attempted to give harder tasks to faster coders even out how much time people spent on the game.)
        <img src="https://i.imgur.com/eQKRT9U.jpeg" width="500" >
    Over the holidays we switched to doing scrum style stand up meetings (at least 3 times a week) over Microsoft Teams. This proved very effective. In contrast to our in person meetings that could be very long, these tended to be shorter, and more agenda driven - we would focus on what work needed to be done and by whom. This allowed people to work asynchronously in a way that seemed to reduce stress, whilst still having frequent check in points to ask for help or to pair program.
    Early on we had to make a decision of which game to build. To do this we used a ranked preferences voting tool https://www.rankedchoices.com/, allowing each of us to anonymously express our preferences. 
    
##Tools and Techniques##
    For our meetings we used a google doc in reverse chronological order (a stack, not a queue!) This allowed us a space to add text, images and diagrams flexibly and ensured that the most useful content was at our fingertips.
        <img src="https://i.imgur.com/GlRhWhe.png" width="500" >
    We experimented with a variety of different tools during the development. We initially used the Kanban board built into GitHub, however as development became more complicated we noticed that people were misunderstanding the requirements of the task leading to wasted development time. We decided to switch to the running Google doc that we used for meetings as it allowed us to use a variety of media (text, images of paper prototypes etc) to describe the task requirements. This was significantly more flexible, and our PR workflow meant that it was still very easy to track what work had been done. It also reduced the number of places people needed to look for information - everything was centralized in one document.
            <img src="https://i.imgur.com/cdjpaHN.png" width="500" >
    We used Pull Requests extensively. Our process involved creating a PR and having another team member review it before it could be merged in. This helped enforce good coding standards and reduced the likelihood of committing buggy code. 
    WhatsApp was our primary communications method, which we used to coordinate meetings, ask for feedback on PRs and ask for help. 
                <img src="https://i.imgur.com/FUcBUNE.png" width="500" >
    Pair programming was something that we used frequently. Since Yi had previous experience with game development, pair programming with him allowed us all to get up to speed with some of the techniques that we would later rely on. He would act as the tactician and we would be the helm. Early on we did a variant of pair programming where we used the VS Code plugin Live Share to be able to collaborate on the same code in real time. This was allowed for very fast coding development early on and meant our meetings were more “working sessions” than meetings.
    
##Agile Discussion##
    We adopted an agile methodology, allowing us to build the game slowly based on user feedback. In general, this was very effective, especially since many of us had little knowledge of game development. However, we did encounter some issues. Early on, the pressure to get a feature "working" overrode the desire to create long-term, maintainable code. You can see this with the collision detections—the initial code had to be rewritten so that it was extensible. We addressed this through implementing a workflow based on pull requests and code reviews. Inspired by industry best practices, code reviews allowed each of us to see the code of others and suggest improvements before it was implemented, however, it did slow down feature development initially.


# 8. Conclusion (10% ~500 words) (Tom)

- [ ] **Reflect on project as a whole.**
    - Provide an overview reflection of the entire project.
- [ ] **Lessons learned.**
    - Share key lessons learned throughout the project.
- [ ] **Reflect on challenges.**
    - Reflect on the challenges faced and how they were overcome.
- [ ] **Future work.**
    - Discuss any plans or ideas for future work on the project.
