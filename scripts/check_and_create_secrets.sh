#!@bash@

SECRETS_DIR="$HOME/.config/nix-secrets"
SECRETS_FILE="$SECRETS_DIR/flake.nix"

if [ ! -f "$SECRETS_FILE" ]; then
  echo "I will create $SECRETS_FILE [y/N]"
  read answer
  case "$answer" in
    [yY]|[yY][eE][sS])
      echo "Creating $SECRETS_FILE from template..."
      mkdir -p "$SECRETS_DIR"
      cp @secrets_template@ "$SECRETS_FILE"
      chmod 600 "$SECRETS_FILE"  # User read/write only
      echo "✓ Secrets file created at $SECRETS_FILE"
      echo "⚠️  Remember to update the placeholder values with real secrets"
      ;;
    *)
      echo "Skipped creation of $SECRETS_FILE"
      ;;
  esac
else
  echo "$SECRETS_FILE already exists"
fi
