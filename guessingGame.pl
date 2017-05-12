%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ! author: Farris Khalid
%
% New rules were primarily created to further subcategorize certain
% animals/objects/plants. Many more if,then,else statements were created
% for either inside the body of the guess statement or outside of it to
% suite whether the type was of an animal,object,or plant. Only certain
% parameters were needed for each type.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
type(rabbit,animal).
type(dog,animal).
type(snake,animal).
type(fish,animal).
type(whale,animal).
type(raptor,animal).
type(dinosaur,animal).
type(lion,animal).
type(horse,animal).
type(chicken,animal).
type(shark,animal).
type(eagle,animal).
type(ant,animal).
type(starfish,animal).

type(carrot,plant).
type(orange,plant).
type(seaweed,plant).
type(coral,plant).
type(rose,plant).

type(computer,object).
type(car,object).
type(boat,object).
type(submarine,object).
type(cup,object).
type(pencil,object).

%!  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% animals were given additional clauses that described their
% anatomical structure, which gives prolog the ability to logically
% deduce certain animals from others

hasFourLegs(rabbit).
hasFourLegs(dog).
hasFourLegs(lion).
hasFourLegs(horse).

hasTwoLegs(eagle).
hasTwoLegs(chicken).
hasTwoLegs(raptor).

hasMoreThanFourLegs(ant).
hasMoreThanFourLegs(starfish).

hasNoLegs(shark).
hasNoLegs(whale).
hasNoLegs(fish).
hasNoLegs(snake).

%!  %%%%
% dinosaur is declared as unclassified because dinosaur is a broad
% description for an extinct species
%
unclassified(dinosaur).


alive(rabbit).
alive(dog).
alive(snake).
alive(fish).
alive(whale).
alive(lion).
alive(horse).
alive(chicken).
alive(shark).
alive(eagle).
alive(ant).
alive(starfish).

alive(carrot).
alive(orange).
alive(seaweed).
alive(coral).
alive(rose).

mammal(rabbit).
mammal(dog).
mammal(whale).
mammal(lion).
mammal(horse).

%!  %%%%%%
% These are the only true herbivores
% fishes can be herbivores,omnivores, and carnivores.
% The majority of animals are carnivores or omnivores, taking the
% inverse of herbivores should result in the same logic, no need to
% create clauses for carnivores or omnivores specifically.
%
herbivore(horse).
herbivore(rabbit).

water(fish).
water(whale).
water(starfish).
water(shark).
water(seaweed).
water(coral).
water(boat).
water(submarine).


pet(snake).
pet(dog).
pet(rabbit).
pet(fish).

fruit(orange).

edible(carrot).
edible(orange).
edible(seaweed).
edible(chicken).
edible(fish).

submersive(submarine).
utility(pencil).

hasElectricalComponents(computer).
hasElectricalComponents(boat).
hasElectricalComponents(submarine).
hasElectricalComponents(car).

usesFuel(car).
usesFuel(boat).
usesFuel(submarine).

%!  %%
% I apologize as this a very condense statement
%
guess(Thing) :- ask_type(Type),
    ((Type==animal;Type==plant)->ask_alive(Life);Life=dead),
    ((Life==alive)->(((Type==animal)->ask_environment(Environment),ask_legs(Legs),    %alive and animal,execute logically
                     ask_mammal(Class),ask_eatingHabit(PlantEater),ask_domesticated(Pet),ask_consumed(Edible))
                     ,animalReport(Thing,Type,Life,Environment,Class,Legs,Pet,PlantEater,Edible);
                     (((Type==plant)->ask_environment(Environment),ask_consumed(Edible),ask_foodType(FoodPyramid))
                     ,plantReport(Thing,Type,Life,Environment,Edible,FoodPyramid)));( %below this line, code assumes Life is dead and executes accordingly
                     (((Type==object)->ask_environment(Environment),ask_electric(Component),ask_for(Gas),
                     ask_underwater(Underwater),ask_utility(Sharp)),objectReport(Thing,Type,Life,Environment,Component,Gas,Underwater,Sharp));
                     ((Type==animal)->ask_extinct(Specimen),deadReptiles(Thing,Type,Life,Specimen)))).


