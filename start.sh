#!/bin/bash

echo "🚀 Starting Nacif API Full Stack Application..."

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

# Function to setup frontend
setup_frontend() {
    echo "🔧 Setting up frontend..."
    cd frontend
    
    # Install dependencies
    echo "📦 Installing dependencies..."
    npm install
    
    cd ..
}

# Function to start the application
start_application() {
    echo "🎯 Starting application..."
    
    # Start backend in background
    echo "🚀 Starting backend server..."
    cd backend/nacif_api
    mix phx.server &
    BACKEND_PID=$!
    cd ../..
    
    # Start frontend in background
    echo "🚀 Starting frontend server..."
    cd frontend
    npm start &
    FRONTEND_PID=$!
    cd ..
    
    echo "✅ Application started successfully!"
    echo "📱 Frontend: http://localhost:3000"
    echo "🔌 Backend API: http://localhost:4000"
    echo "🗄️ PostgreSQL: localhost:5432"
    echo ""
    echo "Press Ctrl+C to stop the application"
    
    # Wait for user to stop
    wait $BACKEND_PID $FRONTEND_PID
}

# Function to cleanup on exit
cleanup_on_exit() {
    echo ""
    echo "🛑 Stopping application..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    docker compose down
    echo "✅ Application stopped."
    exit 0
}

# Set up signal handlers
trap cleanup_on_exit SIGINT SIGTERM

# Main execution
check_docker
cleanup
start_database
setup_backend
setup_frontend
start_application 