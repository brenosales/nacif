#!/bin/bash

echo "Starting backend setup..."

# Check if database exists
if ! mix ecto.dump > /dev/null 2>&1; then
    echo "Database doesn't exist, creating..."
    mix ecto.create
    echo "Running migrations..."
    mix ecto.migrate
    echo "Seeding database..."
    mix run priv/repo/seeds.exs
else
    echo "Database exists, running migrations..."
    mix ecto.migrate
fi

echo "Starting Phoenix server..."
mix phx.server 