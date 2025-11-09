import 'dotenv/config';
import express, { Request, Response } from 'express';
import cors from 'cors';
import authRouter from './routes/auth';
import customersRouter from './routes/customers';
import employeesRouter from './routes/employees';

const app = express();

// CORS configuration
const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(',') || ['*'];
app.use(cors({ 
  origin: allowedOrigins,
  credentials: true 
}));

app.use(express.json());

// Health check endpoint
app.get('/health', (_req: Request, res: Response) => res.json({ 
  ok: true, 
  timestamp: new Date().toISOString(),
  environment: process.env.NODE_ENV || 'development'
}));

// API routes
app.use('/api/auth', authRouter);
app.use('/api/customers', customersRouter);
app.use('/api/employees', employeesRouter);

// Error handling middleware
app.use((err: any, _req: Request, res: Response, _next: any) => {
  console.error('Error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

// 404 handler
app.use((_req: Request, res: Response) => {
  res.status(404).json({ error: 'Not found' });
});

const port = process.env.PORT || 8080;
const server = app.listen(port, () => {
  console.log(`🚀 API listening on port ${port}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });
});
