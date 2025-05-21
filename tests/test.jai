#import "Basic";
#import "sdl3";
#import,file "../module.jai";

// Calls SDL_GetError then SDL_ClearError
//
// The returned string is owned by SDL and only valid
// until the next SDL call
consume_sdl_error :: () -> string {
    data := SDL_GetError();
    SDL_ClearError();
    return to_string(data);
}

main :: () {

    success := SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO);
    if !success {
        err := consume_sdl_error();
        log("failed to init sdl3. err = %", err, flags=.ERROR);
        exit(1);
    }

    window: *SDL_Window;
    renderer: *SDL_Renderer;
    success = SDL_CreateWindowAndRenderer("Overlord Systems", 1920, 1080, SDL_WINDOW_VULKAN, *window, *renderer);
    if !success {
        err := consume_sdl_error();
        log("failed to create window. err = %", err, flags=.ERROR);
        exit(1);
    }

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
