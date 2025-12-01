# Build stage
FROM debian:bullseye-slim AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl git unzip xz-utils zip libglu1-mesa \
  && rm -rf /var/lib/apt/lists/*

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter
ENV PATH="/flutter/bin:${PATH}"

# Skip gradle setup, precache web tools only
RUN flutter config --enable-web --no-analytics
RUN flutter precache --web --no-android --no-ios --no-linux --no-windows --no-macos --no-fuchsia

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

COPY . .
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