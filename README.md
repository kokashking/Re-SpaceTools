# Re-Space Tools
## A collection of sound reactive visual tools



To my regret, there are some problems with the export of Processing sketches as standalone Java apps for MacOs (developer registration and co.). Therefore the best option for MacOs right now is to download the Processing Editor and start the programs from it. You will also need to install a couple of dependent libraries. But in Processing all that kind of stuff is really easy.



### Sound Analyzer

The first main element is the [sound analyzer](https://github.com/kokashking/Re-SpaceTools/tree/master/soundAnalyzer) that triggers OSC signals to other sketches or VJ-software.

import libs:

- osc
- minim
- controlP5
- ani



### Moving Lines 

This [moving lines](https://github.com/kokashking/Re-SpaceTools/tree/master/movingLines) sketch fits best for the highlighting of edges (object or corner edges of a room). You simply draw with the mouse over the edges. If you drag the mouse, drastically more points are created and therefore can cause slowdown. For the better performance on the weak hardware you should better draw by creating single points with a single mousepress. On Beat (Kick) signal from the SoundAnalyzer the lines are getting noisy :)  

import libs:

- osc
- ani
- geomerative

right now you can save only one drawing, but you can trick it by renaming


