# Build stage - not needed for static HTML, but included for future expansion
FROM node:18-alpine AS builder

WORKDIR /app

# Copy all files
COPY . .

# No build step needed for static HTML; if you add build tools later, add them here


# Runtime stage
FROM nginx:alpine

# Remove default nginx config
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy project files to nginx html directory
COPY --from=builder /app /usr/share/nginx/html

# Copy nginx template config
COPY nginx.template.conf /etc/nginx/templates/default.conf.template

# Install envsubst utility (comes with gettext)
# Already included in nginx:alpine

# Expose default port (Railway's PORT env var will override at runtime)
EXPOSE 8080

# Use nginx default entrypoint which handles template substitution via /docker-entrypoint.d/
# The template.conf file will be processed and placed at /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]
