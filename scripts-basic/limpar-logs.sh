#! /bin/sh
cd /var/log

for l in ls -p "|" grep /; do
	echo -n > $l & > /dev/null
	echo Zerando arquivo $l...
done
echo Limpeza dos arquivos de log concluída!
