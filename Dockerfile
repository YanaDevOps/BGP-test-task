FROM alpine:latest
WORKDIR /test
# Deleting cache to make the lightwaight image
RUN apk update && apk add --no-cache frr && rm -rf /var/cache/apk/* && mkdir /test/scripts
# Copy the script for FRR set up
COPY entrypoint.sh ./scripts/entrypoint.sh
RUN chmod +x ./scripts/entrypoint.sh
# Execute our script to restart the container
ENTRYPOINT [ "/test/scripts/entrypoint.sh"]