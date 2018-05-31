FROM ubuntu:18.04

WORKDIR /kiwi

RUN apt update -y && \
    apt install python-flask -y && \
    useradd kiwi

COPY . /kiwi
   
RUN chown kiwi -R /kiwi

EXPOSE 5000

ENTRYPOINT ["/usr/bin/python", "/kiwi/simplesite.py"]
