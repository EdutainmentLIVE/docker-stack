FROM ubuntu:focal-20210827

ARG USER=haskell
ARG UID=1000
ARG GID=1000

ARG DEBIAN_FRONTEND=noninteractive
ARG STACK_VERSION=2.7.3

ENV LANG=C.UTF-8

ENV PATH=/home/$USER/.ghcup/bin:/stack/bin:/usr/lib/postgresql/13/bin:$PATH

# Create a default home for the default user & allow any user to sudo
RUN groupadd -g "$GID" $USER \
  && useradd --create-home --uid "$UID" --gid "$GID" "$USER" \
  && mkdir -p /etc/sudoers.d/ \
  && echo "$USER ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$USER"

# Have a default work directory. Chances are your configs will override this to provide a better
# experience like terminal click to go to definition.
WORKDIR "/home/$USER"

RUN apt-get update -y && apt-get install -y gnupg curl ca-certificates
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
RUN echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -y \
  && apt-get install -y \
    curl \
    gcc \
    git \
    gzip \
    libgmp-dev \
    liblzma-dev \
    libncurses5-dev \
    libpq-dev \
    make \
    netcat-openbsd \
    perl \
    postgresql-13 \
    sudo \
    tar \
    wget \
    xz-utils \
    zip \
    zlib1g-dev \
  && apt-get autoremove

# Own stack's working directory and allow any user to write to it. This is a "shared" stack
# directory that any user is capable to writing/reading/executing to. For the most part users will
# execute with UID 1000 and will not have to worry about the extended permissions. But if you're
# using a non-standard UID then you would have to execute this image with a different UID and would
# still have to have access to this directory.
RUN mkdir -p /stack && chown -R $USER:$USER /stack

ENV STACK_ROOT="/stack/.stack"

USER "$USER"

# Copy stack.yaml with overriden packages and extra-deps
COPY --chown=$UID:$GID config.yaml /home/$USER/.stack/config.yaml
COPY --chown=$UID:$GID stack.yaml /home/$USER/.stack/global-project/stack.yaml

COPY install.sh /home/$USER/install.sh
RUN /home/$USER/install.sh
