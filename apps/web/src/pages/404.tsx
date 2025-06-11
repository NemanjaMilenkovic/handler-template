import type { NextPage } from 'next';

const NotFoundPage: NextPage = () => {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center">
      <h1 className="text-4xl font-bold">404 - Page Not Found</h1>
      <p className="mt-4 text-lg">The page you are looking for does not exist.</p>
    </div>
  );
};

NotFoundPage.getInitialProps = () => {
  return { statusCode: 404 };
};

export default NotFoundPage;
