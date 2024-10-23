# Usar a imagem oficial do Alpine como base
FROM alpine:latest

# Instalar dependências necessárias
RUN apk add --no-cache \
    gcc \
    g++ \
    make \
    libstdc++ \
    pcre-dev \
    zlib-dev \
    openssl-dev \
    git \
    curl \
    nginx \
    ffmpeg

# Clonar o repositório do módulo RTMP
RUN git clone https://github.com/arut/nginx-rtmp-module.git /nginx-rtmp-module

# Baixar e compilar o Nginx com o módulo RTMP e o módulo HTTP MP4
RUN curl -O http://nginx.org/download/nginx-1.25.1.tar.gz && \
    tar -zxvf nginx-1.25.1.tar.gz && \
    cd nginx-1.25.1 && \
    ./configure --with-http_ssl_module --with-http_mp4_module --add-module=/nginx-rtmp-module && \
    make && \
    make install && \
    cd .. && \
    rm -rf nginx-1.25.1 nginx-1.25.1.tar.gz /nginx-rtmp-module

# Criar diretórios necessários
RUN mkdir -p /usr/share/nginx/html/videos /hls/live

# Copiar o arquivo de configuração do Nginx
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# Expor as portas necessárias
EXPOSE 1935 8080

# Copiar o código da aplicação (index.php e outros arquivos)
COPY ../index.php /usr/share/nginx/html/index.php

# Copiar o vídeo para o container
COPY ../videos/video.mp4 /usr/share/nginx/html/videos/video.mp4

# Gerar os arquivos .m3u8 e .ts a partir do vídeo .mp4
RUN ffmpeg -i /usr/share/nginx/html/videos/video.mp4 \
    -codec: copy -start_number 0 -hls_time 10 -hls_list_size 0 \
    -f hls /usr/share/nginx/html/videos/video.m3u8

# Iniciar o Nginx em primeiro plano
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]