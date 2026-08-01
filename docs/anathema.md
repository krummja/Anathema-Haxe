# Anathema

## Features

- [ ] systems/physics
  - [x] light/darkness
  - [ ] water physics
  - [ ] fire physics
  - [ ] rope physics?
  - [ ] destruction system
  - [ ] temperature
  - [ ] weather
- [ ] construction
  - [ ] building structures
  - [ ] placing furniture
  - [ ] camps
- [ ] survival/camping
  - [ ] sleeping
  - [ ] making fire
  - [ ] cooking
  - [ ] foraging
  - [ ] hunting
  - [ ] tracking
- [ ] magic

## Mechanics

Following the Storytelling system, game mechanics use a count of 10-sided dice (d10). Attributes and skills are leveled up, with each level adding a single d10 to the task resolution dice pool.

As an example, scaling a wall requires Physical Power (strength) as well as the Athletics skill. If a player has a strength of 3 and Athletics skill of 4, the task is provided 7d10 to the dice pool.

In the Storytelling system, rolls are made against a DC, typically 8. Success is measured by the number of dice that roll at or above the DC. Harder tasks raise the DC (e.g. 9), easier tasks lower it (e.g. 7); the pool size stays fixed and only the target number moves.

Modifiers are flat additions or subtractions to or from the dice pool, coming from equipment, terrain, conditions, wounds, etc.

If a dice pool has zero dice, the task is given a single "chip" d10 to roll. Success occurs only on a 10. A result of 1 is a Critical Failure and occurs with negative consequences.

If a dice pool has one or more dice and rolls **zero successes with at least one natural 1**, that is also a Critical Failure (a "botch"). A pool with any successes can never botch, no matter how many 1s are also rolled — so botch odds shrink as a character gets more competent at a task, rather than staying constant.

### Attributes

|            | PHYSICAL  | MENTAL    | SOCIAL    |
| ---------- | --------- | --------- | --------- |
| POWER      | vigor     | intellect | gravitas  |
| FINESSE    | dexterity | acumen    | cunning   |
| RESILIENCE | endurance | resolve   | composure |

### Skills

Skills exist, and are broad areas of competence (Storytelling-style) rather than narrow trained techniques. Each skill pairs with one attribute category (Physical/Mental/Social) and adds its rating in dice to any roll for an action that skill governs; a roll with a relevant skill but rating 0 still uses the governing attribute alone (untrained is possible, just worse).

Skills are bought with XP, from the same pool that buys attribute dots, rather than improving passively through use — this keeps advancement a deliberate build choice, in line with "classes" below.

#### Physical

| Skill     | Governs                                             |
| --------- | --------------------------------------------------- |
| Athletics | Climbing, jumping, swimming, forcing doors, running |
| Brawling  | Unarmed strikes, grappling, improvised weapons      |
| Larceny   | Lockpicking, trap disarming, pickpocketing          |
| Stealth   | Sneaking, hiding, avoiding detection                |
| Survival  | Foraging, tracking, fire-making, weathering hazards |
| Weaponry  | Melee and ranged weapon attacks                     |

#### Mental

| Skill         | Governs                                           |
| ------------- | ------------------------------------------------- |
| Academics     | Lore recall, deciphering texts, history/geography |
| Crafting      | Building, repairing, cooking, alchemy             |
| Investigation | Searching, spotting clues, deduction              |
| Medicine      | First aid, diagnosing ailments, surgery           |
| Politics      | Faction knowledge, bureaucracy, law               |
| Science       | Identifying tech/artifacts, experimentation       |

#### Social

| Skill         | Governs                                       |
| ------------- | --------------------------------------------- |
| Animal Ken    | Taming, calming, or reading creatures         |
| Empathy       | Reading intentions and emotional states       |
| Expression    | Performance, storytelling, persuasive writing |
| Intimidation  | Coercion, threats, standing your ground       |
| Persuasion    | Honest argument, negotiation, bargaining      |
| Socialization | Etiquette, first impressions, fitting in      |
| Subterfuge    | Lying, disguise, misdirection                 |

### Sorcery

Magic is organized into three schools, one per attribute column, so casting reuses the same 3x3 grid instead of introducing new stats:

- **Physical (Blood) sorcery** — vigor/dexterity/endurance
- **Mental (Arcane) sorcery** — intellect/acumen/resolve
- **Social (Charm) sorcery** — gravitas/cunning/composure

Casting a spell rolls the school's **Power** attribute (the raw ability to push effect into the world) plus a dedicated sorcery skill for that school, same as any other action. The school's **Resilience** attribute governs resisting backlash/strain from casting (a botch on a cast should hurt the caster, not just fizzle). **Finesse** governs precision effects (targeting, subtlety, minimizing collateral effect) as a modifier or alternate roll for control-oriented spells. Each school therefore needs one sorcery skill (e.g. Blood Sorcery, Arcane Sorcery, Charm Sorcery) alongside the mundane skill lists above.

### Castings

Sorceries are everyday works of magic that a sorcerer can cast using their individual will and mana.

Magic also comes in two other forms. **Castings** are ad-hoc rituals that require a casting focus and one or more sacrificial components to produce. Failed castings can have determinal effects on the caster or their surroundings.

**Great Castings** require a dedicated shrine to produce. Additionally, the casting focus must be an anathema (an artifact?) and much greater sacrificial components. Failure of great castings can outright kill the caster and/or completely obliterate portions of the world.

#### Casting Mechanics

I want to play around with the idea of using a simple form of formal logic ranging over the semantic tags of the spell components. A casting requires a shape (a literal 2D layout the player must complete) which encodes a predicate, a subject, and quantifiers that together direct what the casting does.

### Classes

Classes are fairly dynamic and open-ended. A "class" is not a hard-locked progression track — it's just a named starting package of attribute dots, skill dots, and abilities that a player can pick as a shortcut, and can freely deviate from as XP is spent. Any build is reachable by any starting class given enough XP; classes only bias *where you start*, not where you can end up.

### Traits (Positive/Negative)

I do want to have a system of boons/banes that give characters unique combinations of features.
