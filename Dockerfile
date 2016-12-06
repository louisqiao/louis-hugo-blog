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


# Create working directory
RUN mkdir /usr/share/blog
WORKDIR /usr/share/blog

# Expose default hugo port
EXPOSE 1313

# Automatically build site
ONBUILD ADD ../louis-hugo-blog/ /usr/share/blog
ONBUILD RUN hugo -t=next -d /usr/share/nginx/html/ --config=/usr/share/blog/louis-hugo-blog/config.toml

# By default, serve site
ENV HUGO_BASE_URL http://localhost:1313
CMD hugo server -b ${HUGO_BASE_URL} --bind=0.0.0.0

