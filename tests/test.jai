#import "Basic";


// Import the imgui module (usually just '#import "imgui')
#import,file "../module.jai";

#import "sdl3";
// Load the backend(s) you want. This *must* be #load because they might rely on other libraries.
// In this case, sdl3_gpu3 relies on types from "sdl3", so by importing sdl3 and loading imgui, imgui
// gets access to the types it needs.
#load "../backends/sdl3_gpu3.jai";

// Calls SDL_GetError then SDL_ClearError
//
// The returned string is owned by SDL and only valid
// until the next SDL call
consume_sdl_error :: () -> string {
    data := SDL_GetError();
    SDL_ClearError();
    return to_string(data);
}

ok_or_exit :: inline (success: bool, err_msg_format: string, args: ..Any, flags := Log_Flags.ERROR, exit_code : s32 = 1) {

    if success return;

    log(err_msg_format, ..args, flags=flags);
    exit(exit_code);
} @PrintLike

main :: () {

    // Setup window and gpu using the SDL3_GPU3 backend.
    // This is based on the 'example_sdl3_sdlgpu3' Dear ImGui example, which you can find on their repo.
    success := SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO);
    ok_or_exit(success, "failed to init sdl3 with error = %", consume_sdl_error());

    window := SDL_CreateWindow("Overlord Systems", 1920, 1080, SDL_WINDOW_RESIZABLE | SDL_WINDOW_HIGH_PIXEL_DENSITY);
    ok_or_exit(!!window, "failed to create window with error = %", consume_sdl_error());

    gpu_device := SDL_CreateGPUDevice(SDL_GPU_SHADERFORMAT_SPIRV | SDL_GPU_SHADERFORMAT_DXIL | SDL_GPU_SHADERFORMAT_METALLIB, true, null);
    ok_or_exit(!!gpu_device, "failed to create GPU device with error = %", consume_sdl_error());

    success = SDL_ClaimWindowForGPUDevice(gpu_device, window);
    ok_or_exit(success, "failed to claim window with title '%' for gpu device with error = %", to_string(SDL_GetWindowTitle(window)), consume_sdl_error());

    success = SDL_SetGPUSwapchainParameters(gpu_device, window, .SDR, .MAILBOX);
    ok_or_exit(success, "failed to set swapchain parameters with error = %", consume_sdl_error());

    // Setup ImGui
    success = DebugCheckVersionAndDataLayout(IMGUI_VERSION, size_of(IO), size_of(Style), size_of(ImVec2), size_of(ImVec4), size_of(ImDrawVert), size_of(ImDrawIdx));
    ok_or_exit(success, "failed imgui DebugCheckVersionAndDataLayout");

    ctx := CreateContext();
    io := GetIO();

    io.ConfigFlags_ |= .NavEnableKeyboard | .NavEnableGamepad;
    StyleColorsDark();

    // Setup imgui sdl3_gpu3 backend
    ImplSDL3_InitForSDLGPU(window);


    is_running := true;
    while is_running {

        ev: SDL_Event;
        while(SDL_PollEvent(*ev)) {

            if ev.type == {

                case xx SDL_EventType.QUIT;
                    is_running = false;

                case xx SDL_EventType.KEY_DOWN;
                    if ev.key.key == SDLK_ESCAPE
                        is_running = false;
                case;
            }
        }
    }
}
