# Stage 1: Build the Flutter web app
FROM cirrusci/flutter:stable AS build

WORKDIR /app

COPY . .

# Pass the API base URL as a build argument
ARG API_BASE_URL=/cube10-pensil-api.darkube.app/

RUN flutter pub get

# Build the web app with the API base URL
RUN flutter build web --dart-define=API_BASE_URL=${API_BASE_URL}

# Stage 2: Serve with Nginx
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
