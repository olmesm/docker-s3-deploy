FROM python:alpine

WORKDIR /usr/app

RUN pip install awscli --upgrade

COPY scripts /usr/scripts

CMD sh /usr/scripts/deploy.sh
