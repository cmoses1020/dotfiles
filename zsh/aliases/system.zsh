# SYSTEM

function fucking_discord() {
    LATEST_DISCORD_DEB=$(ls -1t ~/Downloads/discord-*.deb | head -n 1)

    if [[ -z "$LATEST_DISCORD_DEB" ]]; then
        echo "No Discord .deb file found in ~/Downloads."
        return 1
    fi

    echo "Installing Discord from $LATEST_DISCORD_DEB..."
    sudo apt install -y "$LATEST_DISCORD_DEB"

    if [[ $? -eq 0 ]]; then
        echo "Discord has been updated successfully."
    else
        echo "Failed to install Discord."
        return 1
    fi
}
