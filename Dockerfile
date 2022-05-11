FROM ubuntu:focal-20210827

ARG DEBIAN_FRONTEND=noninteractive
ARG STACK_VERSION=2.7.3

ENV LANG=C.UTF-8

# Make sure this path includes initdb for the usage of tmp-postgres
ENV PATH=/usr/lib/postgresql/13/bin/:$PATH

RUN apt-get update -y && apt-get install -y gnupg curl ca-certificates
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
RUN echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list

COPY install.sh /
RUN /install.sh
