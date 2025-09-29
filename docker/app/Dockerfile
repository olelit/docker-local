FROM php:8.1-fpm

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    git \
    unzip \
    libzip-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    ca-certificates \
    gnupg \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_pgsql \
        pgsql \
        zip \
        exif \
        gd \
        soap \
    && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && npm install -g yarn \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} hostgroup \
    && useradd -u ${USER_ID} -g hostgroup -m -s /bin/bash hostuser

COPY docker/app/php.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www
COPY /src .

RUN git config --global --add safe.directory /var/www/vendor/mad-web/laravel-enum \
    && git config --global --add safe.directory /var/www/vendor/mad-web/laravel-initializer

USER hostuser

CMD ["php-fpm"]
