FROM ubuntu:latest
WORKDIR /Lab_2
COPY script.sh /Lab_2/script.sh
RUN chmod +x /Lab_2/script.sh
VOLUME ["/shared"]
ENTRYPOINT ["/Lab_2/script.sh"]