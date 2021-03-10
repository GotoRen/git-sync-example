## Contents Cloner Image
FROM alpine:latest
RUN apt-get update && apt-get install -y git
COPY ./contents-puller /contents-puller
RUN chmod a+x /contents-puller
WORKDIR /
CMD ["/contents-puller"]