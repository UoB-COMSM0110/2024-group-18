## Creating Git Feature Tutorial 

### Step 1: Pull Latest Changes
Switch to main branch first and pull latest changes:
```bash
git checkout main
git pull origin main
```

### Step 2: Create a new feature branch 
Make feature branch in similar format for now - note that this command creates the branch AND switches to the new branch created!
```bash
git checkout -b feature/yourname/NameWork
```

### Step 3: Congrats! Branch created - now work on your feature branch!
Make these two commands your best friend:
```bash
#make sure that you are in *feature/yourname/yournameWork
git branch 
```

```bash
#gives you a description if you are of if you have changes.
git status 
#"Clean Working branch" <- a beautiful command you want to look out for (teller for all in-sync)
```

### Step 4: Everytime you make a change... 
Make a change, then run these commands:
```bash
# Make sure you are in your branch first!
git checkout feature/name/nameWork
# Make changes to files
git add .
git commit -m "Any meaningful message"
# Push to your branch!!
git push origin feature/name/nameWork
#Check worked (sometimes doesnt!)
git status
#Look out for that beautiful message
```
### Step 5: Just get used to this first! Will discuss pull request next meeting! 
//Test