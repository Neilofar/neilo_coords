# neilo_coords

A lightweight FiveM client-side script to place a tennis ball (or any prop) at the exact location you're looking at and copy its coordinates for `ox_target` or mapping purposes.  
Now optimized with **on-demand threads** and **ox_lib clipboard support**.

---

## Features

- Toggle tennis ball placement with `F6` or `/toggleball`
- Copy exact coordinates to clipboard with `F7` or `/copycoords`
- Uses **ox_lib** for clipboard and notifications
- Ball stays **static and collisionless** at the exact surface you look at
- Coordinates output as `vector3(x, y, z)` ready for `ox_target`
- Resource-efficient: the placement loop only runs when enabled

---

## Requirements

- [ox_lib](https://github.com/overextended/ox_lib) (make sure it is installed and started before this resource)

---

## Installation

1. Download or clone this repository into your `resources` folder (e.g., `resources/[tools]/neilo_coords`).
2. Ensure `ox_lib` is started in your `server.cfg` **before** this resource.
3. Add the following line to your `server.cfg`:

```cfg
ensure ox_lib
ensure neilo_coords
