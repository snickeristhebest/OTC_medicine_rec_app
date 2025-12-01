# Build stage - use official Flutter image
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY . .

# Build web app
RUN flutter config --enable-web --no-analytics
RUN flutter pub get
RUN flutter build web --release

# Run stage
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

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