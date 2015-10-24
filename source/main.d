import std.stdio;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.opengl3.gl;
import derelict.opengl3.gl3;

import game.timer;
import game.application;
import game.texture;

class Game : Application
{

    override void initialize()
    {
        texture = new Texture("data/beacon.png");
    }

    override void shutdown()
    {
    }

    override void doFrame(float elapsedSeconds)
    {
        if (input.isKeyJustPressed(SDL_SCANCODE_ESCAPE))
        {
            quit = true;
        }

        dx = dy = 0;
        if (input.isKeyDown(SDL_SCANCODE_UP))
        {
            dy = -1;
        }
        else if (input.isKeyDown(SDL_SCANCODE_DOWN))
        {
            dy = 1;
        }

        if (input.isKeyDown(SDL_SCANCODE_LEFT))
        {
            dx = -1;
        }
        else if (input.isKeyDown(SDL_SCANCODE_RIGHT))
        {
            dx = 1;
        }

        const float speed = 200;
        coordX += dx * speed * elapsedSeconds;
        coordY += dy * speed * elapsedSeconds;

        glClearColor(0.0, 0.1, 0.4, 1);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        glEnable(GL_TEXTURE_2D);
        texture.use();
        glBegin(GL_QUADS);
        glTexCoord2f(0, 0);
        glVertex2f(coordX + 0, coordY + 0);

        glTexCoord2f(1, 0);
        glVertex2f(coordX + 64, coordY + 0);

        glTexCoord2f(1, 1);
        glVertex2f(coordX + 64, coordY + 64);

        glTexCoord2f(0, 1);
        glVertex2f(coordX + 0, coordY + 64);
        glEnd();
        glDisable(GL_TEXTURE_2D);

        if (fpsCounter.timeToShow())
        {
            writeln("FPS: ", fpsCounter.getFps());
        }

    }

    Texture texture;
    float dx, dy;
    float coordX = 0;
    float coordY = 0;
}

void main()
{
    Game game = new Game();
    game.run();
}
