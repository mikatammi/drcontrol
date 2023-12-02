{
  python3Packages,
  libusb1,
  libftdi1,
}: let
  pylibftdiWithOverrides = python3Packages.pylibftdi.overrideAttrs (_: {
    postPatch = ''
      substituteInPlace src/pylibftdi/driver.py \
        --replace "self._load_library(\"libusb\")" "cdll.LoadLibrary('${libusb1.out}/lib/libusb-1.0.so')" \
        --replace "self._load_library(\"libftdi\")" "cdll.LoadLibrary('${libftdi1.out}/lib/libftdi1.so')"
    '';
  });
in
  python3Packages.buildPythonApplication {
    pname = "drcontrol";
    version = "0.13";
    propagatedBuildInputs = [
      pylibftdiWithOverrides
    ];
    src = ./.;
    postFixup = ''
      mv $out/bin/drcontrol.py $out/bin/drcontrol
    '';
  }
