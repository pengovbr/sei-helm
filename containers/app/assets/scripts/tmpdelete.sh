#/bin/sh

find /var/lib/sei/tmpfiles -type f -mmin +60 -delete -exec echo "Deletando arquivo tmp antigo: {}" \;