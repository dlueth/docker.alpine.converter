#!/bin/sh

if [ $# -le 1 ]
then
	exit 1
fi

OUTFILE_PATH="/tmp/out"
CONVERSION_PARAMS="-strip -quiet"
INFILE_TYPE=$(su - imagemagick -c "identify -quiet ${1} | head -n 1 | awk '{ print \$2 }'")
INFILE_PAGES=$(su - imagemagick -c "identify -quiet -format '%n' $1")

case "$INFILE_TYPE" in
	JPEG|JPG|PNG|BMP|BMP2|BMP3)
		OUTFILE_PATH="${OUTFILE_PATH}.jpg"
		CONVERSION_PARAMS="${CONVERSION_PARAMS} -resize 100% -interlace Plane -set sampling-factor: 4:2:0 -type Grayscale -quality 75%"
		;;
	PBM|PDF|TIFF)
		if [ "$INFILE_PAGES" -gt 1 ]
		then
			OUTFILE_PATH="${OUTFILE_PATH}.pdf"
			CONVERSION_PARAMS="${CONVERSION_PARAMS} -density 200 -page A4 -compress Zip -type Grayscale -quality 75"
		else
			OUTFILE_PATH="${OUTFILE_PATH}.jpg"
			CONVERSION_PARAMS="${CONVERSION_PARAMS} -density 200 -resize 100% -interlace Plane -set sampling-factor: 4:2:0 -type Grayscale -quality 75%"
		fi
		;;
	*)
		exit 1
esac

touch ${OUTFILE_PATH} && chown imagemagick:imagemagick ${OUTFILE_PATH}
su - imagemagick -c "convert ${CONVERSION_PARAMS} ${1} ${OUTFILE_PATH}"
cat ${OUTFILE_PATH} > $2