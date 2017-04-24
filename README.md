# Re-Space Tools
## A collection of sound reactive visual tools



The best option for right now is to download the [Processing Editor](https://processing.org/download/) and start the programs from it. You will also need to install a couple of dependent libraries. But in Processing all that kind of stuff is really easy... check the tutorial video above.

import libs:

- osc
- minim
- controlP5
- ani
- geomerative


### Sound Analyzer

The first main element is the [sound analyzer](https://github.com/kokashking/Re-SpaceTools/tree/master/soundAnalyzer) that triggers OSC signals to other sketches or VJ-software.



### Kinetic Edges

This [Kinetic Edges](https://github.com/kokashking/Re-SpaceTools/tree/master/KineticEdges) sketch fits best for the highlighting of edges (objects, corner etc.) or simple drawings. On Beat (Kick) signal from the SoundAnalyzer the lines are getting noisy :)  

Controls:
 
 - right mouse button - new object
 - left mouse button - new point in the object

To switch the output channel and fullscreen mode change the following lines in the KineticEdges tab: 

```java
static final int DISPLAY_NR = 2; 
boolean fullscreen = false;
```


right now you can save only one drawing, but you can trick it by renaming



## Tutorial Video

[![Tutorial](https://img.youtube.com/vi/W8wTx6D30so/0.jpg)](https://www.youtube.com/watch?v=W8wTx6D30so)

## Example

[![Tutorial](https://img.youtube.com/vi/EN5cbokLIaw/0.jpg)](https://www.youtube.com/watch?v=EN5cbokLIaw)

## License

Re-SpaceTools are distributed under the [MIT License](https://en.wikipedia.org/wiki/MIT_License). See the [LICENSE](https://github.com/kokashking/Re-SpaceTools/blob/master/license.md) file for further details.
