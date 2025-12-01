# Build stage
FROM debian:bullseye AS build

RUN apt-get update && apt-get install -y \
  curl unzip xz-utils zip libglu1-mesa git

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

WORKDIR /app
COPY . .
RUN flutter build web

# Run stage
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

# Create nginx config for Flutter
RUN cat > /etc/nginx/conf.d/default.conf <<'EOF'
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;
    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]