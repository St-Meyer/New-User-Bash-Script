#!/bin/bash

USER=$1
shift
PUB_KEY=$2
shift
HOSTS=($@)

KEY_DIR="/home/$USER/.ssh"
LOCAL_PUBKEY=$(cat "$PUB_KEY")

echo "USER: $USER"
echo "PUB KEY: $LOCAL_PUBKEY"
echo "HOSTS: ${HOSTS[*]}"

# Prüfen, ob User bereits existiert.
if id "$USER" >/dev/null 2>&1; then
        echo "user already exists"
else
        echo "creating $USER on headnode..."
        # Benutzer ohne Passwort anlegen
        adduser --disabled-password --gecos "" "$USER"
fi

# .ssh-Verzeichnis anlegen
mkdir -p "$KEY_DIR"
chown "$USER:$USER" "$KEY_DIR"
chmod 700 "$KEY_DIR"

# Lokalen Public Key einfügen, um auf den Headnode zu kommen
echo "$LOCAL_KEY" >> "$KEY_DIR/authorized_keys"
chown "$USER:$USER" "KEY_DIR/authorized_keys"
chmod 600 "$KEY_DIR/authorized_keys"

# SSH-KEypaar für neuen Benutzer auf Headnode erzeugen
if [ ! -f "$KEY_DIR/id_ed25519" ]; then
        echo "generate SSH_Key für $USER on Headnode"
        sudo -u "$USER" ssh-keygen -t ed25519 -N "" -f "$KEY_DIR/id_ed25519"
fi

# Public Key lesen
PUBKEY_CONTENT=$(cat "$KEY_DIR/id_ed25519.pub")

# Prüfen, ob Zugriff auf Node möglich ist und Key eintragen
SSH_OPTS="-o BatchMode=yes -o ConnectTimeout=3 -o StrictHostKeyChecking=no"

echo "start key distribution"

for HOST in "${HOSTS[@]}"; do
        echo  "Check access to $HOST..."

        # Key wird auf den verfügbaren Nodes installiert
        if ssh $SSH_OPTS root@$HOST "exit" 2>/dev/null; then
                echo "Access avaiable, install key..."
                ssh root@"$HOST" "bash -s" <<EOF
USER="$USER"
PUBKEY='$PUBKEY_CONTENT'

#Benutzer anglegen, falls nicht vorhanden
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
 
