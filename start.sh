#!/bin/sh

docker run \
	--name astronomer \
	--mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix \
	--mount type=bind,source=$HOME/.Xauthority,target=/home/user/.Xauthority \
	--mount type=bind,source=$PWD/build,target=/home/user/build,readonly \
	--network host \
	--env XAUTHORITY=/home/user/.Xauthority \
	--env DISPLAY=$DISPLAY \
	--restart no \
	--pull never \
	--interactive \
	--tty \
	--rm \
	--entrypoint /home/user/build/helloworld \
	viral32111/astronomer:latest
