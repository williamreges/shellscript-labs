#!bin/bash

echo "======================================"
echo "Instalando Certificados…"
echo "======================================"

for FILE in $(ls ./certs/ -F | grep -v '/$'); do
ALIAS=$(echo $FILE | cut -d "." -f 1)

echo $ALIAS
echo "Instalando certificado $FILE"
"../bin/keytool" -import -trustcacerts -alias $ALIAS -file ./certs/"$FILE" -keystore "../lib/security/cacerts" -storepass changeit -noprompt
done

echo
echo
echo "===================================="
echo "Fim instalacao"
echo "===================================="
sleep 3