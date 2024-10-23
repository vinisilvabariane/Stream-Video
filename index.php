<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Transmissão ao Vivo</title>
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
</head>
<body>
    <h1>Transmissão ao Vivo</h1>
    <button id="startStream">Iniciar Transmissão</button>
    <video id="video" controls width="640" height="360" style="display: none;">
        Seu navegador não suporta o elemento de vídeo.
    </video>

    <script>
        document.getElementById('startStream').addEventListener('click', function() {
            fetch('start_stream.php', { method: 'POST' })
                .then(response => response.text())
                .then(data => {
                    console.log(data);
                    document.getElementById('video').style.display = 'block';
                    startVideo();
                })
                .catch(error => console.error('Erro:', error));
        });

        function startVideo() {
            if (Hls.isSupported()) {
                var video = document.getElementById('video');
                var hls = new Hls();
                hls.loadSource('http://localhost:8080/hls/stream.m3u8');
                hls.attachMedia(video);
                hls.on(Hls.Events.MANIFEST_PARSED, function () {
                    video.play();
                });
            } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
                video.src = 'http://localhost:8080/hls/stream.m3u8';
                video.addEventListener('loadedmetadata', function () {
                    video.play();
                });
            }
        }
    </script>
</body>
</html>