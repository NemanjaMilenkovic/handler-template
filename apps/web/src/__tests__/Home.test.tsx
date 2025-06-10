import '@testing-library/jest-dom';
import { render, screen } from '@testing-library/react';
import Home from '../pages/index';

// Mock trpc
jest.mock('../utils/trpc', () => ({
  trpc: {
    hello: {
      useQuery: () => ({
        data: { greeting: 'Hello from tRPC!' },
        isLoading: false,
      }),
    },
  },
}));

describe('Home', () => {
  it('renders greeting from tRPC', () => {
    render(<Home />);
    expect(screen.getByText('Welcome to tRPC + Next.js')).toBeInTheDocument();
    expect(screen.getByText('Hello from tRPC!')).toBeInTheDocument();
  });
});
