//
// This file was auto-generated using the following command:
//
// jai generate.jai - -backend_sdl3_gpu3
//



// Gamepad selection automatically starts in AutoFirst mode, picking first available SDL_Gamepad. You may override this.
// When using manual mode, caller is responsible for opening/closing gamepad.
ImplSDL3_GamepadMode :: enum u32 {
    AutoFirst :: 0;
    AutoAll   :: 1;
    Manual    :: 2;
    ImGui_ImplSDL3_GamepadMode_AutoFirst :: AutoFirst;
    ImGui_ImplSDL3_GamepadMode_AutoAll   :: AutoAll;
    ImGui_ImplSDL3_GamepadMode_Manual    :: Manual;
}

// Initialization data, for ImGui_ImplSDLGPU_Init()
// - Remember to set ColorTargetFormat to the correct format. If you're rendering to the swapchain, call SDL_GetGPUSwapchainTextureFormat to query the right value
ImplSDLGPU3_InitInfo :: struct {
    Device:            *SDL_GPUDevice = null;
    ColorTargetFormat: SDL_GPUTextureFormat = .SDL_GPU_TEXTUREFORMAT_INVALID;
    MSAASamples:       SDL_GPUSampleCount = .SDL_GPU_SAMPLECOUNT_1;
}

#scope_file

#if OS == .MACOS imgui_sdl3_gpu3 :: #library,no_dll "backends/macos/ImGui_sdl3_gpu3";
#if OS == .LINUX imgui_sdl3_gpu3 :: #library,no_dll "backends/linux/ImGui_sdl3_gpu3";
