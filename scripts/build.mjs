import { cp, mkdir, rm, writeFile } from 'node:fs/promises';

await rm('dist', { recursive: true, force: true });
await mkdir('dist', { recursive: true });
await cp('index.html', 'dist/index.html');
await cp('public', 'dist', { recursive: true });

await writeFile('dist/config.js', `window.WASHWELL_CONFIG = {
  supabaseUrl: ${JSON.stringify(process.env.VITE_SUPABASE_URL || '')},
  supabaseAnonKey: ${JSON.stringify(process.env.VITE_SUPABASE_ANON_KEY || '')},
  workspaceId: ${JSON.stringify(process.env.VITE_WASHWELL_WORKSPACE_ID || '')}
};
`);
