{ pkgs, stdenv, lib, buildGoModule, dockerTools, buildEnv, ... }:

let
  version = "0.0.1";

  docker_image_bin = buildGoModule {
    pname = "docker_image";
    inherit version;
    src = ./.;
    vendorHash = null;
  };

  docker_image_app = stdenv.mkDerivation rec {
    pname = "docker_image_app";
    inherit version;

    buildPhase = ''
      mkdir -p $out/bin
      mkdir $out/web
      cp -Rf $src/web/* $out/web/.
      cp ${docker_image_bin}/bin/docker_image $out/bin/docker_image
    '';

    src = ./.;

  };

  image = with dockerTools; buildLayeredImage {
    name = "docker_image";
    tag = "latest";
    architecture = "x86_64-linux";
    contents = [ docker_image_app ];
    config.Cmd = [ "/bin/docker_image" ];
    maxLayers = 120;
  };

in
# docker import $(readlink -n result) docker_image:0.0.1
  # docker run flow:0.0.1 /bin/docker_image
dockerTools.exportImage {
  fromImage = image;
  fromImageName = null;
  fromImageTag = null;

  name = image.name;
}

