#if OS == .WINDOWS {
    #load "windows/windows_sdl3_gpu3.jai";
} else #if OS == .MACOS {
    #load "./unix_sdl3_gpu3.jai";
} else {
    #assert false "sdl3_gpu3 currently only supports Windows and MacOS. Check generate.jai to see how Windows works so that you can add support for your OS!";
}
