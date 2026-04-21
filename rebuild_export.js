const fs = require('fs');
const path = require('path');

const TARGETS = [
  '.antigravity-os',
  'Agentes',
  'Minhas_Rules',
  'Minhas_Skills',
  'Nucleo',
  'context',
  'templates',
  'CLAUDE.md',
  'GEMINI.md',
  '.cursorrules',
  'README.md'
];

let output = '# 🧬 EXPORTAÇÃO COMPLETA - ANTIGRAVITY OS v3.1\n\n';

function scan(dir) {
  if (!fs.existsSync(dir)) return;
  const stat = fs.statSync(dir);
  if (stat.isFile()) {
    processFile(dir);
    return;
  }
  const files = fs.readdirSync(dir).sort();
  for (const f of files) {
    if (f.startsWith('.git') || f === 'node_modules' || f === '.next') continue;
    const full = path.join(dir, f);
    if (fs.statSync(full).isDirectory()) {
      scan(full);
    } else {
      processFile(full);
    }
  }
}

function processFile(file) {
  const ext = path.extname(file).toLowerCase();
  const ignore = ['.png', '.jpg', '.jpeg', '.gif', '.ico', '.pdf', '.zip', '.lock'];
  if (ignore.includes(ext) || file.includes('package-lock.json')) return;

  try {
    const text = fs.readFileSync(file, 'utf8');
    const p = file.replace(/\\/g, '/');
    output += `\n## Arquivo: ${p}\n\n`;
    output += '```text\n\n';
    output += text;
    if (!text.endsWith('\n')) output += '\n';
    output += '\n```\n\n---\n';
  } catch (e) {
    console.error(`Error reading ${file}`);
  }
}

for (const t of TARGETS) {
  scan(t);
}

output += `
**Mantido por:** Luciano
**Atualizado via Antigravity OS:** ${new Date().toISOString()}

---
`;

fs.writeFileSync('Exportacao_Completa_Framework.md', output, 'utf8');
console.log('Exportação concluída com sucesso!');
