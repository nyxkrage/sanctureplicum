{ pkgs
, lib
, binutils
, editorconfig-core-c
, emacs
, emacs-all-the-icons-fonts
, fd
, gnutls
, imagemagick
, libgccjit
, libvterm
, makeWrapper
, ripgrep
, runCommandNoCC
, sqlite
, zstd
, ...
}:
runCommandNoCC "emacs" { nativeBuildInputs = [ makeWrapper ]; } ''
  mkdir -p $out/bin
  cp ${emacs}/bin/emacsclient $out/bin
  for res in 16 32 48 64 128; do
    mkdir -p "$out/share/icons/hicolor/''${res}x''${res}/apps"
    icon="${emacs}/share/icons/hicolor/''${res}x''${res}/apps/emacs.png"
    if [ -e "$icon" ]; then
      ln -s "$icon" "$out/share/icons/hicolor/''${res}x''${res}/apps/emacs.png"
    fi
  done
  if [ -e "${emacs}/share/icons/hicolor/scalable/apps/emacs.png" ]; then
    ln -s "${emacs}/share/icons/hicolor/scalable/apps/emacs.png" "$out/share/icons/hicolor/scalable/apps/emacs.png"
  fi
  makeWrapper ${emacs}/bin/emacs $out/bin/emacs \
    --set DOOMDIR "~/.config/doom" \
    --set DOOMLOCALDIR "~/.config/doom-local" \
    --set DOOMPROFILELOADFILE "~/.config/doom-local/profiles.el" \
    --set EMACS "${emacs}/bin/emacs" \
    --prefix _PATH : ${lib.makeBinPath [
      # Dependencies
      (ripgrep.override { withPCRE2 = true; })
      binutils
      editorconfig-core-c
      emacs-all-the-icons-fonts
      fd
      gnutls
      imagemagick
      libgccjit
      libvterm
      sqlite
      zstd
    ]}
''
