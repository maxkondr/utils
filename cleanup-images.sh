#!/bin/bash
set -e

# ----------------------------------------
function cleanup_dangling_volumes() {
	local volumes
	volumes="$(docker volume ls -qf dangling=true | xargs -r)"

	if [[ -n "${volumes}" ]]; then
		docker volume rm --force "${volumes}"
	fi
}

function cleanup_exited_containers() {
	local containers
	containers=$(docker ps -qa --no-trunc --filter "status=exited" | xargs -r)

	if [[ -n "${containers}" ]]; then
		docker rm --force "${containers}"
	fi
}

function cleanup_dangling_images() {
	local images
	images="$(docker images --filter "dangling=true" -q --no-trunc | xargs -r)"

	if [[ -n "${images}" ]]; then
		docker rmi -f "${images}"
	fi
}

# ------------- main ---------------
cleanup_dangling_volumes
cleanup_exited_containers
cleanup_dangling_images

echo "Cleanup is finished"

# docker network ls
# docker network ls | grep "bridge"
# docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
