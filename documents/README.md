# StreamDeVideo
## Requisitos
- Docker
- PHP 7.4+
- MySQL
- laragon (ou outro ambiente php)

## Tecnologias
- Docker Compose
- PHP
- NGINX
- MySQL
- JavaScript (para o frontend)
- Bootstrap (opcional para estilização)

## Protocolos
- RTMP (Real Time Messaging Protocol)
- HLS (HTTP Live Streaming)

## Configuração e Execução
### 1. Navegar até a pasta
- cd database 

### 2. Construção da imagem com o dockerfile
- docker build -t stream-nginx-rtmp:latest . 

### 3. Rodar o servidor
- docker run -d -p 1935:1935 -p 8081:8081 --name container-rtmp stream-nginx-rtmp:latest 

### 4. Rodar Stream
- docker exec -it my-nginx-container ffmpeg -re -i /usr/share/nginx/html/videos/video.mp4 -c copy -f flv rtmp://localhost/live/stream

### 5. Parar o container, apagar o container e imagem
- docker stop container-rtmp
- docker rm container-rtmp
- docker rmi multismv-nginx-rtmp:latest