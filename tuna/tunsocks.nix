{ stdenv, fetchFromGitHub, autoreconfHook, libpcap, libevent }:

stdenv.mkDerivation {
  pname = "tunsocks";
  version = "2023-06-22";

  src = fetchFromGitHub {
    owner = "russdill";
    repo = "tunsocks";
    rev = "4e4ff8682053412145930b8daf2c55d357cf1e44";
    hash = "sha256-9d8GLPhjIG2DvQx0Gvf4yRVYX/r/P8AkqrtsXZpB6Jw=";
    fetchSubmodules = true;
  };

  buildInputs = [ libpcap libevent ];
  nativeBuildInputs = [ autoreconfHook ];

}
