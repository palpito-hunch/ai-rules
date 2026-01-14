import type { NextApiRequest, NextApiResponse } from 'next';

type HealthResponse = {
  status: 'healthy' | 'unhealthy';
  timestamp: string;
  uptime: number;
};

export default function handler(req: NextApiRequest, res: NextApiResponse<HealthResponse>) {
  if (req.method !== 'GET') {
    res.setHeader('Allow', ['GET']);
    res.status(405).end(`Method ${req.method} Not Allowed`);
    return;
  }

  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
}
