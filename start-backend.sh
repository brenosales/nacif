#!/bin/bash

echo "🚀 Starting Nacif API Backend..."

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to stop and remove existing containers
cleanup() {
    echo "🧹 Cleaning up existing containers..."
    docker compose down -v
}

# Function to start PostgreSQL containers
start_database() {
    echo "🐘 Starting PostgreSQL containers..."
    docker compose up -d postgres postgres_test
    
    # Wait for PostgreSQL to be ready
    echo "⏳ Waiting for PostgreSQL to be ready..."
    sleep 10
    
    # Check if PostgreSQL is ready
    until docker compose exec -T postgres pg_isready -U postgres; do
        echo "⏳ Waiting for PostgreSQL to be ready..."
        sleep 2
    done
    echo "✅ PostgreSQL is ready!"
}

# Function to setup backend
setup_backend() {
    echo "🔧 Setting up backend..."
    cd backend/nacif_api
    
    # Get dependencies
    echo "📦 Getting dependencies..."
    mix deps.get
    
    # Create database
    echo "🗄️ Creating database..."
    mix ecto.create
    
    # Run migrations
    echo "🔄 Running migrations..."
    mix ecto.migrate
    
    # Seed database
    echo "🌱 Seeding database..."
    mix run priv/repo/seeds.exs
    
    cd ../..
}

# Function to start the backend server
start_backend_server() {
    echo "🎯 Starting backend server..."
    
    # Start backend
    echo "🚀 Starting Phoenix server..."
    cd backend/nacif_api
    mix phx.server
}

# Function to cleanup on exit
cleanup_on_exit() {
    echo ""
    echo "🛑 Stopping backend..."
    docker compose down
    echo "✅ Backend stopped."
    exit 0
}

# Set up signal handlers
trap cleanup_on_exit SIGINT SIGTERM

# Main execution
check_docker
cleanup
start_database
setup_backend
start_backend_server 