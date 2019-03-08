#!/usr/bin/env bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
. ~/.nvm/nvm.sh
nvm install 6.11.5
nvm install --lts
node -e "console.log('Running Node.js ' + process.version)"
npm install -g @google-cloud/functions-emulator
mkdir -p ~/.config/configstore/@google-cloud/functions-emulator
echo '{"bindHost": "0.0.0.0","host": "localhost","logFile": "/tmp/faas.log","projectId": "trillo","region": "faas","restPort": "8041","supervisorPort": "8040","watch": false,"verbose": true,"service": "rest","maxIdle": 300000,"idlePruneInterval": 60000,"timeout": 20000,"tail": false}' >> ~/.config/configstore/@google-cloud/functions-emulator/config.json
functions start
mkdir TrilloWorld
cd TrilloWorld
touch index.js
echo 'exports.trilloWorld = (req, res) => res.send("Hello, Trillo World!");' > index.js
functions deploy trilloWorld --trigger-http
curl http://localhost:8040/trillo/faas/trilloWorld

