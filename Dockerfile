FROM dockhub.weetui.com/weetui/alpine/base-alpine:3.3
MAINTAINER Louis.Qiao <louis@weetui.com>

ENV HUGO_VERSION=0.17
RUN apk add --update wget ca-certificates && \
  cd /tmp/ && \
  wget http://wttools.oss-cn-beijing.aliyuncs.com/hugo/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  mv hugo*/hugo* /usr/bin/hugo && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*

COPY ./run.sh /run.sh

VOLUME /src
VOLUME /output

WORKDIR /src
CMD ["/run.sh"]

EXPOSE 1313