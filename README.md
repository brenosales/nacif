# Fullstack User Management System

This is a complete fullstack application with a Phoenix/Elixir backend API and a React frontend, fully dockerized with hot reloading for development.

## Quick Start

### Option 1: Docker (Recommended)
```bash
# Start the entire application stack with hot reloading
./docker-start.sh
```

### Option 2: Manual Docker Compose
```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down
```

### Option 3: Manual Setup
```bash
# Use the provided start script
./start.sh
```

## Docker Setup

The application runs in a development environment with:
- **Frontend**: React development server with hot reloading
- **Backend**: Phoenix development server with hot reloading
- **Database**: PostgreSQL with persistent storage
- **Networking**: All services connected via Docker network

## Access Points

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:4000
- **PostgreSQL**: localhost:5432

## Test Credentials

A test user is automatically created with these credentials:
- **Email**: test@example.com
- **Password**: password123

## Features

### Frontend (React)
- User login with email/password
- User registration
- View current user profile
- Update user information (name, email, CEP)
- Delete user account
- Token-based authentication
- Simple, functional UI

### Backend (Phoenix/Elixir)
- RESTful API endpoints
- JWT token authentication
- User CRUD operations
- PostgreSQL database
- Password hashing with bcrypt
- Input validation

## API Endpoints

- `POST /api/login` - User authentication
- `POST /api/users` - Create new user
- `GET /api/users/email/:email` - Get user by email
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

## File Structure

```
fullstack-app/
├── backend/
│   ├── nacif_api/          # Phoenix API
│   ├── Dockerfile          # Backend image with hot reloading
│   └── .dockerignore       # Backend build exclusions
├── frontend/               # React application
│   ├── Dockerfile          # Frontend image with hot reloading
│   └── .dockerignore       # Frontend build exclusions
├── docker-compose.yml      # All services configuration
├── docker-start.sh         # Startup script
├── start.sh               # Manual startup script
└── start-backend.sh       # Backend-only startup script
```

## Docker Commands

```bash
# Start all services
./docker-start.sh

# Or manually
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down

# Rebuild and restart
docker compose up -d --build
```

## Development

### Backend Development
- The backend uses Phoenix framework with Elixir
- Database migrations are in `backend/nacif_api/priv/repo/migrations/`
- API controllers are in `backend/nacif_api/lib/nacif_api_web/controllers/`
- User logic is in `backend/nacif_api/lib/nacif_api/users/`
- Hot reloading enabled - code changes automatically reload

### Frontend Development
- The frontend uses Create React App
- Main component is `frontend/src/App.js`
- Styling is in `frontend/src/App.css`
- API calls are made to `http://localhost:4000/api`
- Hot reloading enabled - code changes automatically reload

## Troubleshooting

1. **Port conflicts**: Make sure ports 3000, 4000, and 5432 are available
2. **Docker issues**: Ensure Docker is running and has sufficient resources
3. **Dependencies**: Docker will handle all dependency installation
4. **Database**: Docker volumes persist data between container restarts
5. **Hot reloading**: Code changes automatically reload in both frontend and backend

## Notes

- CORS is configured to allow requests from `http://localhost:3000`
- Authentication tokens are stored in localStorage
- The CEP field expects 8-digit Brazilian postal codes
- All forms include client-side validation
- Docker volumes ensure data persistence
- Hot reloading enabled for both frontend and backend
- Development environment optimized for rapid development 