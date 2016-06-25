# white

A program for controlling an external projector during  psychophysical experiments with SLO imaging.

## Installation

## General usage

## Parameters

## Keyboard Keys

### Saving, exiting
* ``` save current set of parameters. this will overwrite the parameter file associated with the active subject.
* `escape` quit the program and save the last set of parameters.

### Turning features on and off
* `1` turn on/off grid lines
* `2` turn on/off background square. this square is typically used as a bleaching field or background and overlaid on the SLO raster.
* `5` turn on/off a second square. this square is used for color matching experiments.
* `0` turn on/off a fundus image. this switch requires a file to be loaded in the parameters gui.

### Moving/scaling objects
* `w, a, s, z` move the fixation dot.
* `t, f, g, v` move the background or matching square (if the later is active).
* `u, h, j, n` change the size of the background and matching squares.
* `p, ;, ', .` move the fundus image.
* `-, =` scale the fundus image.
* `[, ]` rotate the fundus image.

### Controling the luminance and chromaticity of the background.
* `enter, shift` increase and decrease the background or matching square.
* `arrow keys` change the chromaticity of the background or matching square.

### Step sizes
* `control` toggle between large and fine steps across all of the scaling/movement keys.

## Fundus image projection

## Calibrate grid

Run `calibrate_raster_pix_deg.m`

