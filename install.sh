#!/bin/bash

# Set variables
INSTALL_DIR="$HOME/.clipboard-logger"
SERVICE_FILE="$HOME/.config/systemd/user/clipboard-logger.service"

# Create folders
mkdir -p "$INSTALL_DIR"
mkdir -p "$(dirname "$SERVICE_FILE")"

# Copy files
cp clipboard_logger.py "$INSTALL_DIR/"
cp clipboard-logger.service "$SERVICE_FILE"

# Replace USERNAME with real username
sed -i "s|USERNAME|$USER|g" "$SERVICE_FILE"

# Install dependencies
pip install --user pyperclip

# Enable linger to run systemd user service after logout/reboot
loginctl enable-linger "$USER"

# Enable and start the service
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now clipboard-logger.service

# Create keyboard shortcut using gsettings (optional)
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[\
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/open-copy-log/']"

mkdir -p ~/.config/autokey
CUSTOM_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/open-copy-log/"
gsettings set $CUSTOM_PATH name "Open Copy Log"
gsettings set $CUSTOM_PATH command "gedit /tmp/copy.txt"
gsettings set $CUSTOM_PATH binding "<Control><Alt>c"

echo "✅ Installed successfully. Clipboard log will be saved in /tmp/copy.txt"
