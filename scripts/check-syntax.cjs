const fs = require('node:fs');
const {execFileSync} = require('node:child_process');
const files = ['main-2321.js','bms-core.js','bms-data-config.js','bms-start.js','sw.js',...fs.readdirSync('modules').filter(x=>x.endsWith('.js')).map(x=>'modules/'+x)];
for (const file of files) execFileSync(process.execPath,['--check',file],{stdio:'inherit'});
console.log(`Syntax PASS: ${files.length} application scripts`);
