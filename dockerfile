# docker build --file dockerfile --tag viral32111/astronomer:latest /var/empty

FROM registry.server.home/ubuntu:22.04

RUN apt-get update && \
	apt-get install --no-install-recommends --yes libgtk-3-0 libgtk-3-dev xauth && \
	rm --verbose --force --recursive /var/lib/apt/lists/*

USER ${USER_ID}:${USER_ID}

ENV XDG_CONFIG_HOME=${USER_HOME}/.config \
	XDG_CACHE_HOME=${USER_HOME}/.cache \
	XDG_DATA_HOME=${USER_HOME}/.local/share \
	XDG_STATE_HOME=${USER_HOME}/.local/state \
	XDG_RUNTIME_DIR=${USER_HOME}/.run

RUN mkdir --verbose --parents $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME $XDG_STATE_HOME $XDG_RUNTIME_DIR
