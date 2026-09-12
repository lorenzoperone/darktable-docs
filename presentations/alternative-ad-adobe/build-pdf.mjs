import { readFileSync, writeFileSync } from 'node:fs';

const dir = new URL('.', import.meta.url).pathname;
const order = JSON.parse(readFileSync(dir + 'canvas.json', 'utf8')).artboards.map(a => a.file);

const escapeAttr = s => s.replace(/&/g, '&amp;').replace(/"/g, '&quot;');

const frames = order.map(file => {
  const raw = readFileSync(dir + file, 'utf8');
  const helmet = raw.match(/<helmet>([\s\S]*?)<\/helmet>/)[1];
  const content = raw.match(/<\/helmet>([\s\S]*?)<\/x-dc>/)[1];
  const doc = `<!doctype html><html><head><meta charset="utf-8">${helmet}</head><body style="margin:0">${content}</body></html>`;
  return `<iframe srcdoc="${escapeAttr(doc)}"></iframe>`;
}).join('\n');

writeFileSync(dir + 'print.html', `<!doctype html>
<html><head><meta charset="utf-8"><style>
  @page { size: 13.3333in 7.5in; margin: 0; }
  html, body { margin: 0; padding: 0; background: #fff; }
  iframe { display: block; width: 1280px; height: 720px; border: 0; break-after: page; page-break-after: always; }
  iframe:last-child { break-after: auto; page-break-after: auto; }
</style></head><body>
${frames}
</body></html>`);

console.log(`print.html: ${order.length} slide`);
