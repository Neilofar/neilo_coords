# neilo_coords

A simple FiveM client-side script to place a tennis ball (or any prop) at the exact location you're looking at and copy its coordinates for `ox_target` or other mapping purposes.

---

## Features

- Toggle the tennis ball placement with `/toggleball`
- Copy the exact coordinates to your clipboard with `/copycoords`
- Ball stays **static and collisionless**, always at the exact surface your camera points at
- Outputs coordinates in `vector3(x, y, z)` format ready for `ox_target`
- Uses `ox_lib` for notifications, clipboard, and commands
- Multi-language support (English, Arabic, German)
- Lightweight and easy to configure

---

## Requirements
- [ox_lib](https://github.com/overextended/ox_lib)

---

## Installation

1. Place the folder in your `resources` directory, e.g., `neilo_coords`.
2. Add the following line to your `server.cfg`:

```cfg
ensure neilo_coords