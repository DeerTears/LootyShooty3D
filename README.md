# LootyShooty3D

This game uses a gun model pack that uses a CC Attribution 4.0 license:

"Low Poly Weapons" (https://skfb.ly/6RwMM) by Gunnar Correa is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).

# Overview of Folders and Contents

I like writing documentation, and it's a good excuse to help me find stuff I've forgotten about that needs refactoring.

## Actors

A bit of a misnomer, does not always contain scripts that extend `Actor.gd`.

- Player
- Basic melee Enemy
Has an uncoupled statemachine to handle chasing the player, retreating, and dying. 
- Shockwave-type enemy
- Spawner
This spawner works with anything but it was designed for enemies. It can limit how many scenes it spawns by looking at its child count. Do not add children to this.
- Turret
Does not shoot yet, but it looks at the enemy, has animations, an "awake" radius, and a statemachine for handling combat.

`Components` carries things that go inside the actors as other saved scenes. This is an underutilized folder that's currently fighting for usefulness with `/weapons/components `.

`Enemies` is a folder that should hold every type of enemy, but things are just a bit messy right now.

## Addons

Currently using randomAudioStreamPlayer to play random sounds for enemies.

## Control

Contains all Control nodes and Control-exclusive resources.
- hud
- menus
- themes
- themes/fonts

## Environments

Lighting settings and proceduralsky resources saved into .tscn packages.

## Levels

Scenes that contain geometry and instances of objects. Hopefully every level can contain a LevelRootScript.gd that holds a reference to the Navigation mesh, so every enemy can recieve this information through a group call, or something.

## Materials

Initially made to work with a terrain addon but turns out my IGP doesn't like me running GLES3 Godot plugins, so it's completely unusable to me. May delete or rework this folder in the future.

- Actors
- Earth
- HotCoals
- Lava
- Stone

## Particles

- blood
- crosshairs

- images: outdated loot effect, will be removed eventually

- impacts: particles for the ShockwaveEnemy's area attack

- loot: light beams and other particles for dropped guns
- muzzleflash
- smoke: when enemies die, these particles are used to cause a puff of smoke before they're despawned. they also use this same particle to attack.

## Singletons

- gameinfo: Contains player position that enemies follow.
Likely to be changed in the future if I get navigationmesh working.
- settings: To carry audio/video quality settings across the menus and into the game.

## Sounds

- Enemies/Generic
- Guns

## Weapons

The motherload folder and kinda the focus of this project.

- abstract: This folder contains Superclasses, and the script for the new Resource-type "gun".
This folder contains Weapon.gd (used by WeaponSlot) and Gun.gd (extended by any instances of gun_resource in the code)

- classes: Contains now-depreciated code for each guntype.
This could be re-instated as .res files, to be a series of defaults for each guntype if we do a levelling system.

- components: Parts of guns such as the BulletEmitter, the world-spawned ItemBody that appears when you drop a gun, and some other stuff that is really hard to keep track of. :s

- interfaces: Handles input and passes signals around to produce raycasts and starts animations.

AnimationHandler, WeaponHandler, and WeaponSlot live here. 

- saved: Any "gun" .res files that make up the current, non-procedural lootpool. 

### meta.gd

This file contains a lot of important Enums and constants for the weapon and loot system. Meta.gd contains the following:

- The guntypes.
Pistol, shotgun, smg, sniper, rifle
- The size of each world-spawned collisionmesh for these guntypes. ItemBody.tscn uses this.
- The associated models for each guntype
The same mesh is used for world-spawned guns and the viewmodel. AnimationHandler and ItemBody both use this.
- The rarities of loot.
Bland, Good, Great, Awesome, Secret. (I think?)
- The colours of the loot trails for these rarities
- The loot pool (each `weapons/saved` resource is entered manually here)

# Things to Fix/Refactor

Okay, now that I've covered the contents of this project, I'd like to throw this list up as a sort of "todo" list when it comes to maintaining this project. I'd like to make sure that continuing to work on this isn't a pain.

## Actor Refactors

- `Enemy.gd` should be renamed to `EnemyMelee.gd`
- `Enemy.gd` should become an extends for all types of enemies.
There are too many differences between the Player and Enemies to try and share them in `Actor.gd` where all living things currently extend from.
- `actors/components` should carry GunDropper.tscn
The Actors contain the GunDropper, the weapons do not. It should not be in `/weapons/components`. I'm also not even convinced a `/components` subfolder is a good idea, but eh, this isn't Unity.
- The statemachine portion of enemies should be consolidated into the Enemy class or as its own class that enemies get a strategy-style reference to.

## Addon Fixes

The current randomAudioStreamPlayer actually doesn't allow for multichannel audio playback, and the randomization only happens when a sound has completed. This means gun sounds are cut off and not random.

This bug could either be fixed on the main randomAudioStreamPlayer, or we could try a new randomAudio node that instances multiple StreamPlayer nodes for multichannel, always-random audio.

## Particle Refactors

I'm planning on converting this project to GLES2, all Particles nodes will eventually be converted to CPUParticles for compatibility.

Blood could have an actual animated texture instead of random blood textures cycling in the particle.

Remove `/images`

## Sound Refactors

- rename .wav files in `enemies/generic`
- rename `enemies/generic` to `enemies/EnemyMelee`
- put closecall sounds into `sounds/closecall` instead of stuffing it in `sounds/guns`
- organize gun sounds by guntype

Now that I've experimented with where sounds are best used on my enemy classes (hurt, engage, dying, etc.) I should rename these sound effects appropriately, and make sure they match with the new names of enemy classes.

It's not required but I should give attribution to the samplepack that these sounds came from as well.

## Weapon Fixes/Refactors

These folder names made sense to me after reading that book about the Strategy Pattern, but I think I owe it to myself to rename all of these names to something more familiar and second-nature.

While we're thinking of new folder names:

- Get rid of `PistolCode.tscn & .gd`
- Move `GunDropper.tscn & .gd` into `actors/components/`
- Move `ItemBody.tscn & .gd` into `weapons/`?
- Check if `FirerateTimer.tscn` still needs to exist?
- Could we move the only-needed `BulletEmitter.tscn & .gd` and `ItemBody.tscsn & .gd` from `weapons/components` into `weapons/abstract`?

And then consider, instead of:

- abstract
- classes
- components
- interfaces
- saved
meta.gd

we'd have:

- BaseClasses
- DefaultStats
- Components
- Interfaces
- SavedGuns

| old | new |
| --- | --- |
| abstract | BaseClasses |
| classes | DefaultStats |
| components | Components |
| interfaces | Interfaces |
| saved | SavedGuns |

