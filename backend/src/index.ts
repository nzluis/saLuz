import { config } from './config.js';
import { buildServer } from './server.js';

async function main() {
  const app = await buildServer();

  try {
    await app.listen({ port: config.port, host: config.host });
    console.log(`🚀 saLuz API running on http://${config.host}:${config.port}`);
    console.log(`📚 Swagger docs at http://localhost:${config.port}/docs`);
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
}

main();
