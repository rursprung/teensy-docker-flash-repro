FROM ubuntu:24.04

# setup environment
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update  \
    # basics
    && apt-get install -q -y --no-install-recommends \
    sudo \
    lsb-release \
    ca-certificates \
    curl \
    dirmngr \
    gnupg2 \
    build-essential \
    git \
    python3-full \
    python3-pip \
    pipx \
    && rm -rf /var/lib/apt/lists/*

# udev rules
RUN mkdir -p /etc/udev/rules.d/ \
    && curl https://www.pjrc.com/teensy/00-teensy.rules -o /etc/udev/rules.d/00-teensy.rules

# pipx (finish setup)
# note pipx packaged on Ubunttu 24.04 is outdated, thus we need to do some trickery to get the latest version so that we
# can do global installs
RUN pipx install pipx \
    && apt-get purge -y pipx \
    && ~/.local/bin/pipx install --global pipx \
    && ~/.local/bin/pipx uninstall pipx \
    && /usr/local/bin/pipx ensurepath --global

# platformio
RUN /usr/local/bin/pipx install --global platformio

# test project
WORKDIR /work
COPY . .

# already build project once during image build to speed up testing just the upload
RUN ["pio", "run", "-e" ,"teensy41"]

CMD ["pio", "run", "-t", "upload", "-e" ,"teensy41"]
