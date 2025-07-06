#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to check if Docker Compose is available
check_docker_compose() {
    if ! docker compose version > /dev/null 2>&1; then
        print_error "Docker Compose is not available. Please install Docker Compose and try again."
        exit 1
    fi
    print_success "Docker Compose is available"
}

# Function to stop and remove existing containers
cleanup() {
    print_status "Cleaning up existing containers..."
    docker compose down -v 2>/dev/null || true
    print_success "Cleanup completed"
}

# Function to build and start services
start_services() {
    print_status "Building and starting services..."
    
    # Build images
    print_status "Building Docker images..."
    docker compose build --no-cache
    
    if [ $? -ne 0 ]; then
        print_error "Failed to build Docker images"
        exit 1
    fi
    
    # Start services
    print_status "Starting services..."
    docker compose up -d
    
    if [ $? -ne 0 ]; then
        print_error "Failed to start services"
        exit 1
    fi
}

# Function to wait for services to be ready
wait_for_services() {
    print_status "Waiting for services to be ready..."
    
    # Wait for PostgreSQL
    print_status "Waiting for PostgreSQL..."
    timeout=60
    counter=0
    while ! docker compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; do
        sleep 2
        counter=$((counter + 2))
        if [ $counter -ge $timeout ]; then
            print_error "PostgreSQL failed to start within $timeout seconds"
            exit 1
        fi
    done
    print_success "PostgreSQL is ready"
    
    # Wait for backend
    print_status "Waiting for backend API..."
    timeout=300
    counter=0
    while ! curl -s http://localhost:4000/api/ > /dev/null 2>&1; do
        sleep 10
        counter=$((counter + 10))
        if [ $counter -ge $timeout ]; then
            print_error "Backend API failed to start within $timeout seconds"
            print_status "Checking backend logs..."
            docker compose logs backend
            print_status "Trying to restart backend..."
            docker compose restart backend
            sleep 30
            if curl -s http://localhost:4000/api/ > /dev/null 2>&1; then
                print_success "Backend API is now ready after restart"
                break
            else
                print_error "Backend API still not responding after restart"
                exit 1
            fi
        fi
        print_status "Still waiting for backend... ($counter/$timeout seconds)"
    done
    print_success "Backend API is ready"
    
    # Wait for frontend
    print_status "Waiting for frontend..."
    timeout=60
    counter=0
    while ! curl -s http://localhost:3000 > /dev/null 2>&1; do
        sleep 2
        counter=$((counter + 2))
        if [ $counter -ge $timeout ]; then
            print_error "Frontend failed to start within $timeout seconds"
            exit 1
        fi
    done
    print_success "Frontend is ready"
}

# Function to display service status
show_status() {
    print_status "Service Status:"
    docker compose ps
    
    echo ""
    print_success "Application is running!"
    echo ""
    echo -e "${GREEN}Access Points:${NC}"
    echo -e "  Frontend: ${BLUE}http://localhost:3000${NC}"
    echo -e "  Backend API: ${BLUE}http://localhost:4000${NC}"
    echo -e "  PostgreSQL: ${BLUE}localhost:5432${NC}"
    echo ""
    echo -e "${GREEN}Test Credentials:${NC}"
    echo -e "  Email: ${YELLOW}test@example.com${NC}"
    echo -e "  Password: ${YELLOW}password123${NC}"
    echo ""
    echo -e "${GREEN}Development Features:${NC}"
    echo -e "  Hot reloading enabled for both frontend and backend"
    echo -e "  Code changes will automatically reload"
    echo ""
    echo -e "${GREEN}Useful Commands:${NC}"
    echo -e "  View logs: ${YELLOW}docker compose logs -f${NC}"
    echo -e "  Stop services: ${YELLOW}docker compose down${NC}"
    echo -e "  Restart services: ${YELLOW}docker compose restart${NC}"
    echo ""
    print_warning "Press Ctrl+C to stop all services"
}

# Function to handle cleanup on exit
cleanup_on_exit() {
    echo ""
    print_status "Stopping services..."
    docker compose down
    print_success "Services stopped"
    exit 0
}

# Set up signal handlers
trap cleanup_on_exit SIGINT SIGTERM

# Main execution
echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  Nacif API Docker${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Check prerequisites
check_docker
check_docker_compose

# Cleanup and start
cleanup
start_services
wait_for_services
show_status

# Keep the script running
while true; do
    sleep 1
done 