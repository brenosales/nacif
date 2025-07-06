# Use the official Elixir image as base
FROM elixir:1.15-alpine

# Install build dependencies
RUN apk add --no-cache build-base git inotify-tools curl

# Set working directory
WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build environment
ENV MIX_ENV=dev

# Copy mix files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get

# Copy application code
COPY . .

# Expose port
EXPOSE 4000

# Set environment variables
ENV PHX_HOST=0.0.0.0
ENV PORT=4000

# Start the development server
CMD ["mix", "phx.server"] 