# Re-Space Tools
## A collection of sound reactive visual tools



To my regret, there are some problems with the export of Processing sketches as standalone Java apps for MacOs (developer registration and co.). Therefore the best option right now is to download the Processing Editor and start the programs from it. You will also need to install a couple of dependent libraries. But in Processing all that kind of stuff is really easy.



### Sound Analyzer

The first main element is the [sound analyzer](https://github.com/kokashking/Re-SpaceTools/tree/master/soundAnalyzer) that triggers OSC signals to other sketches or VJ-software.

import libs:

- osc
- minim
- controlP5
- ani



### Kinetic Edges

This [Kinetic Edges](https://github.com/kokashking/Re-SpaceTools/tree/master/KineticEdges) sketch fits best for the highlighting of edges (objects, corner etc.) or simple drawings. On Beat (Kick) signal from the SoundAnalyzer the lines are getting noisy :)  

Controls:
 
 - right mouse button - new object
 - left mouse button - new point in the object

To switch the output channel change the variable DISPLAY_NR

```java
static final int DISPLAY_NR = 2; 
```

import libs:

- osc
- ani
- geomerative

right now you can save only one drawing, but you can trick it by renaming


