---
title: Getting Started with SDL
date: 2019-01-03
---
A number of years ago, I wrote a couple of tutorials on software-based rendering ([Simple Line Drawing](/articles/simple_line_drawing/) and [Triangle Rasterization](/articles/triangle_rasterization/)). I created sample programs to go along with those articles; those programs originally used [SDL](https://www.libsdl.org/) 1.2 in order to get graphics onto the screen, and I recently updated them to use SDL version 2. Having been away from SDL for a while, I was glad to see that it has continued to improve and remains very easy to use.

SDL (or "Simple DirectMedia Layer") is an excellent library for developing games or other media applications that need to perform tasks such as rendering graphics, playing audio, and handling user input. It's well-known for its cross-platform capabilities, but its well-designed and simple API make it a good choice even when cross-platform development is not a concern.

With SDL, it's very easy to get a window onto the screen, render graphics, and handle input events. Here's some C code for doing so:

```c
#include <stdio.h>
// Define SDL_MAIN_HANDLED so that we don't create a WinMain function on Windows.
#define SDL_MAIN_HANDLED
#include <SDL2/SDL.h>

// Define the window dimensions and the size of a square to render.
const int WIDTH = 320;
const int HEIGHT = 240;
const int SQUARE_SIZE = 32;

int main(int argc, const char *argv[]) {
    SDL_Window *window;
    SDL_Renderer *renderer;
    SDL_Rect rect = {
        (WIDTH - SQUARE_SIZE) / 2,
        (HEIGHT - SQUARE_SIZE) / 2,
        SQUARE_SIZE,
        SQUARE_SIZE
    };
    int running = 1;

    // Initialize SDL with video rendering only.
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        fprintf(stderr, "SDL_Init failed");
        return 1;
    }

    window = SDL_CreateWindow("Hello",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        WIDTH, HEIGHT, 0);
    if (!window) {
        fprintf(stderr, "SDL_CreateWindow failed");
        return 2;
    }

    renderer = SDL_CreateRenderer(window, -1, 0);
    if (!renderer) {
        fprintf(stderr, "SDL_CreateRenderer failed");
        return 3;
    }

    // Render a black background with a white square in the center.
    // Note that the functions used below may return error codes;
    // error checking is omitted for brevity.
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
    SDL_RenderClear(renderer);
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, SDL_ALPHA_OPAQUE);
    SDL_RenderFillRect(renderer, &rect);
    SDL_RenderPresent(renderer);

    // Wait until we've received a window close or key event.
    while (running) {
        SDL_Event e;
        if (SDL_WaitEvent(&e)) {
            switch (e.type) {
                default:
                    break;
                case SDL_QUIT:
                case SDL_KEYDOWN:
                    running = 0;
                    break;
            }
        }
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
```

Given the API's logical design and descriptive function names, the code above should be fairly self-explanatory. SDL provides a number of functions (such as `SDL_RenderFillRect`, seen above) for high-performance graphics rendering. Behind the scenes, SDL uses whichever mechanism is appropriate for the host system, such as Direct3D on Windows, Metal on macOS, and OpenGL on Linux. It can also work with APIs such as OpenGL and Vulkan in case you need to do more advanced rendering. Be sure to check out the [SDL website](https://www.libsdl.org/) for more information.
