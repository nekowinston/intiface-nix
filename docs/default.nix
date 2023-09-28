{pkgs}: let
  inherit (pkgs) lib;
  scrubDerivations = prefixPath: attrs: let
    inherit (lib) isAttrs optionalAttrs isDerivation mapAttrs;
    scrubDerivation = name: value: let
      pkgAttrName = prefixPath + "." + name;
    in
      if isAttrs value
      then
        scrubDerivations pkgAttrName value
        // optionalAttrs (isDerivation value) {
          outPath = "\${${pkgAttrName}}";
        }
      else value;
  in
    mapAttrs scrubDerivation attrs;

  mkEval = module:
    lib.evalModules {
      modules = [
        module
        {
          _module = {
            pkgs = lib.mkForce (scrubDerivations "pkgs" pkgs);
            check = false;
          };
        }
      ];
      specialArgs = {inherit pkgs;};
    };

  mkDoc = name: options: let
    doc = pkgs.nixosOptionsDoc {
      options = lib.filterAttrs (n: _: n != "_module") options;
      transformOptions = opt:
        opt
        // {
          declarations =
            map
            (decl:
              if lib.hasPrefix (toString ../.) (toString decl)
              then let
                subpath = lib.removePrefix "/" (lib.removePrefix (toString ../.) (toString decl));
              in {
                url = "https://github.com/nekowinston/intiface-nix/tree/master/${subpath}";
                name = subpath;
              }
              else decl)
            opt.declarations;
        };
    };
    md = pkgs.runCommand "${name}-module-doc.md" {} ''
      cat >$out <<EOF
      # Intiface-nix
      EOF

      cat ${doc.optionsCommonMark} >> $out
    '';
    css = builtins.fetchurl {
      url = "https://gist.githubusercontent.com/nekowinston/51c71f831b89c3797bb2254e166c25b9/raw/7a7cb0217b44c72f14d38da1ebd15584102220da/pandoc.css";
      sha256 = "sha256:1hkbm8l3s3il5i409a6mafm8n2x48ly1jyn0m0h07l23rmrv7p89";
    };
  in
    pkgs.runCommand "intiface-nix.html" {nativeBuildInputs = [pkgs.pandoc];} ''
      mkdir $out
      cp ${css} $out/pandoc.css
      pandoc --css="pandoc.css" ${md} --to=html5 -s -f markdown+smart --metadata pagetitle="Intiface-nix options" -o $out/index.html
    '';
  hmEval = mkEval (import ../modules/hm);
in
  mkDoc "home-manager" hmEval.options
