# flex-jobs
A qb collection of 4 jobs
These all work in group and with a rep system

Its free so you can make it work for your own server on your own!

# What are the 4 jobs?
**Cleaning**

- Take a job (solo or group)
- Take the car from one of the spawns
- Go clean windows
- Higher rep level = more to do
  
<br>
<br>

**Delivery**
  
- Take a job (solo or group)
- Take the car from one of the spawns
- Go pickup boxes
- Go deliver them to npc
- Higher rep level = more to do
  
<br>
<br>

**electric**
  
- Take a job (solo or group)
- Take the car from one of the spawns
- Go fix some cabinets in the area on the map
- Higher rep level = more to do
  
<br>
<br>

**garbage**
  
- Take a job (solo or group)
- Take the car from one of the spawns
- Go grab trash from the bins
- Drop them in your trunk
- Higher rep level = more to do
- You will need a script to have an animation play whenever you get the trash item
<br>
<br>

# What do you need?
- [REP TABLET](https://github.com/Rep-Scripts/rep-tablet)
- [REP TALKNPC](https://github.com/BahnMiFPS/rep-talkNPC)
- QB-MENU
- [CW REP](https://github.com/Coffeelot/cw-rep)
- [INSIDE INTERACTION](https://inside-scripts.gitbook.io/documentation/paid-scripts/interaction) Or you can make it work with whatever interaction you want or even target if you know how!
- [FLEX CRAFTIN](https://github.com/Flexiboi/flex-crafting) or find the export and remove it
# CW REP CONFIG
```
cleaning = {
        label = 'Window cleaner',
        icon = 'fas fa-toilet-paper',
    },
    delivery = {
        label = 'Delivery',
        icon = 'fas fa-truck-fast',
    },
    electric = {
        label = 'Electric worker',
        icon = 'fa-solid fa-lightbulb',
    },
    garbage = {
        label = 'Garbage Man/Woman',
        icon = 'fa-solid fa-trash',
    },
```

# Items
```
garbagebag                   = { name = 'garbagebag', label = 'Garbagebag', weight = 10000, type = 'item', image = 'garbagebag.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '' },
bolt_cutter                  = { name = 'bolt_cutter', label = 'Cutters', weight = 100, type = 'item', image = 'bolt_cutter.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = '' },
box                          = { name = 'box', label = 'Box', weight = 10000, type = 'item', image = 'box.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '' },
```
