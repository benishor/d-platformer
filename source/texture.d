module game.texture;

import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.opengl3.gl;
import derelict.opengl3.gl3;


class Texture {
    this(string path) {
        // load image
        SDL_Surface* surface = IMG_Load(std.string.toStringz(path));
        if (!surface) {
            //exit(1);
        }
        glGenTextures(1, &texture);
        glBindTexture(GL_TEXTURE_2D, texture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, surface.w, surface.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, surface.pixels);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        SDL_FreeSurface(surface);
    }

    void use() {
        glBindTexture(GL_TEXTURE_2D, texture);
    }

    void unuse() {
        glBindTexture(GL_TEXTURE_2D, 0);
    }

    GLuint texture;
}
