module game.fpscounter;

class FpsCounter {

    void update(float elapsedSeconds) {
        timeAccumulator += elapsedSeconds;
        if (timeAccumulator > 1) {
            fps = currentFps;
            timeAccumulator = 0;
            currentFps = 0;
            shouldShow = true;
        }
    }

    void addFrame() {
        currentFps++;
    }

    int getFps() const {
        return fps;
    }

    bool timeToShow() {
        if (shouldShow) {
            shouldShow = false;
            return true;
        }
        return false;
    }

    int fps;
    int currentFps;
    float timeAccumulator = 0;
    bool shouldShow = false;
}
