# Build Stage (frontend)
FROM node:21.1.0 AS build
# Make the working directory /app
WORKDIR /app
# install the dependencies
COPY ./client/package.json ./client/
WORKDIR /app/client
RUN npm install
# copy the source code
COPY ./client/ ./
# Build the static files
RUN ls src
RUN npm run build

# Production Stage
FROM nginx:latest
COPY --from=build /app/client/dist/ /var/www/html/dist/
# Custom Nginx configuration for reverse proxying
COPY nginx.conf /etc/nginx/
EXPOSE 80
CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
