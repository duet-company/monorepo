import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Duet Company - AI-First Data Infrastructure',
  description: 'Autonomous AI agents design, deploy, and manage scalable data platforms. 90% less cost, 100x faster queries.',
  keywords: ['data infrastructure', 'AI agents', 'ClickHouse', 'analytics', 'data platform'],
  authors: [{ name: 'Duet Company' }],
  openGraph: {
    title: 'Duet Company - AI-First Data Infrastructure',
    description: 'Autonomous AI agents design, deploy, and manage scalable data platforms.',
    url: 'https://duet.company',
    siteName: 'Duet Company',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Duet Company - AI-First Data Infrastructure',
    description: 'Autonomous AI agents design, deploy, and manage scalable data platforms.',
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}
