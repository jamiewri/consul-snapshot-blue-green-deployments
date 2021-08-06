FROM consul:1.10.1
ENV PYTHONUNBUFFERED=1
RUN echo -e "http://nl.alpinelinux.org/alpine/v3.5/main\nhttp://nl.alpinelinux.org/alpine/v3.5/community" > /etc/apk/repositories
RUN apk add --update --no-cache python
