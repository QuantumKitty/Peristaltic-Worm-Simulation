INSTRUCTIONS

Run "Worm.m" for the simulation.

Parameters, plots and control methods can be custmized in "Worm.m".

To create a new motion-data plot, first create the figure and set the properties in "Worm.m",
then call the figure handle in "Move.m" and plot the motion-data.

Actuator speed is set in "Speed.m".
Make sure the speed and operating time together will not over-turn the cable,
causing simulation crash (robot breakage).

"Anchor.m" determines which direction and which segments to move.
Frictions are not directly considered and assumptions have been made in this function.

To read data in the command window regarding to the model-state after the simulation,
e.g. coordinates of the 1st-Seg's 2nd-Ring, type "State{2}(1,2,:)" instead of "Center(1,2,:)".
"State" is defined in "Worm.m".
