#!/usr/bin/env zsh

nix build . || exit 1
docker rmi docker-image:0.0.1 || true
docker import $(readlink -n result) docker-image:0.0.1 || exit 1
docker inspect docker-image:0.0.1 | grep "Cmd"

#Error response from daemon: No such image: docker-image:0.0.1
#sha256:11b00e0fd76e4c67e1fb685cfa32ac526fb674ce45e5ff8795fc15d8cf3d4cd6
#            "Cmd": null,
#            "Cmd": null,

docker run docker-image:0.0.1 /bin/docker-image