# jai-imgui

Jai bindings for the docking branch of [Dear ImGui](https://github.com/ocornut/imgui/tree/docking). We are currently at a commit a bit *newer* than `v1.91.9b`, which is [this](https://github.com/ocornut/imgui/tree/e11ad6b77e5c7f7ed28467fec42fe2c72068b68e).

These bindings are generated using Bindings Generator, except for very few basic things (e.g. Vec2) where we use Jai types instead, and can be seen in `module.jai`.

Generated bindings have the `ImGui` prefix removed, like `ImGuiStyle` becoming `Style`.

Bindings for official ImGui backends can be found in the `backends` folder.

The SDL3 headers we are using to build the SDL3 backend are `SDL v3.2.14`. You can find SDL3 bindings for jai [here](github.com/overlord-systems/jai-sdl3).

## Usage

Check out `tests/test.jai` for a complete working example using the `sdl3_gpu3` backend. You can compile using `jai tests/test.jai` and then run with `./tests/test.exe`.

Note: The main bindings should work on all platforms, but the backend currently only supports windows. It should be easy (trivial even) to add support for other platforms, just have to update `generate.jai` a bit. PRs welcome!

## Updating Bindings

Note: Steps 1 to 3 are only if you want to update the Dear ImGui version.

1. Clone this repo, then delete the `src/imgui` folder
2. Clone Dear ImGui into `src/`
3. Checkout to the `docking` branch or any branch/commit you want
4. Run `jai generate.jai` to generate new bindings. If you want to rebuild binaries as well, do `jai generate.jai - -compile`.
5. Regenerate bindings using `jai generate.jai - -backend_sdl3_gpu3`. You must run once per backend.
   1. If you want to update SDL3 headers, replace the `src/SDL3` folder with the new `include` folder from the [SDL3 repo](https://github.com/libsdl-org/SDL).

## Backends

We support using `generate.jai` to generate static libraries of ImGui backends. These generated libraries include *only* the backend code.

Since backend libraries do *not* include the main ImGui library, to use them your program must link to both the main Dear ImGui library and then, if you want to use a backend, to also link to the backend(s) of choice. Each backend has its own bindings file.

Currently the only supported backend is SDL3+SDL_GPU3, but it should be relatively easy to add more (check the `compile_and_generate_bindings_backend_sdl3_gpu3` procedure in `generate.jai` to see how its done and how you might do more).

To compile a backend and then generate ImGui bindings and backend bindings: `jai generate.jai - -backend_sdl3_gpu3`.

Supported backends:

- `sdl3_gpu3`

### MacOS Notes

When generating MacOS bindings for the `sdl3_gpu3` backend, for some reason the generator can't find
the library name for procedures and so almost nothing gets generated.

To make it work, we make the generator output bindings with the library name as '__UnknownLib', and then
we read the file, replace `#foreign __UnknownLib` with `#foreign imgui_sdl3_gpu3`, and `#elsewhere __UnknownLib` with `#elsewhere imgui_sdl3_gpu3`.

Its a dirty hack, but works for now :)

## Credits

The generator `generate.jai` is based on the ImGui module shipped with the jai compiler version `beta 0.2.012`, built 11 May 2025.
