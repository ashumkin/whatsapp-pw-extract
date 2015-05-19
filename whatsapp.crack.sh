#!/usr/bin/env sh

USERID="$1"
if test -z "$USERID"
then
    echo Please, pass USERID as the first argument >&2
    exit 1
fi
dd if=pw bs=1 skip=29 count=4 > pw_salt
hexdump -e '2/1 "%02x"' pw_salt
dd if=pw bs=1 skip=33 count=16 > pw_iv
dd if=pw bs=1 skip=49 count=20 > pw_ekey

echo c2991ec29b1d0cc2b8c3b7556458c298c29203c28b45c2973e78c386c395 | xxd -r -p > pbkdf2_pass.bin
echo -n "$USERID" | hexdump -e '2/1 "%02x"' | xxd -r -p >> pbkdf2_pass.bin

PBKDF2=./wa_pbkdf2
if ! test -f "$PBKDF2"
then
    make
fi
$PBKDF2 pw_salt 16 < pbkdf2_pass.bin > pbkdf2_key.bin
k=$(hexdump -e '2/1 "%02x"' pbkdf2_key.bin)
iv=$(hexdump -e '2/1 "%02x"' pw_iv)
openssl enc -aes-128-ofb -d -nosalt -in pw_ekey -K $k -iv $iv -out wa_password.key
base64 wa_password.key