%!  %%%
% A lot of user input was needed to properly distinguish to gather
% logical clues about specific types of plants,animals,and objects
%
ask_type(Type) :- writef("Is it an animal, plant, or object? \n"), read(Type).
ask_alive(Life) :- writef("Is it alive or dead? \n"), read(Life).
ask_extinct(Specimen) :- writef("Is it a generic classification or a specific classification of an animal (type generic or specific)? \n"), read(Specimen).
ask_environment(Environment) :- writef("Does it reside in water or land (type water or land)? \n"), read(Environment).
ask_underwater(Underwater) :- writef("Does it primarily submerge underwater AND float on the water when needed (type yes or no)? \n"), read(Underwater).
ask_legs(Legs) :- writef("How many legs does it have? zero, two, four, or more? \n"), read(Legs).
ask_eatingHabit(PlantEater) :- writef("Is it a herbivore (type yes or no)? \n"), read(PlantEater).
ask_consumed(Edible) :- writef("Is it commonly eatened by humans as a snack or type of food(type yes or no)? \n"), read(Edible).
ask_foodType(FoodPyramid) :- writef("Is it a fruit, vegetable, or neither? \n"), read(FoodPyramid).
ask_mammal(Class) :- writef("Is it a mammal (type yes or no)? \n"), read(Class).
ask_domesticated(Pet) :- writef("Is it a common household pet (type yes or no)? \n"), read(Pet).
ask_for(Gas) :- writef("Does it need fuel to run (yes or no)? \n"), read(Gas).
ask_electric(Component) :- writef("Does it contain electrical components(type yes or no)? \n"), read(Component).
ask_utility(Sharp) :- writef("Can it potentially be really sharp at the tip (type yes or no)? \n"), read(Sharp).


%!  %
% Individual reports condenses the amount of code needed inside of guess
% statement and is also case specific to the type

animalReport(Thing,Type,Life,Environment,Class,Legs,Pet,PlantEater,Edible) :- type(Thing,Type),
    ((Life==alive)->alive(Thing);not(alive(Thing))),
    ((Environment==water)->water(Thing);not(water(Thing))),
    ((Class==yes)->mammal(Thing);not(mammal(Thing))),
    ((PlantEater==yes)->herbivore(Thing);not(herbivore(Thing))),
    (((Legs==zero)->hasNoLegs(Thing));
    ((Legs==two)->hasTwoLegs(Thing));
    ((Legs==four)->hasFourLegs(Thing));
    ((Legs==more)->hasMoreThanFourLegs(Thing))),
    ((Edible==yes)->edible(Thing);not(edible(Thing))),
    ((Pet==yes)->pet(Thing);not(pet(Thing))).


plantReport(Thing,Type,Life,Environment,Edible,FoodPyramid) :- type(Thing,Type),
    ((Life==alive)->alive(Thing);not(alive(Thing))),
    ((Environment==water)->water(Thing);not(water(Thing))),
    ((FoodPyramid==fruit)->fruit(Thing);not(fruit(Thing))),
    ((Edible==yes)->edible(Thing);not(edible(Thing))).

objectReport(Thing,Type,Life,Environment,Component,Gas,Underwater,Sharp) :- type(Thing,Type),
    ((Life==alive)->alive(Thing);not(alive(Thing))),
    ((Environment==water)->water(Thing);not(water(Thing))),
    ((Component==yes)->hasElectricalComponents(Thing);not(hasElectricalComponents(Thing))),
    ((Gas==yes)->usesFuel(Thing);not(usesFuel(Thing))),
    ((Underwater==yes)->submersive(Thing);not(submersive(Thing))),
    ((Sharp==yes)->utility(Thing);not(utility(Thing))).

deadReptiles(Thing,Type,Life,Specimen) :- type(Thing,Type),
    ((Life==alive)->alive(Thing);not(alive(Thing))),
    ((Specimen==generic)->unclassified(Thing);hasTwoLegs(Thing)).












