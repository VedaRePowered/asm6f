{
	description = "asm6f packaged for nix";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	};

	outputs = { self, nixpkgs }: let
		forAllSystems = nixpkgs.lib.genAttrs [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
	in {
		packages = forAllSystems (system:
			let
				pkgs = nixpkgs.legacyPackages.${system};
				binName = "asm6f";
			in {
				asm6f = pkgs.stdenv.mkDerivation {
					name = "asm6f";
					version = "1.6";
					src = self;

					buildInputs = with pkgs; [ gcc ];
					buildPhase = "gcc -Wall -O2 asm6f.c -o ${binName}";
					installPhase = ''
						mkdir -p $out/bin
						cp ${binName} $out/bin
					'';
				};
				default = self.packages.${system}.asm6f;
			}
		);
	};
}
