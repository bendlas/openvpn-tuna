{ lib
, runCommand
, writeShellScript
, bash
, makeWrapper
, coreutils
, util-linux
, bc
, gnugrep
, gawk
, bind
, libressl
, xdg-utils
, openvpnTuna
}:

runCommand "tuna" {
  xdgUtils = xdg-utils;
  utilLinux = util-linux;
  grep = gnugrep;
  awk = gawk;
  openssl = libressl;
  inherit (bind) dnsutils;
  inherit
    openvpnTuna
    coreutils
    bc
  ;
} ''
    mkdir -p $out/bin
    substituteAll ${./aws-connect.sh.in} $out/bin/tuna-connect
    substituteAll ${./connect-wrapper.sh.in} $out/bin/tuna-connect-liner
    chmod +x $out/bin/tuna-connect $out/bin/tuna-connect-liner
    fixupPhase
''
