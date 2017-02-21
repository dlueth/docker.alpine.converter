#!/bin/sh

OUTFILE_PATH="/tmp/out"
OUTFILE_TYPE=""
CONVERSION_PARAMS="-strip"

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
		CONVERSION_PARAMS="${CONVERSION_PARAMS} -resize 100% -interlace Plane -sampling-factor: 4:2:0 -type Grayscale -quality 85%"
		;;
	png)
		OUTFILE_PATH="${OUTFILE_PATH}.png"
		CONVERSION_PARAMS="${CONVERSION_PARAMS} -resize 100% -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -type Grayscale"
		;;
	pdf)
		OUTFILE_PATH="${OUTFILE_PATH}.pdf"
		CONVERSION_PARAMS="${CONVERSION_PARAMS} -density 200 -page A4 -compress Zip -type Grayscale -quality 85"
		;;
	*)
		exit 1
esac

touch $OUTFILE_PATH && chown imagemagick:imagemagick $OUTFILE_PATH
su - imagemagick -c "convert ${CONVERSION_PARAMS} ${1} ${OUTFILE_PATH}"
cat $OUTFILE_PATH > $2