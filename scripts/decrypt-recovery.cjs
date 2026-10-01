// Operator utility. Password stays in terminal memory; clear output is mode 0600.
const fs = require('node:fs');
const readline = require('node:readline');
const core = require('../bms-core.js');
(async()=>{
 const [input,output]=process.argv.slice(2);
 if(!input||!output||!process.stdin.isTTY)throw new Error('Usage: node scripts/decrypt-recovery.cjs input.bmsbackup protected-output.json (interactive terminal required)');
 if(fs.existsSync(output))throw new Error('Output already exists; choose a new protected path.');
 process.stdout.write('Backup password: ');let password='';
 readline.emitKeypressEvents(process.stdin);process.stdin.setRawMode(true);process.stdin.resume();
 await new Promise((resolve,reject)=>{const handler=(text,key)=>{if(key?.ctrl&&key.name==='c'){reject(new Error('Cancelled'));process.stdin.off('keypress',handler);}else if(key?.name==='return'){process.stdin.off('keypress',handler);resolve();}else if(key?.name==='backspace'){password=password.slice(0,-1);}else if(text)password+=text;};process.stdin.on('keypress',handler);});
 process.stdin.setRawMode(false);process.stdin.pause();process.stdout.write('\n');
 const doc=await core.decryptRecovery(fs.readFileSync(input,'utf8'),password);password='';
 fs.writeFileSync(output,JSON.stringify(doc),{mode:0o600,flag:'wx'});
 console.log('Decryption PASS. Protected recovery file written.');
})().catch(e=>{if(process.stdin.isTTY)process.stdin.setRawMode(false);process.stdin.pause();console.error(e.message);process.exitCode=1;});
