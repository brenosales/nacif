# User Management Frontend

A React frontend for the User Management System that allows users to:

- Login with existing credentials
- Register new users
- View current user information
- Update user profile
- Delete user account

## Features

- **Authentication**: Login with email and password
- **User Registration**: Create new user accounts
- **CRUD Operations**: Create, Read, Update, Delete users
- **Token-based Authentication**: JWT tokens for secure API communication
- **Simple UI**: Focus on functionality with minimal styling

## Prerequisites

- Node.js (version 14 or higher)
- Backend API running on `http://localhost:4000`

## Installation

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm start
```

The app will open in your browser at `http://localhost:3000`.

## API Endpoints Used

- `POST /api/login` - User authentication
- `POST /api/users` - Create new user
- `GET /api/users/email/:email` - Get user by email
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

## Usage

1. **Login**: Use existing credentials to log in
2. **Register**: Create a new user account if you don't have one
3. **Dashboard**: View your current user information
4. **Update Profile**: Modify your name, email, and CEP
5. **Delete Account**: Remove your user account (requires confirmation)

## Notes

- The app uses localStorage to persist authentication tokens
- All API calls include proper authorization headers when required
- Form validation is handled on both client and server side
- CEP field expects 8-digit Brazilian postal codes
