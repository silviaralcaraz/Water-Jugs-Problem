# Water-Jugs-Problem

## Classic water jugs problem implemented with CLIPS

### About the problem

There are two water jugs- one of 8 liters and another of 6 liters, without marks that allows us to know how much water each contains. The objective is to get the 8L jug containing exactly 4L of water using different operations between the jugs.

### About CLIPS

CLIPS is a tool that provides a development environment for the production and execution of expert systems. 
For more information: http://www.clipsrules.net/

### CODE

- problemaJarras.clp: base program
- problemaJarras2.clp: It change base program removing all "final state checks" of the rules. Instead, the rules are reordered and "halt" instruction is used in "terminado" rule to force the end of the program in this point.
