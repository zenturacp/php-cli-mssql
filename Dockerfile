FROM php:7.3-cli

LABEL maintainer="christian.pedersen@zentura.dk"

ENV ACCEPT_EULA=Y

# Set INI fil
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# Microsoft SQL Server Prerequisites
RUN apt-get update \
    && apt-get -y --no-install-recommends install gnupg2 \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list \
        > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get install -y --no-install-recommends \
        locales \
        apt-transport-https \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        unixodbc-dev \
        msodbcsql17

# Enable SQL SRV Plugin
RUN docker-php-ext-install mbstring pdo pdo_mysql \
    && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv
