# A Framer module for creating magnifying carousel

![framerdemo](https://media.giphy.com/media/l0CLUutXuDj5BMo92/giphy.gif)

[Try the demo here](https://framer.cloud/iGTCW)

## Installation

1. Create a new project in Framer Studio
1. Navigate to the /modules folder and put Carousel.coffee into it.
1. Add the following line to your Framer project:

```coffee
Carousel = require 'Carousel'
```
    
## Usage
Push your layers into an array, and pass this array to the carousel. For example: 

```coffee
Carousel = require 'Carousel'

layers = [0..9].map (i) ->
    new Layer
        backgroundColor: "hsl(#{i*20}, 70%, 50%)"
        borderRadius: 4	

carousel = new Carousel layers
```
Additionally you can customize the parameters:

```coffee
carousel = new Carousel layers,
    backgroundColor: '#f8f8f8'
    x: Align.center
    y: 100
    width: Screen.width
    height: 200
    layerWidth: 100                 # width of the layers in carousel, align this to your layers
    layerHeight: 100                # height of the layers in carousel, align this to your layers
    layerY: Align.center            # y position of the layers in carousel
    scaleWidth: Screen.width / 4    # width of the area where scaling will take place, relative to the middle point. Greater the value, smoother the scaling 
    scaleRatio: 0.4                 # scale ratio for the layers. Preferably less than 1
    scaleOriginY: 0.5               # y origin for scale. 0.5 for scaling from the center
    space: 0                        # contributes to the space between layers
    scrollSpeed: 1                  # scroll speed for carousel
    innerThreshold: 100             # width of the area where an increasing x offset is given to layers, relative to the middle point. Tweak this value with caution
    outerThreshold: 200             # width of the area where x offset is given to layers, relative to the middle point. Tweak this value with caution
    offset: 50                      # the maximum x offset when layers are being scaled. Tweak this value with caution
    fadeOutRatio: 1.5               # contributes to the final space between scaled-down layers. Tweak this value with caution
```
