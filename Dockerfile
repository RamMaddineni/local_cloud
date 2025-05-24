# Use an official Nginx runtime as a parent image
FROM nginx:alpine

# Copy the local index.html to the nginx html directory
COPY index.html /usr/share/nginx/html

# Copy the custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Inform Docker that the container is listening on port 8080
EXPOSE 8080

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
