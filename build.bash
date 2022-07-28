#!/bin/bash

# Stop if any errors occur
set -e

# Configuration
DOCKER_CONTAINER_NAME="astronomer"
DOCKER_IMAGE_NAME="viral32111/astronomer:latest"
HEADERS_DIRECTORY="include"

# Check if arguments are present
if [[ "$#" -lt 1 || -z "$1" ]]; then
	echo "Usage: $0 < docker | headers | run >" 1>&2
	exit 1
fi

# Build the Docker image
if [[ "$1" == "docker" ]]; then

	# Enable BuildKit
	export DOCKER_BUILDKIT=1

	# Build the image
	docker image build \
		--pull \
		--progress tty \
		--file dockerfile \
		--tag "${DOCKER_IMAGE_NAME}" \
		/var/empty

# Copy headers from the Docker image
elif [[ "$1" == "headers" ]]; then

	# Check if the Docker image is built
	if ! docker image inspect "${DOCKER_IMAGE_NAME}" > /dev/null 2>&1; then
		echo "Build the Docker image first." 1>&2
		exit 1
	fi

	# Clear the headers directory if it exists, otherwise create it
	if [[ -d "${HEADERS_DIRECTORY}" ]]; then
		rm --recursive "${HEADERS_DIRECTORY}"
		mkdir --parents "${HEADERS_DIRECTORY}"
		echo "Cleared directory '${HEADERS_DIRECTORY}'."
	else
		mkdir --parents "${HEADERS_DIRECTORY}"
		echo "Created directory '${HEADERS_DIRECTORY}'."
	fi

	# The header files & directories within the Docker image to copy
	IMAGE_HEADERS=(
		
		# GTK 4
		"/usr/include/gtk-4.0"
		"/usr/include/glib-2.0"
		"/usr/lib/x86_64-linux-gnu/glib-2.0/include/glibconfig.h"
		"/usr/include/cairo"
		"/usr/include/pango-1.0"
		"/usr/include/harfbuzz"
		"/usr/include/gdk-pixbuf-2.0"
		"/usr/include/graphene-1.0"
		"/usr/lib/x86_64-linux-gnu/graphene-1.0/include/graphene-config.h"

		# cURL
		"/usr/include/x86_64-linux-gnu/curl"

	)

	# Create a Docker container
	CONTAINER_ID=$(docker container create \
		--name "${DOCKER_CONTAINER_NAME}" \
		"${DOCKER_IMAGE_NAME}")
	echo "Created container '${CONTAINER_ID}' using image '${DOCKER_IMAGE_NAME}'."

	# Copy the header files from the Docker container to the headers directory
	for HEADER_PATH in "${IMAGE_HEADERS[@]}"; do
		docker container cp "${CONTAINER_ID}:${HEADER_PATH}" "${HEADERS_DIRECTORY}/"
		echo "Copied '${HEADER_PATH}' to '${HEADERS_DIRECTORY}'."
	done

	# Remove the Docker container
	docker container rm "${CONTAINER_ID}" > /dev/null
	echo "Removed container '${CONTAINER_ID}'."

# Run the application in the Docker image
elif [[ "$1" == "run" ]]; then

	# Check if the Docker image is built
	if ! docker image inspect "${DOCKER_IMAGE_NAME}" > /dev/null 2>&1; then
		echo "Build the Docker image first." 1>&2
		exit 1
	fi

	# Stop & remove the Docker container if it already exists
	if docker container inspect "${DOCKER_CONTAINER_NAME}" > /dev/null 2>&1; then
		CONTAINER_ID=$(docker container rm --force "${DOCKER_CONTAINER_NAME}")
		echo "Stopped existing container '${CONTAINER_ID}'."
	fi

	# Start the Docker container
	CONTAINER_ID=$(docker container run \
		--name "${DOCKER_CONTAINER_NAME}" \
		--mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix \
		--mount type=bind,source=$HOME/.Xauthority,target=/home/user/.Xauthority \
		--mount type=bind,source=$PWD/source,target=/home/user/source,readonly \
		--network host \
		--env XAUTHORITY=/home/user/.Xauthority \
		--env DISPLAY=$DISPLAY \
		--device /dev/dri/renderD128 \
		--device /dev/dri/card0 \
		--interactive \
		--tty \
		--detach \
		"${DOCKER_IMAGE_NAME}")
	echo "Started container '${CONTAINER_ID}' using image '${DOCKER_IMAGE_NAME}'."

	# Build the application
	docker container exec \
		--interactive \
		--tty \
		"${CONTAINER_ID}" \
		bash -c 'gcc -Wall $(pkg-config --cflags gtk4) -I/usr/include/x86_64-linux-gnu/curl -o /tmp/build source/main.c $(pkg-config --libs gtk4) -lcurl'

	# Run the application
	# TODO: Only do this if the build does not error
	docker container exec \
		--interactive \
		--tty \
		"${CONTAINER_ID}" \
		/tmp/build

	# Stop & remove the container
	docker container rm --force "${CONTAINER_ID}" > /dev/null
	echo "Stopped container '${CONTAINER_ID}'."

else
	echo "Unrecognised action." 1>&2
	exit 1
fi
