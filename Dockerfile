FROM alpine:latest
RUN apk --no-cache add curl ca-certificates bash dos2unix
RUN curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x /usr/local/bin/kubectl
COPY update.sh /bin/
RUN dos2unix /bin/update.sh

ENTRYPOINT ["/bin/bash"]
CMD ["/bin/update.sh"]
