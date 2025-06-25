#!/bin/bash

USER=$1
shift
HOSTS=($@)
KEY_DIR="/home/$USER/.ssh"
PUB_KEY="$KEY_DIR/id_ed25519.pub"
PRIV_KEY="$KEY_DIR/id_ed25519"
AUTHORIZED_KEYS="$KEY_DIR/authorized_keys"

echo "USER: $USER"
echo "HOSTS: ${HOSTS[*]}"

# Prüfen, ob User bereits existiert.
if id "$USER" >/dev/null 2>&1; then
        echo "user already exists"
else
        echo "creating $USER on headnode..."
        # Benutzer ohne Passwort anlegen
        adduser --disabled-password --gecos "" "$USER"

        # .ssh-Verzeichnis anlegen
        mkdir -p "$KEY_DIR"
        chown -R "$USER:$USER" "/home/$USER"
        chmod 755 "/home/$USER"
        chmod 700 "$KEY_DIR"

        # Key wird generiert
        if [ ! -f "$PRIV_KEY" ]; then
                sudo -u "$USER" ssh-keygen -t ed25519 -N "" -f "$PRIV_KEY"
                chmod 600 "$PRIV_KEY"
                chmod 644 "$PUB_KEY"
        fi

        PUBKEY_CONTENT=$(cat "$PUB_KEY")
        echo "$PUBKEY_CONTENT" >> "$AUTHORIZED_KEYS"
        chown "$USER:$USER" "$AUTHORIZED_KEYS"
        chmod 600 "$AUTHORIZED_KEYS"
fi

        # Prüfen, ob Zugriff auf Node möglich ist

SSH_OPTS="-o BatchMode=yes -o ConnectTimeout=3 -o StrictHostKeyChecking=no"

echo "start checking and key distribution"
echo "Pubkey_content: $PUBKEY_CONTENT"

for HOST in "${HOSTS[@]}"; do
        echo  "Check access to $HOST..."

        # Key wird auf den verfügbaren Nodes installiert
        if ssh $SSH_OPTS root@$HOST "exit" 2>/dev/null; then
                echo "Access avaiable, install key..."
                ssh root@"$HOST" "bash -s" <<EOF
USER="$USER"
PUBKEY='$PUBKEY_CONTENT'

if id "\$USER" &>/dev/null; then
        echo "User '\$USER' bereits vorhanden auf \$HOST"
else
        adduser --disabled-password --gecos "" "\$USER"
fi

SSH_DIR="/home/\$USER/.ssh"
mkdir -p "\$SSH_DIR"
touch "\$SSH_DIR/authorized_keys"
grep -qxF "\$PUBKEY" "\$SSH_DIR/authorized_keys" || echo "\$PUBKEY" >> "\$SSH_DIR/authorized_keys"
chown -R "\$USER:\$USER" "/home/\$USER"
chmod 700 "\$SSH_DIR"
chmod 600 "\$SSH_DIR/authorized_keys"
EOF
                echo "User and Key added on $HOST"
        else
                echo "No Access to $HOST - jump forward"
fi

done

echo "finished. User added on all accessable nodes"
 
