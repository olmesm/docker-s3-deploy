FROM python:alpine

WORKDIR /usr/app

RUN pip install awscli --upgrade

COPY scripts scripts

CMD sh scripts/deploy.sh
