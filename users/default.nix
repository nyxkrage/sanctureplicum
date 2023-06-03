{ ... }: {
  carsten = {
    fullName = "Carsten Kragelund";
    hashedPassword = "$y$j9T$oL/jNqI1yz65OuUnJvpCn1$MC7.xSyvprru7QmqQVsGyBKZf2b4w7R7U.TmfzSBY39";
    groups = [
      "networkmanager" # Use networks
      "wheel" # Sudoer
      "vboxusers" # VirtualBox
      "docker" # Containers
    ];
  }
}