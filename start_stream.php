<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $command = "docker exec my-nginx-container ffmpeg -re -stream_loop -1 -i /usr/share/nginx/html/videos/video.mp4 -c copy -f flv rtmp://localhost/live/stream";
    $output = shell_exec($command . " 2>&1"); 
    echo "<pre>$output</pre>";
}