//
// This file was auto-generated using the following command:
//
// jai generate.jai - -backend_sdl3_gpu3
//



// Follow "Getting Started" link and check examples/ folder to learn about using backends!
ImplSDL3_InitForOpenGL :: (window: *SDL_Window, sdl_gl_context: *void) -> bool #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_InitForOpenGL@@YA_NPEAUSDL_Window@@PEAX@Z";
ImplSDL3_InitForVulkan :: (window: *SDL_Window) -> bool #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_InitForVulkan@@YA_NPEAUSDL_Window@@@Z";
ImplSDL3_InitForD3D :: (window: *SDL_Window) -> bool #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_InitForD3D@@YA_NPEAUSDL_Window@@@Z";
ImplSDL3_InitForMetal :: (window: *SDL_Window) -> bool #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_InitForMetal@@YA_NPEAUSDL_Window@@@Z";
ImplSDL3_InitForSDLRenderer :: (window: *SDL_Window, renderer: *SDL_Renderer) -> bool #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_InitForSDLRenderer@@YA_NPEAUSDL_Window@@PEAUSDL_Renderer@@@Z";
ImplSDL3_InitForSDLGPU :: (window: *SDL_Window) -> bool #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_InitForSDLGPU@@YA_NPEAUSDL_Window@@@Z";
ImplSDL3_InitForOther :: (window: *SDL_Window) -> bool #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_InitForOther@@YA_NPEAUSDL_Window@@@Z";
ImplSDL3_Shutdown :: () -> void #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_Shutdown@@YAXXZ";
ImplSDL3_NewFrame :: () -> void #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_NewFrame@@YAXXZ";
ImplSDL3_ProcessEvent :: (event: *SDL_Event) -> bool #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_ProcessEvent@@YA_NPEBTSDL_Event@@@Z";

// Gamepad selection automatically starts in AutoFirst mode, picking first available SDL_Gamepad. You may override this.
// When using manual mode, caller is responsible for opening/closing gamepad.
ImplSDL3_GamepadMode :: enum s32 {
    AutoFirst :: 0;
    AutoAll   :: 1;
    Manual    :: 2;
    ImGui_ImplSDL3_GamepadMode_AutoFirst :: AutoFirst;
    ImGui_ImplSDL3_GamepadMode_AutoAll   :: AutoAll;
    ImGui_ImplSDL3_GamepadMode_Manual    :: Manual;
}
ImplSDL3_SetGamepadMode :: (mode: ImplSDL3_GamepadMode, manual_gamepads_array: **SDL_Gamepad = null, manual_gamepads_count: s32 = -1) -> void #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDL3_SetGamepadMode@@YAXW4ImGui_ImplSDL3_GamepadMode@@PEAPEAUSDL_Gamepad@@H@Z";

// Initialization data, for ImGui_ImplSDLGPU_Init()
// - Remember to set ColorTargetFormat to the correct format. If you're rendering to the swapchain, call SDL_GetGPUSwapchainTextureFormat to query the right value
ImplSDLGPU3_InitInfo :: struct {
    Device:            *SDL_GPUDevice = null;
    ColorTargetFormat: SDL_GPUTextureFormat = .SDL_GPU_TEXTUREFORMAT_INVALID;
    MSAASamples:       SDL_GPUSampleCount = .SDL_GPU_SAMPLECOUNT_1;
}

// Follow "Getting Started" link and check examples/ folder to learn about using backends!
ImplSDLGPU3_Init :: (info: *ImplSDLGPU3_InitInfo) -> bool #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDLGPU3_Init@@YA_NPEAUImGui_ImplSDLGPU3_InitInfo@@@Z";
ImplSDLGPU3_Shutdown :: () -> void #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDLGPU3_Shutdown@@YAXXZ";
ImplSDLGPU3_NewFrame :: () -> void #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDLGPU3_NewFrame@@YAXXZ";

ImplSDLGPU3_RenderDrawData :: (draw_data: *ImDrawData, command_buffer: *SDL_GPUCommandBuffer, render_pass: *SDL_GPURenderPass, pipeline: *SDL_GPUGraphicsPipeline = null) -> void #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDLGPU3_RenderDrawData@@YAXPEAUImDrawData@@PEAUSDL_GPUCommandBuffer@@PEAUSDL_GPURenderPass@@PEAUSDL_GPUGraphicsPipeline@@@Z";

ImplSDLGPU3_CreateDeviceObjects :: () -> void #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDLGPU3_CreateDeviceObjects@@YAXXZ";
ImplSDLGPU3_DestroyDeviceObjects :: () -> void #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDLGPU3_DestroyDeviceObjects@@YAXXZ";
ImplSDLGPU3_CreateFontsTexture :: () -> void #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDLGPU3_CreateFontsTexture@@YAXXZ";
ImplSDLGPU3_DestroyFontsTexture :: () -> void #foreign imgui_sdl3_gpu3 "?ImGui_ImplSDLGPU3_DestroyFontsTexture@@YAXXZ";

#scope_file

imgui_sdl3_gpu3 :: #library "ImGui_sdl3_gpu3.static";
