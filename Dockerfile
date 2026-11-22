# 静态站点镜像：Nginx 直接托管已构建的圣诞树页面
FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="merry-christmas" \
      org.opencontainers.image.description="Three.js 3D 圣诞树交互场景（含 MediaPipe 手势控制）" \
      org.opencontainers.image.version="0.1"

# 静态产物（index.html / assets / audio / mediapipe）
COPY . /usr/share/nginx/html

# 确保 wasm、tflite 等资源按正确类型返回，并关闭目录列表
RUN printf 'server {\n\
    listen 80;\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    autoindex off;\n\
\n\
    types {\n\
        text/html html;\n\
        text/css css;\n\
        text/javascript js;\n\
        application/wasm wasm;\n\
        application/json json;\n\
        audio/mpeg mp3;\n\
        image/svg+xml svg;\n\
        image/png png;\n\
        image/jpeg jpg jpeg;\n\
        application/octet-stream tflite data binarypb;\n\
    }\n\
\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/index.html || exit 1
