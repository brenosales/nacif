import { render, screen } from '@testing-library/react';
import App from './App';

test('renders user management system title', () => {
  render(<App />);
  const titleElement = screen.getByText(/User Management System/i);
  expect(titleElement).toBeInTheDocument();
});

test('renders login form when not authenticated', () => {
  render(<App />);
  const loginElement = screen.getByText(/Login/i);
  expect(loginElement).toBeInTheDocument();
});
