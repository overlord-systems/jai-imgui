# jai-imgui

Jai bindings for docking branch of [Dear ImGui v1.91.9b](https://github.com/ocornut/imgui/releases/tag/v1.91.9b).

These bindings are generated using Bindings Generator, except for a few basic things (e.g. Vec2) where we use Jai types instead.

To generate bindings: `jai generate.jai`.
To compile ImGui static and dynamic libraries, and then generate bindings: `jai generate.jai - -compile`.

## Backends

We support using `generate.jai` to generate static libraries of ImGui backends. These libraries include *only* the backend, and so to use them your program must link to both the main Dear ImGui library and then, if you want to use a backend, to also link and use the backend. Each backend also has its own bindings file.

Currently the only supported backend is SDL3+SDL_GPU3, but it should be relatively easy to add more (check `generate.jai`.

To compile a backend and then generate ImGui bindings and backend bindings: `jai generate.jai - -backend_sdl3_gpu3`.

Supported backends:

- `backend_sdl3_gpu3`
