import React, { useCallback, useEffect, useState } from 'react';
import './App.css';

// API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:4000/api'

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:4000/api';

function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [token, setToken] = useState(localStorage.getItem('token'));
  const [currentView, setCurrentView] = useState('login');

  const [currentUser, setCurrentUser] = useState(null);

  


  const fetchCurrentUser = useCallback(async () => {
    try {
      const userEmail = localStorage.getItem('userEmail');
      if (userEmail) {
        const response = await fetch(`${API_BASE_URL}/users/email/${encodeURIComponent(userEmail)}`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });
        if (response.ok) {
          const data = await response.json();
          setCurrentUser(data.data);
        }
      }
    } catch (error) {
      console.error('Error fetching current user:', error);
    }
  }, [token]);

  useEffect(() => {
    if (token) {
      setIsLoggedIn(true);
      fetchCurrentUser();
    }
  }, [token, fetchCurrentUser]);



  const handleLogout = () => {
    setToken(null);
    setIsLoggedIn(false);
    setCurrentUser(null);
    setCurrentView('login');
    localStorage.removeItem('token');
    localStorage.removeItem('userEmail');
  };





  const handleDeleteUser = async (userId) => {
    if (window.confirm('Are you sure you want to delete this user?')) {
      try {
        const response = await fetch(`${API_BASE_URL}/users/${userId}`, {
          method: 'DELETE',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });

        if (response.ok) {
          alert('User deleted successfully!');
          if (currentUser && currentUser.id === userId) {
            handleLogout();
          }
        } else {
          alert('Failed to delete user.');
        }
      } catch (error) {
        console.error('Delete user error:', error);
        alert('Failed to delete user. Please try again.');
      }
    }
  };

  const LoginForm = () => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    const handleSubmit = async (e) => {
      e.preventDefault();
      try {
        const response = await fetch(`${API_BASE_URL}/login`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ email, password })
        });

        if (response.ok) {
          const data = await response.json();
          setToken(data.data.bearer);
          localStorage.setItem('token', data.data.bearer);
          setIsLoggedIn(true);
          setCurrentView('dashboard');
          localStorage.setItem('userEmail', email);
        } else {
          alert('Login failed. Please check your credentials.');
        }
      } catch (error) {
        console.error('Login error:', error);
        alert('Login failed. Please try again.');
      }
    };

    return (
      <div>
        <h2>Login</h2>
        <form onSubmit={handleSubmit}>
          <div>
            <label>Email:</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div>
            <label>Password:</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
          <button type="submit">Login</button>
        </form>
        <button onClick={() => setCurrentView('register')}>Register New User</button>
      </div>
    );
  };

  const RegisterForm = () => {
    const [name, setName] = useState('');
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [cep, setCep] = useState('');

    const handleSubmit = async (e) => {
      e.preventDefault();
      try {
        const response = await fetch(`${API_BASE_URL}/users`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ name, email, password, cep })
        });

        if (response.ok) {
          alert('User created successfully!');
          setCurrentView('dashboard');
        } else {
          const errorData = await response.json();
          alert(`Error: ${errorData.message || 'Failed to create user'}`);
        }
      } catch (error) {
        console.error('Create user error:', error);
        alert('Failed to create user. Please try again.');
      }
    };

    return (
      <div>
        <h2>Register New User</h2>
        <form onSubmit={handleSubmit}>
          <div>
            <label>Name:</label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
            />
          </div>
          <div>
            <label>Email:</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div>
            <label>Password:</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
          <div>
            <label>CEP:</label>
            <input
              type="text"
              value={cep}
              onChange={(e) => setCep(e.target.value)}
              required
            />
          </div>
          <button type="submit">Create User</button>
        </form>
        <button onClick={() => setCurrentView('login')}>Back to Login</button>
      </div>
    );
  };

  const Dashboard = () => (
    <div>
      <h2>Dashboard</h2>
      {currentUser && (
        <div className="user-info">
          <h3>Current User:</h3>
          <p>Name: {currentUser.name}</p>
          <p>Email: {currentUser.email}</p>
          <p>CEP: {currentUser.cep}</p>
          <div className="actions">
            <button onClick={() => setCurrentView('update')}>Update Profile</button>
            <button onClick={() => handleDeleteUser(currentUser.id)}>Delete Account</button>
          </div>
        </div>
      )}
      <button onClick={handleLogout}>Logout</button>
    </div>
  );

  const UpdateForm = () => {
    const [name, setName] = useState(currentUser?.name || '');
    const [email, setEmail] = useState(currentUser?.email || '');
    const [cep, setCep] = useState(currentUser?.cep || '');

    const handleSubmit = async (e) => {
      e.preventDefault();
      try {
        const response = await fetch(`${API_BASE_URL}/users/${currentUser.id}`, {
          method: 'PUT',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ name, email, cep })
        });

        if (response.ok) {
          const data = await response.json();
          setCurrentUser(data.data);
          alert('User updated successfully!');
          setCurrentView('dashboard');
        } else {
          alert('Failed to update user.');
        }
      } catch (error) {
        console.error('Update user error:', error);
        alert('Failed to update user. Please try again.');
      }
    };

    return (
      <div>
        <h2>Update Profile</h2>
        <form onSubmit={handleSubmit}>
          <div>
            <label>Name:</label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
            />
          </div>
          <div>
            <label>Email:</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div>
            <label>CEP:</label>
            <input
              type="text"
              value={cep}
              onChange={(e) => setCep(e.target.value)}
              required
            />
          </div>
          <button type="submit">Update User</button>
        </form>
        <button onClick={() => setCurrentView('dashboard')}>Back to Dashboard</button>
      </div>
    );
  };

  const renderView = () => {
    if (!isLoggedIn) {
      switch (currentView) {
        case 'register':
          return <RegisterForm />;
        default:
          return <LoginForm />;
      }
    } else {
      switch (currentView) {
        case 'update':
          return <UpdateForm />;
        default:
          return <Dashboard />;
      }
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>User Management System</h1>
      </header>
      <main>
        {renderView()}
      </main>
    </div>
  );
}

export default App;
