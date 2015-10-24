module game.timer;

import std.datetime;
import std.stdio;

class Timer {

    this() {
        last = TickDuration.from!"seconds"(0);
        sw.start();
    }

    ~this() {
    }

    float lap() {
        sw.stop();
        float elapsedMsThisFrame = (sw.peek() - last).usecs / 1000.0;
        last = sw.peek();
        sw.start();
        return elapsedMsThisFrame;
    }

    StopWatch sw;
    TickDuration last;
}



