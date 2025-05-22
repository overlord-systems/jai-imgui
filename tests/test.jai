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
    ok_or_exit(!!gpu_device, "failed to create gpu device with error = %", consume_sdl_error());

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

    init_info := ImplSDLGPU3_InitInfo.{
        Device = gpu_device,
        ColorTargetFormat = SDL_GetGPUSwapchainTextureFormat(gpu_device, window),
        MSAASamples = .SDL_GPU_SAMPLECOUNT_4,
    };

    success = ImplSDLGPU3_Init(*init_info);
    ok_or_exit(success, "failed to init SDLGPU3 with error = %", consume_sdl_error());

    // Program loop
    is_running := true;
    while is_running {

        //
        // Frame start
        //
        ev: SDL_Event;
        while(SDL_PollEvent(*ev)) {

            // Send events to imgui through the backend, then do our processing
            success = ImplSDL3_ProcessEvent(*ev);
            ok_or_exit(success, "failed to process sdl3 event = % with error = %", ev, consume_sdl_error());

            if ev.type == {

                case xx SDL_EventType.QUIT;
                    is_running = false;

                case xx SDL_EventType.KEY_DOWN;
                    if ev.key.key == SDLK_ESCAPE
                        is_running = false;

                case xx SDL_EventType.WINDOW_CLOSE_REQUESTED;
                    if ev.window.windowID == SDL_GetWindowID(window)
                        is_running = false;
                case;
            }
        }

        //
        // Frame logic
        //

        // Start new imgui frame
        ImplSDLGPU3_NewFrame();
        ImplSDL3_NewFrame();
        NewFrame();

        // Draw whatever we want
        ShowDemoWindow();

        //
        // Rendering
        //

        // Render imgui
        Render();
        draw_data := GetDrawData();
        is_minimized := (draw_data.DisplaySize.x <= 0 || draw_data.DisplaySize.y <= 0);

        // Acquire a GPU command buffer and swapchain texture
        cmd_buffer := SDL_AcquireGPUCommandBuffer(gpu_device);

        swapchain_texture: *SDL_GPUTexture;
        success = SDL_AcquireGPUSwapchainTexture(cmd_buffer, window, *swapchain_texture, null, null);
        ok_or_exit(success, "failed to acquire gpu swapchain texture with error = %", consume_sdl_error());

        // If all good we will do a render pass that draws the UI
        if swapchain_texture && !is_minimized {

            // This must be done first when using this backend to upload imgui vertex data
            ImplSDLGPU3_PrepareDrawData(draw_data, cmd_buffer);

            // Setup render pass and start it
            target_info := SDL_GPUColorTargetInfo.{
                texture = swapchain_texture,
                clear_color = SDL_FColor.{r=1},
                load_op = .CLEAR,
                store_op = .STORE,
                mip_level = 0,
                layer_or_depth_plane = 0,
                cycle = false,
            };

            render_pass := SDL_BeginGPURenderPass(cmd_buffer, *target_info, 1, null);

            // Draw things. Here, we only have imgui
            ImplSDLGPU3_RenderDrawData(draw_data, cmd_buffer, render_pass);

            // End render pass
            SDL_EndGPURenderPass(render_pass);
        }

        // Finally, we send to GPU to draw
        SDL_SubmitGPUCommandBuffer(cmd_buffer);
    }

    //
    // Cleanup and app shutdown
    //

    SDL_WaitForGPUIdle(gpu_device);
    ImplSDL3_Shutdown();
    ImplSDLGPU3_Shutdown();
    DestroyContext(ctx);
}
