#!/bin/sh

OUTFILE_PATH="/tmp/out"
OUTFILE_TYPE=""
CONVERSION_PARAMS="-resize 100%"

alias echoerr='>&2 echo'

if [  $# -le 1 ]
then
	exit 1
fi

if [ $# -ge 3 ]
then
	OUTFILE_TYPE=$3
else
	OUTFILE_TYPE="jpg"
fi

case "$OUTFILE_TYPE" in
	jpeg|jpg)
		OUTFILE_PATH="${OUTFILE_PATH}.jpg"
		;;
	png)
		OUTFILE_PATH="${OUTFILE_PATH}.png"
		;;
	pdf)
		OUTFILE_PATH="${OUTFILE_PATH}.pdf"
		CONVERSION_PARAMS="-density 150 -page A4"
		;;
	*)
		exit 1
esac

touch $OUTFILE_PATH && chown imagemagick:imagemagick $OUTFILE_PATH
su - imagemagick -c "convert -strip ${CONVERSION_PARAMS} ${1} ${OUTFILE_PATH}"
cat $OUTFILE_PATH > $2