#!/bin/bash
set -e
#set -x

TTYD_ARGS="--writable --exit-no-conn login"

# Check if this is the container's first run
if [ -f /etc/.firstrun ]; then
    # Create user account
    useradd -m -s /bin/bash "$USERNAME"

    # Add a password to the user
    echo "$USERNAME:$PASSWORD" | chpasswd

    # Allow access to sudo if permitted
    if [ "$SUDO_OK" == "true" ]; then
        usermod -aG sudo "$USERNAME"
	echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/10nopasswd
    fi
   
    # Fix Permissions on volume mount 
    if [[ -d "$DATA_DIR" ]]; then
	chown -R "$USERNAME:$USERNAME" "$DATA_DIR"
    fi

    # Prevent this from running again
    rm /etc/.firstrun
fi

# Optionally set a timezone
CURRENT_TZ=$(cat /etc/timezone)
if [ "$TZ" != "$CURRENT_TZ" ]; then
    echo "Setting timezone to $TZ"

    # delete symlink if it exists
    [ -f /etc/localtime ] && rm /etc/localtime

    # set timezone
    ln -s "/usr/share/zoneinfo/$TZ" /etc/localtime
    echo "$TZ" > /etc/timezone 
fi

# Auto login the user, if allowed
[ "$AUTOLOGIN" == "true" ] && TTYD_ARGS="$TTYD_ARGS -f $USERNAME"

# Start ttyd
exec ttyd $TTYD_ARGS "$@"

