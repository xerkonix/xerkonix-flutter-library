import { spawn } from 'node:child_process';
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { createConnection } from 'node:net';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const chrome =
  process.env.CHROME_PATH ||
  '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const origin = process.env.CAPTURE_ORIGIN || 'http://127.0.0.1:8777';
const outDir = process.env.ARTIFACT_DIR;
if (!outDir) {
  console.error('ARTIFACT_DIR required');
  process.exit(1);
}
mkdirSync(outDir, { recursive: true });

const shots = [
  { path: '/#/', file: 'matrix-1440-light.png', w: 1440, h: 900, wait: 8000 },
  { path: '/#/', file: 'matrix-390-light.png', w: 390, h: 844, wait: 4000 },
  { path: '/#/states', file: 'states-1440-light.png', w: 1440, h: 1400, wait: 4000, full: true },
  { path: '/#/states', file: 'states-390-light.png', w: 390, h: 844, wait: 3500, full: true },
  { path: '/#/states-toast', file: 'toast-1440-light.png', w: 1440, h: 900, wait: 2000 },
  { path: '/#/states-dialog', file: 'dialog-show-1440-light.png', w: 1440, h: 900, wait: 2800 },
  { path: '/#/states-dialog', file: 'dialog-show-390-light.png', w: 390, h: 844, wait: 2800 },
  { path: '/#/states-dialog', file: 'dialog-show-320-light.png', w: 320, h: 568, wait: 2800 },
  { path: '/#/states-loading', file: 'loading-1440-light.png', w: 1440, h: 900, wait: 2800 },
  { path: '/#/dark', file: 'matrix-1440-dark.png', w: 1440, h: 900, wait: 5000 },
  { path: '/#/dark', file: 'matrix-390-dark.png', w: 390, h: 844, wait: 4000 },
  { path: '/#/states#dark', file: 'states-1440-dark.png', w: 1440, h: 1400, wait: 4000, full: true },
];

function sleep(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

function waitPort(port, timeoutMs) {
  const start = Date.now();
  return new Promise((resolve, reject) => {
    const tryOnce = () => {
      const sock = createConnection({ port, host: '127.0.0.1' }, () => {
        sock.end();
        resolve();
      });
      sock.on('error', () => {
        if (Date.now() - start > timeoutMs) {
          reject(new Error('port wait timeout'));
        } else {
          setTimeout(tryOnce, 150);
        }
      });
    };
    tryOnce();
  });
}

async function cdp(wsUrl, method) {
  const ws = new WebSocket(wsUrl);
  await new Promise((res, rej) => {
    ws.addEventListener('open', () => res(), { once: true });
    ws.addEventListener('error', (e) => rej(e), { once: true });
  });
  let id = 0;
  const pending = new Map();
  ws.addEventListener('message', (ev) => {
    const msg = JSON.parse(ev.data.toString());
    if (msg.id && pending.has(msg.id)) {
      pending.get(msg.id)(msg);
      pending.delete(msg.id);
    }
  });
  const send = (m, p) =>
    new Promise((res, rej) => {
      const n = ++id;
      pending.set(n, (msg) => {
        if (msg.error) {
          rej(new Error(JSON.stringify(msg.error)));
        } else {
          res(msg.result);
        }
      });
      ws.send(JSON.stringify({ id: n, method: m, params: p || {} }));
    });
  try {
    return await method(send);
  } finally {
    ws.close();
  }
}

async function json(url) {
  const res = await fetch(url);
  return res.json();
}

const dbgPort = Number(process.env.CDP_PORT || 9336);
const chromeDir = mkdtempSync(join(tmpdir(), 'tactile-chrome-'));
const chromeProc = spawn(
  chrome,
  [
    '--headless=new',
    `--user-data-dir=${chromeDir}`,
    `--remote-debugging-port=${dbgPort}`,
    '--disable-gpu',
    '--hide-scrollbars',
    '--font-render-hinting=none',
    '--force-device-scale-factor=1',
    '--no-first-run',
    '--no-default-browser-check',
    'about:blank',
  ],
  { stdio: 'ignore' },
);

try {
  await waitPort(dbgPort, 20000);
  await sleep(500);
  const pages = await json(`http://127.0.0.1:${dbgPort}/json/list`);
  const page = pages.find((p) => p.type === 'page') || pages[0];
  if (!page || !page.webSocketDebuggerUrl) {
    throw new Error('no CDP page target: ' + JSON.stringify(pages));
  }
  const wsUrl = page.webSocketDebuggerUrl;
  for (const shot of shots) {
    const url = origin + shot.path;
    console.log('capture', url, '->', shot.file);
    await cdp(wsUrl, async (send) => {
      await send('Emulation.setDeviceMetricsOverride', {
        width: shot.w,
        height: shot.h,
        deviceScaleFactor: 1,
        mobile: shot.w < 720,
      });
      await send('Page.enable');
      await send('Runtime.enable');
      await send('Page.navigate', { url: 'about:blank' });
      await sleep(250);
      const nav = await send('Page.navigate', { url });
      if (nav && nav.errorText) {
        throw new Error(nav.errorText);
      }
      await sleep(shot.wait);
      for (let i = 0; i < 20; i++) {
        const got = await send('Runtime.evaluate', {
          expression:
            '!!(document.querySelector("canvas") || document.querySelector("flt-glass-pane") || document.querySelector("flutter-view"))',
          returnByValue: true,
        });
        if (got && got.result && got.result.value) {
          break;
        }
        await sleep(250);
      }
      await sleep(800);
      const png = await send('Page.captureScreenshot', {
        format: 'png',
        fromSurface: true,
        captureBeyondViewport: !!shot.full,
      });
      writeFileSync(`${outDir}/${shot.file}`, Buffer.from(png.data, 'base64'));
    });
  }
} finally {
  chromeProc.kill('SIGTERM');
  try {
    rmSync(chromeDir, { recursive: true, force: true });
  } catch {
    /* profile still flushing */
  }
}
