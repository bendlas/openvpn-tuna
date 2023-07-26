{
  description = "AWS VPN client";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.ocproxy-src.url = "github:cernekee/ocproxy";
  inputs.ocproxy-src.flake = false;

  outputs = { self, nixpkgs, flake-utils, ocproxy-src }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.openvpn = pkgs.openvpn.overrideAttrs (_old: {
        version = "2.6-tuna";
        src = ./.;
        ## Doesn't work
        # ## filter tuna from openvpn source
        # ## for fewer rebuilds when working on tuna
        # src = builtins.filterSource
        #   (path: type:
        #     ! pkgs.lib.strings.hasPrefix (toString ./tuna) path
        #     && path != toString ./flake.nix
        #     && path != toString ./flake.lock
        #   ) ./.;
        buildInputs = (_old.buildInputs or []) ++ pkgs.lib.optionals pkgs.stdenv.isLinux (with pkgs; [
          libnl
          libcap_ng
        ]) ++ (with pkgs; [
          lz4
          python3Packages.docutils
        ]);
        nativeBuildInputs = (_old.nativeBuildInputs or []) ++ (with pkgs; [
          autoreconfHook
        ]);
      });
      packages.connect = pkgs.callPackage ./tuna/connect {
        openvpnTuna = self.packages.${system}.openvpn;
      };
      packages.ocproxy = pkgs.callPackage ./tuna/ocproxy { inherit ocproxy-src; };
      packages.tunsocks = pkgs.callPackage ./tuna/tunsocks.nix { };
      apps.server = {
        type = "app";
        program = "${pkgs.writeShellScript "tuna-server" ''
          set -eu
          ${pkgs.go}/bin/go run ${./tuna/server.go}
        ''}";
      };
      apps.vpnns = {
        type = "app";
        program = "${pkgs.writeShellScript "tuna-vpnns" ''
          set -eu
          ${self.packages.${system}.connect}/bin/tuna-connect \
            "$1" \
            "${pkgs.coreutils}/bin/env; HOME=$HOME ${self.packages.${system}.ocproxy}/bin/vpnns --attach"
        ''}";
      };
      apps.ocproxy = {
        type = "app";
        program = "${pkgs.writeShellScript "tuna-ocproxy" ''
          set -eu
          ${self.packages.${system}.connect}/bin/tuna-connect \
            "$1" \
            "HOME=$HOME ${self.packages.${system}.ocproxy}/bin/ocproxy -v -D 10080"
        ''}";
      };
      apps.tunsocks = {
        type = "app";
        program = "${pkgs.writeShellScript "tuna-tunsocks" ''
          set -eu
          ${self.packages.${system}.connect}/bin/tuna-connect \
            "$1" \
            "HOME=$HOME exec ${self.packages.${system}.tunsocks}/bin/tunsocks -D 127.0.0.1:10080"
          ''}";
      };
    });
}
