# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  intiface-central = {
    pname = "intiface-central";
    version = "v2.4.3";
    src = fetchFromGitHub {
      owner = "intiface";
      repo = "intiface-central";
      rev = "v2.4.3";
      fetchSubmodules = false;
      sha256 = "sha256-D5S+IpHZgCkb9h0/+GMqmzKwpqFZSBIKDigEuLUTjaM=";
    };
  };
  intiface-engine = {
    pname = "intiface-engine";
    version = "v1.4.2";
    src = fetchFromGitHub {
      owner = "intiface";
      repo = "intiface-engine";
      rev = "v1.4.2";
      fetchSubmodules = false;
      sha256 = "sha256-jx++ll3ZNZ0SvLHQgpxYmCxDjObl1ohMXb1sYIhJ98U=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./intiface-engine-v1.4.2/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
