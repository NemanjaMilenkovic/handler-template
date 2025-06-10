import type { NextPage } from 'next';

const ServerErrorPage: NextPage = () => {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center">
      <h1 className="text-4xl font-bold">500 - Server Error</h1>
      <p className="mt-4 text-lg">Something went wrong on our end. Please try again later.</p>
    </div>
  );
};

ServerErrorPage.getInitialProps = () => {
  return { statusCode: 500 };
};

export default ServerErrorPage; 