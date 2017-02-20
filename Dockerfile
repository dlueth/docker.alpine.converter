FROM alpine:3.5

LABEL maintainer="Dirk Lüth <info@qoopido.com>" \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.name="Qoopido Docker Converter (Alpine)" \
      org.label-schema.url="https://github.com/dlueth/docker.alpine.converter" \
      org.label-schema.vcs-url="https://github.com/dlueth/docker.alpine.converter.git"

# Set environment variables
	ENV IMAGEMAGICK_VERSION "7.0.4-10"
	ENV CFLAGS "-Os -fomit-frame-pointer"
	ENV CXXFLAGS "${CFLAGS}"
	ENV CPPFLAGS "${CFLAGS}"
	ENV LDFLAGS "-Wl,--as-needed"

# Copy files & directories
	COPY entrypoint.sh /entrypoint.sh

# Alter permissions
	RUN chmod +x /entrypoint.sh

# create user and group
	RUN adduser -s /bin/sh -g imagemagick -D imagemagick \
		&& exit 0 ; exit 1

# Compile & install ImageMagick
	RUN apk update \
        && apk upgrade \
        && apk add --update --no-cache zlib libpng libjpeg-turbo freetype fontconfig perl ghostscript libwebp libtool tiff lcms2 libxml2 \
		&& apk add --update --no-cache --virtual .temporary build-base curl xz zlib-dev libpng-dev libjpeg-turbo-dev freetype-dev fontconfig-dev perl-dev ghostscript-dev libwebp-dev tiff-dev lcms2-dev libxml2-dev \
		# Install ImageMagick
		&& mkdir -p /tmp/ImageMagick \
		&& cd /tmp/ImageMagick \
		&& curl -fsSL -o ImageMagick.tar.gz https://www.imagemagick.org/download/ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz \
		&& tar xvzf ImageMagick.tar.gz \
		&& cd ImageMagick-${IMAGEMAGICK_VERSION} \
		&& ./configure --prefix=/usr --sysconfdir=/etc --mandir=/usr/share/man --infodir=/usr/share/info --without-threads --without-x --with-tiff --with-gslib --with-lcms --with-gs-font-dir=/usr/share/fonts/Type1 --with-modules --with-xml --with-fontconfig --with-freetype --with-jpeg --with-png \
		&& make -j1 \
		&& make install \
		&& ldconfig /usr/local/lib \
		&& convert -version \
		# Cleanup
		&& apk del .temporary \
		&& rm -rf /var/cache/apk/* /tmp/*

# Settings
	ENTRYPOINT [ "/entrypoint.sh" ]
