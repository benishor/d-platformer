module game.application;

import std.stdio;
import game.timer;
import game.fpscounter;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.opengl3.gl;
import derelict.opengl3.gl3;

struct KeyboardState
{
    bool[256] keys;
}

class InputProvider
{
    bool isKeyDown(int keyCode) const
    {
        return keyboardState.keys[keyCode];
    }

    bool isKeyUp(int keyCode) const
    {
        return !keyboardState.keys[keyCode];
    }

    bool isKeyJustPressed(int keyCode) const
    {
        return keyboardState.keys[keyCode] && !oldKeyboardState.keys[keyCode];
    }

    bool isKeyJustReleased(int keyCode) const
    {
        return !keyboardState.keys[keyCode] && oldKeyboardState.keys[keyCode];
    }

    void onEvent(SDL_Event event)
    {
        switch (event.type)
        {
        case SDL_KEYDOWN:
            if (event.key.keysym.scancode < 256)
                keyboardState.keys[event.key.keysym.scancode] = true;
            break;
        case SDL_KEYUP:
            if (event.key.keysym.scancode < 256)
                keyboardState.keys[event.key.keysym.scancode] = false;
            break;
        default:
            break;
        }
    }

    void copyNewStateToOldState()
    {
        oldKeyboardState = keyboardState;
    }

    KeyboardState keyboardState, oldKeyboardState;
}

abstract class Application
{

    this()
    {
        DerelictSDL2.load();
        DerelictSDL2Image.load();

        DerelictGL.load();
        DerelictGL3.load();

        SDL_Init(SDL_INIT_VIDEO);

        SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);

        uint flags = SDL_WINDOW_OPENGL;
        //flags |= SDL_WINDOW_FULLSCREEN;

        displayWindow = SDL_CreateWindow("Stardust", SDL_WINDOWPOS_UNDEFINED,
            SDL_WINDOWPOS_UNDEFINED, 1024, 768, flags);
        glContext = SDL_GL_CreateContext(displayWindow);
        SDL_GL_SetSwapInterval(1); // vsync off

        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG);

        const int DESIRED_WIDTH = 1024;
        const int DESIRED_HEIGHT = 768;
        // set viewport
        glViewport(0, 0, DESIRED_WIDTH, DESIRED_HEIGHT);
        glScissor(0, 0, DESIRED_WIDTH, DESIRED_HEIGHT);

        glEnable(GL_SCISSOR_TEST);
        glDisable(GL_DEPTH_TEST);

        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrtho(0, DESIRED_WIDTH, DESIRED_HEIGHT, 0, 0, 1);

        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();

        // initialize SDL image
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG);

        timer = new Timer();
        input = new InputProvider();
        fpsCounter = new FpsCounter();
    }

    ~this()
    {
        SDL_GL_DeleteContext(glContext);
        SDL_DestroyWindow(displayWindow);
        SDL_Quit();
    }

    abstract void initialize();
    abstract void shutdown();
    abstract void doFrame(float elapsedSeconds);

    void pollSdlEvents()
    {
        input.copyNewStateToOldState();

        SDL_Event e;
        while (SDL_PollEvent(&e) != 0)
        {
            input.onEvent(e);
            switch (e.type)
            {
            case SDL_QUIT:
                quit = true;
                break;
            default:
                break;
            }
        }
    }

    void run()
    {
        initialize();
        while (!quit)
        {
            pollSdlEvents();
            float elapsedSeconds = timer.lap() / 1000.0;
            doFrame(elapsedSeconds);
            SDL_GL_SwapWindow(displayWindow);
            fpsCounter.addFrame();
            fpsCounter.update(elapsedSeconds);
        }
        shutdown();
    }

    SDL_Window* displayWindow;
    SDL_GLContext glContext;
    bool quit = false;
    Timer timer;
    InputProvider input;
    FpsCounter fpsCounter;
}
