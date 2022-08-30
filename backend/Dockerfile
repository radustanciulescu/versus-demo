FROM tiangolo/meinheld-gunicorn:python3.7-alpine3.8
ENV PYTHONUNBUFFERED 1
RUN set -e; \
        apk add --no-cache --virtual .build-deps \
                gcc \
                libc-dev \
                linux-headers \
                mariadb-dev \
                python3-dev \
                postgresql-dev \
                mysql-client \
                jq \
        ;

RUN mkdir /backend
WORKDIR /backend

COPY requirements.txt /backend/
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install boto3
RUN pip install awscli
RUN pip install python-decouple


COPY . /backend/
#RUN ["chmod", "+x", "./dbsecretvars.sh"]
EXPOSE 8080
CMD ["/bin/bash"]

ENTRYPOINT gunicorn -w 4 main.wsgi:application -b 0.0.0.0:8080
