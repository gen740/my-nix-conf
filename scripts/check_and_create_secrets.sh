#!@bash@

if [ ! -f /opt/secrets/flake.nix ]; then
  echo "I will create /opt/secrets/flake.nix [y/N]"
  read answer
  case "$answer" in
    [yY]|[yY][eE][sS])
      echo "Creating /opt/secrets/flake.nix from template..."
      sudo mkdir -p /opt/secrets
      sudo cp @secrets_template@ /opt/secrets/flake.nix
      sudo chmod 644 /opt/secrets/flake.nix
      ;;
    *)
      echo "Skipped creation of /opt/secrets/flake.nix"
      ;;
  esac
else
  echo "/opt/secrets/flake.nix already exists"
fi
