{ stdenv, fetchurl, libxml2Python, libxslt, makeWrapper
, pyserial, pygtk }:

stdenv.mkDerivation rec {
  pname = "chirp-daily";
  version = "20190905";

  src = fetchurl {
    url = "https://trac.chirp.danplanet.com/chirp_daily/daily-${version}/${pname}-${version}.tar.gz";
    sha256 = "01xglzzl94wzkd2d8zmyv6s1xqsfc7biph15k0ap8rlf98874rlf";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    pyserial pygtk libxml2Python libxslt
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/chirp
    cp -r . $out/share/chirp/
    ln -s $out/share/chirp/chirpw $out/bin/chirpw

    for file in "$out"/bin/*; do
      wrapProgram "$file" \
        --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with stdenv.lib; {
    description = "A free, open-source tool for programming your amateur radio";
    homepage = https://chirp.danplanet.com/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.the-kenny ];
  };
}
