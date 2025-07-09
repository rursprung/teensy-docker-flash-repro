# Teensy 4.1 Flashing From Dockerfile Not Working: Reproduction

This repository serves as a reproduction case for the following problem: it seems that running `pio run -t upload -e teensy41`
from docker does not work and results in flashing being stuck.

The problem discussion for this is [in the teensy forum](https://forum.pjrc.com/index.php?threads/how-to-flash-from-docker-container.77132/).

To reproduce run this:
```bash
docker build . -t teensy-flash-issue-repro
docker run --rm --privileged -v /dev:/dev teensy-flash-issue-repro
```

This expects that you have [docker installed](https://docs.docker.com/engine/install/) and the [udev rules](https://www.pjrc.com/teensy/00-teensy.rules) set up.

Expected result: it flashes the device every time.

Actual result: _sometimes_ it does work:
```
Rebooting...
Uploading .pio/build/teensy41/firmware.hex
Teensy Loader, Command Line, Version 2.2
Read ".pio/build/teensy41/firmware.hex": 23552 bytes, 1.2% usage
Found HalfKay Bootloader
Programming....................
Booting
========================= [SUCCESS] Took 1.52 seconds =========================
```

However, most of the time it just reports this:
```
Error opening USB device: Resource temporarily unavailable
Waiting for Teensy device...
 (hint: press the reset button)
```

It does stop the previously running firmware (tested by having blinky flashed on it and observing that the LED stops
blinking). Pressing the button has no influence on the board. Cancelling `docker run` (press Ctrl+C 3x) and then running
it again generally resolves this.
