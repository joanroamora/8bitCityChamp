#!/bin/bash
set -e

# Logging setup
exec > >(tee -a /var/log/startup-script.log) 2>&1
echo "=== Starting 8bitCityChamp Startup Script: $(date) ==="

# Update package list and install Nginx & curl
apt-get update -y
apt-get install -y nginx curl git

# Remove default Nginx index page
rm -rf /var/www/html/*

# Create retro Urban Champion 8-Bit web application
cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>8bitCityChamp - Urban Champion 8-Bit NES Edition</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #0b0c10;
            --arcade-border: #1f2833;
            --neon-blue: #45a29e;
            --neon-green: #66fcf1;
            --neon-red: #ff3366;
            --neon-yellow: #f8c210;
            --crt-glow: rgba(102, 252, 241, 0.15);
        }

        * {
            box-sizing: border-box;
            user-select: none;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--bg-color);
            background-image: 
                radial-gradient(circle at 50% 30%, #1a1c29 0%, #050608 100%);
            color: #ffffff;
            font-family: 'Press Start 2P', monospace, cursive;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 15px;
            overflow-x: hidden;
        }

        /* Arcade Header */
        header {
            text-align: center;
            margin-bottom: 15px;
        }

        .logo-title {
            font-size: 1.8rem;
            color: var(--neon-green);
            text-shadow: 
                3px 3px 0px #000,
                -2px -2px 0px var(--neon-red),
                0 0 15px var(--neon-green);
            letter-spacing: 2px;
            margin-bottom: 8px;
            animation: pulse-title 2s infinite alternate;
        }

        @keyframes pulse-title {
            0% { text-shadow: 3px 3px 0px #000, -2px -2px 0px var(--neon-red), 0 0 10px var(--neon-green); }
            100% { text-shadow: 3px 3px 0px #000, -2px -2px 0px var(--neon-red), 0 0 25px var(--neon-green); }
        }

        .subtitle {
            font-size: 0.7rem;
            color: var(--neon-yellow);
            letter-spacing: 1px;
        }

        /* Arcade Cabinet Frame */
        .arcade-cabinet {
            position: relative;
            background: #11141c;
            border: 12px solid #252a38;
            border-radius: 20px;
            box-shadow: 
                0 0 0 4px #000,
                0 20px 50px rgba(0,0,0,0.9),
                inset 0 0 20px rgba(0,0,0,0.8);
            padding: 20px;
            max-width: 840px;
            width: 100%;
        }

        /* CRT Screen Shell */
        .crt-screen {
            position: relative;
            background: #000;
            border: 6px solid #0a0c10;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: inset 0 0 30px rgba(0,0,0,1);
        }

        /* CRT Scanline Effect */
        .crt-screen::before {
            content: " ";
            display: block;
            position: absolute;
            top: 0; left: 0; bottom: 0; right: 0;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.4) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.03), rgba(0, 255, 0, 0.01), rgba(0, 0, 255, 0.03));
            z-index: 10;
            background-size: 100% 4px, 6px 100%;
            pointer-events: none;
        }

        /* Game HUD Top Bar */
        .hud-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #000;
            padding: 12px 16px;
            border-bottom: 4px solid #222;
            font-size: 0.7rem;
            z-index: 5;
            position: relative;
        }

        .hud-player {
            display: flex;
            flex-direction: column;
            gap: 6px;
            width: 35%;
        }

        .player-name {
            display: flex;
            justify-content: space-between;
        }

        .p1-color { color: #5c94fc; }
        .p2-color { color: #50c878; }

        .health-bar-container {
            width: 100%;
            height: 16px;
            background: #333;
            border: 2px solid #fff;
            position: relative;
        }

        .health-bar-fill {
            height: 100%;
            width: 100%;
            background: linear-gradient(90deg, #ff3366, #f8c210, #50c878);
            transition: width 0.2s ease-out;
        }

        .stamina-dots {
            display: flex;
            gap: 4px;
            margin-top: 2px;
        }

        .dot {
            width: 8px;
            height: 8px;
            background: var(--neon-yellow);
            border: 1px solid #000;
        }

        .hud-center {
            text-align: center;
            width: 25%;
        }

        .hud-timer {
            font-size: 1.2rem;
            color: #fff;
            text-shadow: 2px 2px #ff0000;
        }

        .hud-round {
            font-size: 0.55rem;
            color: var(--neon-yellow);
            margin-top: 4px;
        }

        /* Canvas Arena */
        canvas#gameCanvas {
            display: block;
            width: 100%;
            height: auto;
            background: #000;
            image-rendering: pixelated;
        }

        /* Controls Section */
        .controls-panel {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 20px;
            background: #181c26;
            padding: 15px;
            border-radius: 8px;
            border: 2px solid #2c3448;
        }

        .control-group {
            font-size: 0.65rem;
            line-height: 1.6;
        }

        .control-group h3 {
            color: var(--neon-green);
            font-size: 0.75rem;
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        .key-badge {
            background: #2b3245;
            color: #fff;
            padding: 2px 6px;
            border-radius: 4px;
            border: 1px solid #45506b;
            box-shadow: 0 2px 0 #151922;
        }

        /* On-Screen Touch Controls for Mobile */
        .mobile-controls {
            display: none;
            margin-top: 15px;
            width: 100%;
            justify-content: space-between;
        }

        @media (max-width: 768px) {
            .mobile-controls { display: flex; }
            .controls-panel { grid-template-columns: 1fr; }
            .logo-title { font-size: 1.2rem; }
        }

        .btn-group {
            display: flex;
            gap: 10px;
        }

        .retro-btn {
            background: linear-gradient(180deg, #3a445d, #222836);
            color: #fff;
            border: 3px solid #576585;
            padding: 12px 18px;
            font-family: inherit;
            font-size: 0.7rem;
            border-radius: 8px;
            box-shadow: 0 4px 0 #11141b;
            cursor: pointer;
            active: translateY(4px);
        }

        .retro-btn:active {
            transform: translateY(3px);
            box-shadow: 0 1px 0 #11141b;
        }

        .btn-punch { background: linear-gradient(180deg, #d63031, #8b0000); border-color: #ff7675; }
        .btn-heavy { background: linear-gradient(180deg, #e17055, #d35400); border-color: #fab1a0; }
        .btn-block { background: linear-gradient(180deg, #0984e3, #0056b3); border-color: #74b9ff; }

        /* Footer Info */
        footer {
            margin-top: 20px;
            text-align: center;
            font-size: 0.6rem;
            color: #666;
        }

        footer span {
            color: var(--neon-green);
        }

        /* Overlay Messages */
        .overlay-msg {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 1.5rem;
            color: #ffe600;
            text-shadow: 4px 4px 0 #000, -2px -2px 0 #ff0000;
            text-align: center;
            z-index: 20;
            pointer-events: none;
            display: none;
        }
    </style>
</head>
<body>

    <header>
        <h1 class="logo-title">8bitCityChamp</h1>
        <p class="subtitle">URBAN CHAMPION - GCP GCP INFRASTRUCTURE EDITION</p>
    </header>

    <main class="arcade-cabinet">
        <div class="crt-screen">
            <!-- HUD -->
            <div class="hud-bar">
                <div class="hud-player">
                    <div class="player-name">
                        <span class="p1-color">PLAYER 1</span>
                        <span id="p1Score">00000</span>
                    </div>
                    <div class="health-bar-container">
                        <div id="p1Health" class="health-bar-fill"></div>
                    </div>
                    <div class="stamina-dots" id="p1Stamina">
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div>
                    </div>
                </div>

                <div class="hud-center">
                    <div class="hud-timer" id="gameTimer">99</div>
                    <div class="hud-round" id="roundNum">ROUND 1</div>
                </div>

                <div class="hud-player">
                    <div class="player-name">
                        <span class="p2-color">CPU (GREEN)</span>
                        <span id="p2Score">00000</span>
                    </div>
                    <div class="health-bar-container">
                        <div id="p2Health" class="health-bar-fill"></div>
                    </div>
                    <div class="stamina-dots" id="p2Stamina">
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div>
                    </div>
                </div>
            </div>

            <!-- Canvas Game Arena -->
            <canvas id="gameCanvas" width="512" height="384"></canvas>
            
            <div id="overlayMsg" class="overlay-msg">INSERT COIN / PRESS START</div>
        </div>

        <!-- Mobile Touch Buttons -->
        <div class="mobile-controls">
            <div class="btn-group">
                <button class="retro-btn" id="btnLeft">◄</button>
                <button class="retro-btn" id="btnRight">►</button>
            </div>
            <div class="btn-group">
                <button class="retro-btn btn-punch" id="btnLight">PUNCH</button>
                <button class="retro-btn btn-heavy" id="btnHeavy">HEAVY</button>
                <button class="retro-btn btn-block" id="btnBlock">BLOCK</button>
            </div>
        </div>

        <!-- Controls Guide -->
        <div class="controls-panel">
            <div class="control-group">
                <h3>🎮 CONTROLES (JUGADOR 1)</h3>
                <p><span class="key-badge">◄</span> / <span class="key-badge">►</span> o <span class="key-badge">A</span> / <span class="key-badge">D</span> : Moverse</p>
                <p><span class="key-badge">Z</span> o <span class="key-badge">J</span> : Puñetazo Rápido (Jab)</p>
                <p><span class="key-badge">X</span> o <span class="key-badge">K</span> : Puñetazo Fuerte (Heavy Punch)</p>
                <p><span class="key-badge">ESPACIO</span> o <span class="key-badge">S</span> : Bloquear / Defender</p>
            </div>
            <div class="control-group">
                <h3>⚡ REGLAS URBAN CHAMPION</h3>
                <p>• Empuja a tu rival hacia el extremo de la calle.</p>
                <p>• ¡Hazlo caer en la <strong>alcantarilla</strong> para ganar el asalto!</p>
                <p>• Cuidado cuando pase la patrulla de policía 🚓.</p>
                <p>• Infraestructura desplegada en GCP Compute Engine.</p>
            </div>
        </div>
    </main>

    <footer>
        <p>POWERED BY <span>GOOGLE CLOUD PLATFORM</span> & <span>TERRAFORM</span> | 8bitCityChamp v1.0</p>
    </footer>

    <script>
        // 8-bit Audio Synthesizer using Web Audio API
        class SoundFX {
            constructor() {
                this.ctx = null;
            }
            init() {
                if (!this.ctx) {
                    this.ctx = new (window.AudioContext || window.webkitAudioContext)();
                }
            }
            playPunch(isHeavy) {
                if (!this.ctx) return;
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();
                osc.type = isHeavy ? 'triangle' : 'square';
                osc.frequency.setValueAtTime(isHeavy ? 120 : 240, this.ctx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(30, this.ctx.currentTime + 0.15);
                gain.gain.setValueAtTime(0.3, this.ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + 0.15);
                osc.connect(gain);
                gain.connect(this.ctx.destination);
                osc.start();
                osc.stop(this.ctx.currentTime + 0.15);
            }
            playHit() {
                if (!this.ctx) return;
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();
                osc.type = 'sawtooth';
                osc.frequency.setValueAtTime(80, this.ctx.currentTime);
                osc.frequency.linearRampToValueAtTime(20, this.ctx.currentTime + 0.2);
                gain.gain.setValueAtTime(0.4, this.ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + 0.2);
                osc.connect(gain);
                gain.connect(this.ctx.destination);
                osc.start();
                osc.stop(this.ctx.currentTime + 0.2);
            }
            playBlock() {
                if (!this.ctx) return;
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();
                osc.type = 'sine';
                osc.frequency.setValueAtTime(440, this.ctx.currentTime);
                osc.frequency.setValueAtTime(880, this.ctx.currentTime + 0.05);
                gain.gain.setValueAtTime(0.2, this.ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + 0.1);
                osc.connect(gain);
                gain.connect(this.ctx.destination);
                osc.start();
                osc.stop(this.ctx.currentTime + 0.1);
            }
            playSiren() {
                if (!this.ctx) return;
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();
                osc.type = 'sawtooth';
                osc.frequency.setValueAtTime(600, this.ctx.currentTime);
                osc.frequency.linearRampToValueAtTime(900, this.ctx.currentTime + 0.25);
                osc.frequency.linearRampToValueAtTime(600, this.ctx.currentTime + 0.5);
                gain.gain.setValueAtTime(0.15, this.ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + 0.5);
                osc.connect(gain);
                gain.connect(this.ctx.destination);
                osc.start();
                osc.stop(this.ctx.currentTime + 0.5);
            }
            playWin() {
                if (!this.ctx) return;
                const notes = [261.63, 329.63, 392.00, 523.25];
                notes.forEach((freq, i) => {
                    const osc = this.ctx.createOscillator();
                    const gain = this.ctx.createGain();
                    osc.type = 'square';
                    osc.frequency.value = freq;
                    gain.gain.setValueAtTime(0.25, this.ctx.currentTime + i * 0.12);
                    gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + (i + 1) * 0.12);
                    osc.connect(gain);
                    gain.connect(this.ctx.destination);
                    osc.start(this.ctx.currentTime + i * 0.12);
                    osc.stop(this.ctx.currentTime + (i + 1) * 0.12);
                });
            }
        }

        const sfx = new SoundFX();

        // Game Engine Initialization
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        const overlay = document.getElementById('overlayMsg');

        // Game State Variables
        let gameState = 'START'; // START, PLAYING, ROUND_OVER, POLICE
        let timer = 99;
        let timerInterval = null;
        let round = 1;
        let p1ScoreVal = 0;
        let p2ScoreVal = 0;

        // Fighter Objects
        const p1 = {
            x: 140,
            y: 240,
            width: 44,
            height: 72,
            color: '#5c94fc', // Blue
            skinColor: '#ffcc99',
            hairColor: '#8b4513',
            health: 100,
            state: 'IDLE', // IDLE, WALK, PUNCH_LIGHT, PUNCH_HEAVY, BLOCK, HIT, KO
            frame: 0,
            facing: 1,
            stamina: 3,
            cooldown: 0
        };

        const p2 = {
            x: 320,
            y: 240,
            width: 44,
            height: 72,
            color: '#50c878', // Green
            skinColor: '#ffcc99',
            hairColor: '#333333',
            health: 100,
            state: 'IDLE',
            frame: 0,
            facing: -1,
            stamina: 3,
            cooldown: 0
        };

        // Street Environment Props
        const street = {
            leftBoundary: 40,
            rightBoundary: 470,
            manholeX: 430,
            manholeWidth: 50,
            policeCarX: -150,
            policeActive: false
        };

        // Keys state
        const keys = {};

        window.addEventListener('keydown', (e) => {
            sfx.init();
            keys[e.code] = true;
            if (gameState === 'START') {
                startGame();
            }
        });

        window.addEventListener('keyup', (e) => {
            keys[e.code] = false;
        });

        // Touch event handlers
        document.getElementById('btnLeft').addEventListener('touchstart', (e) => { e.preventDefault(); keys['ArrowLeft'] = true; });
        document.getElementById('btnLeft').addEventListener('touchend', (e) => { e.preventDefault(); keys['ArrowLeft'] = false; });
        document.getElementById('btnRight').addEventListener('touchstart', (e) => { e.preventDefault(); keys['ArrowRight'] = true; });
        document.getElementById('btnRight').addEventListener('touchend', (e) => { e.preventDefault(); keys['ArrowRight'] = false; });
        
        document.getElementById('btnLight').addEventListener('click', () => { sfx.init(); if(gameState==='START') startGame(); else triggerPunch(p1, false); });
        document.getElementById('btnHeavy').addEventListener('click', () => { sfx.init(); if(gameState==='START') startGame(); else triggerPunch(p1, true); });
        document.getElementById('btnBlock').addEventListener('touchstart', (e) => { e.preventDefault(); keys['Space'] = true; });
        document.getElementById('btnBlock').addEventListener('touchend', (e) => { e.preventDefault(); keys['Space'] = false; });

        function startGame() {
            gameState = 'PLAYING';
            overlay.style.display = 'none';
            p1.health = 100;
            p2.health = 100;
            p1.x = 140;
            p2.x = 320;
            timer = 99;
            updateHUD();
            
            if (timerInterval) clearInterval(timerInterval);
            timerInterval = setInterval(() => {
                if (gameState === 'PLAYING') {
                    timer--;
                    document.getElementById('gameTimer').innerText = timer < 10 ? '0' + timer : timer;
                    if (timer <= 0) {
                        endRound('TIEMPO AGOTADO');
                    }
                    // Random Police Patrol event
                    if (timer > 20 && Math.random() < 0.03 && !street.policeActive) {
                        triggerPolicePatrol();
                    }
                }
            }, 1000);
        }

        function triggerPunch(fighter, isHeavy) {
            if (fighter.state === 'IDLE' || fighter.state === 'WALK') {
                fighter.state = isHeavy ? 'PUNCH_HEAVY' : 'PUNCH_LIGHT';
                fighter.cooldown = isHeavy ? 20 : 12;
                sfx.playPunch(isHeavy);
                
                // Check Hitbox against opponent
                const opponent = (fighter === p1) ? p2 : p1;
                const dist = Math.abs(fighter.x - opponent.x);
                if (dist < 55) {
                    if (opponent.state === 'BLOCK') {
                        sfx.playBlock();
                        opponent.x += fighter.facing * 8; // Slight pushback
                    } else {
                        sfx.playHit();
                        opponent.state = 'HIT';
                        opponent.cooldown = 15;
                        const damage = isHeavy ? 18 : 9;
                        const knockback = isHeavy ? 35 : 18;
                        opponent.health = Math.max(0, opponent.health - damage);
                        opponent.x += fighter.facing * knockback;

                        if (fighter === p1) p1ScoreVal += isHeavy ? 200 : 100;
                        else p2ScoreVal += isHeavy ? 200 : 100;

                        // Check sewer pit fall win condition
                        if (opponent.x >= street.manholeX - 10 && opponent.x <= street.manholeX + street.manholeWidth) {
                            opponent.state = 'KO';
                            sfx.playWin();
                            setTimeout(() => endRound((fighter === p1 ? 'JUGADOR 1' : 'CPU') + ' ¡GANA EL ASALTO!'), 800);
                            return;
                        }

                        if (opponent.health <= 0) {
                            opponent.state = 'KO';
                            sfx.playWin();
                            setTimeout(() => endRound((fighter === p1 ? 'JUGADOR 1' : 'CPU') + ' ¡KNOCKOUT!'), 800);
                        }
                    }
                }
            }
        }

        function triggerPolicePatrol() {
            street.policeActive = true;
            street.policeCarX = -150;
            sfx.playSiren();
            overlay.innerText = '🚨 ¡PATRULLA DE POLICÍA! 🚨';
            overlay.style.display = 'block';
            setTimeout(() => {
                if (gameState === 'PLAYING') overlay.style.display = 'none';
            }, 2500);
        }

        function endRound(msg) {
            gameState = 'ROUND_OVER';
            clearInterval(timerInterval);
            overlay.innerText = msg;
            overlay.style.display = 'block';
            setTimeout(() => {
                round++;
                document.getElementById('roundNum').innerText = 'ROUND ' + round;
                startGame();
            }, 3000);
        }

        function updateHUD() {
            document.getElementById('p1Health').style.width = p1.health + '%';
            document.getElementById('p2Health').style.width = p2.health + '%';
            document.getElementById('p1Score').innerText = String(p1ScoreVal).padStart(5, '0');
            document.getElementById('p2Score').innerText = String(p2ScoreVal).padStart(5, '0');
        }

        // Input Processing & AI Logic
        function updateGame() {
            if (gameState !== 'PLAYING') return;

            // Player 1 Input
            if (p1.cooldown > 0) {
                p1.cooldown--;
                if (p1.cooldown === 0 && p1.state !== 'KO') p1.state = 'IDLE';
            } else {
                if (keys['Space'] || keys['KeyS']) {
                    p1.state = 'BLOCK';
                } else if (keys['KeyZ'] || keys['KeyJ']) {
                    triggerPunch(p1, false);
                } else if (keys['KeyX'] || keys['KeyK']) {
                    triggerPunch(p1, true);
                } else if (keys['ArrowLeft'] || keys['KeyA']) {
                    p1.x = Math.max(street.leftBoundary, p1.x - 3);
                    p1.state = 'WALK';
                } else if (keys['ArrowRight'] || keys['KeyD']) {
                    p1.x = Math.min(street.manholeX + 20, p1.x + 3);
                    p1.state = 'WALK';
                } else {
                    p1.state = 'IDLE';
                }
            }

            // CPU AI Logic (Player 2)
            if (p2.cooldown > 0) {
                p2.cooldown--;
                if (p2.cooldown === 0 && p2.state !== 'KO') p2.state = 'IDLE';
            } else {
                const distance = Math.abs(p1.x - p2.x);
                if (distance > 50) {
                    p2.x -= 2; // Walk towards P1
                    p2.state = 'WALK';
                } else {
                    const aiChoice = Math.random();
                    if (aiChoice < 0.04) {
                        triggerPunch(p2, false);
                    } else if (aiChoice < 0.07) {
                        triggerPunch(p2, true);
                    } else if (aiChoice < 0.12) {
                        p2.state = 'BLOCK';
                    } else {
                        p2.state = 'IDLE';
                    }
                }
            }

            // Keep inside arena boundaries
            p1.x = Math.max(street.leftBoundary, Math.min(street.rightBoundary, p1.x));
            p2.x = Math.max(street.leftBoundary, Math.min(street.rightBoundary, p2.x));

            // Move Police Car if active
            if (street.policeActive) {
                street.policeCarX += 6;
                if (street.policeCarX > canvas.width + 100) {
                    street.policeActive = false;
                }
            }

            updateHUD();
        }

        // 8-bit Pixel Drawing Functions
        function drawBackground() {
            // Dark Retro Sky
            ctx.fillStyle = '#0f1423';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Street Brick Buildings Background
            ctx.fillStyle = '#2d1b36';
            ctx.fillRect(0, 40, canvas.width, 220);

            // Brick details & Store windows ("BAR", "SNACK")
            ctx.fillStyle = '#4a2e56';
            ctx.fillRect(30, 70, 90, 80);
            ctx.fillRect(200, 70, 110, 80);
            ctx.fillRect(380, 70, 90, 80);

            // Windows light
            ctx.fillStyle = '#f8c210';
            ctx.fillRect(45, 85, 25, 30);
            ctx.fillRect(80, 85, 25, 30);
            ctx.fillRect(215, 85, 35, 30);
            ctx.fillRect(260, 85, 35, 30);

            // Store Signboards
            ctx.fillStyle = '#e74c3c';
            ctx.fillRect(20, 50, 110, 16);
            ctx.fillStyle = '#fff';
            ctx.font = '10px "Press Start 2P"';
            ctx.fillText('BAR', 55, 63);

            ctx.fillStyle = '#3498db';
            ctx.fillRect(190, 50, 130, 16);
            ctx.fillStyle = '#fff';
            ctx.fillText('SNACK', 225, 63);

            // Sidewalk / Curb
            ctx.fillStyle = '#7f8c8d';
            ctx.fillRect(0, 260, canvas.width, 15);
            ctx.fillStyle = '#bdc3c7';
            ctx.fillRect(0, 260, canvas.width, 3);

            // Street Asphalt Floor
            ctx.fillStyle = '#1e272e';
            ctx.fillRect(0, 275, canvas.width, 110);

            // Sewer Manhole Trap
            ctx.fillStyle = '#0f171e';
            ctx.beginPath();
            ctx.ellipse(street.manholeX + 25, 320, 25, 8, 0, 0, Math.PI * 2);
            ctx.fill();
            ctx.strokeStyle = '#485460';
            ctx.lineWidth = 3;
            ctx.stroke();
            
            // Manhole grate lines
            ctx.strokeStyle = '#2c3e50';
            ctx.beginPath();
            ctx.moveTo(street.manholeX + 10, 320); ctx.lineTo(street.manholeX + 40, 320);
            ctx.moveTo(street.manholeX + 15, 317); ctx.lineTo(street.manholeX + 35, 317);
            ctx.moveTo(street.manholeX + 15, 323); ctx.lineTo(street.manholeX + 35, 323);
            ctx.stroke();

            // Draw Police Car if passing
            if (street.policeActive) {
                drawPoliceCar(street.policeCarX, 290);
            }
        }

        function drawPoliceCar(x, y) {
            ctx.fillStyle = '#000';
            ctx.fillRect(x, y, 100, 35);
            ctx.fillStyle = '#fff';
            ctx.fillRect(x + 20, y, 60, 18);
            // Red/Blue Siren Light Flash
            ctx.fillStyle = Math.floor(Date.now() / 150) % 2 === 0 ? '#ff0000' : '#00ffff';
            ctx.fillRect(x + 45, y - 8, 12, 8);
            // Wheels
            ctx.fillStyle = '#7f8c8d';
            ctx.beginPath();
            ctx.arc(x + 20, y + 35, 10, 0, Math.PI * 2);
            ctx.arc(x + 80, y + 35, 10, 0, Math.PI * 2);
            ctx.fill();
        }

        function drawFighter(f) {
            ctx.save();
            ctx.translate(f.x, f.y);

            // Shadow
            ctx.fillStyle = 'rgba(0,0,0,0.4)';
            ctx.beginPath();
            ctx.ellipse(f.width/2, f.height + 4, 22, 6, 0, 0, Math.PI * 2);
            ctx.fill();

            // Head
            ctx.fillStyle = f.skinColor;
            ctx.fillRect(10, 0, 24, 20);

            // Hair
            ctx.fillStyle = f.hairColor;
            ctx.fillRect(8, -4, 28, 10);

            // Eyes
            ctx.fillStyle = '#000';
            if (f.facing === 1) ctx.fillRect(24, 6, 4, 4);
            else ctx.fillRect(16, 6, 4, 4);

            // Body / Shirt (Blue for P1, Green for P2)
            ctx.fillStyle = f.color;
            ctx.fillRect(8, 20, 28, 30);

            // Pants
            ctx.fillStyle = '#2c3e50';
            ctx.fillRect(10, 50, 24, 22);

            // Arms & Fighting Stance States
            ctx.fillStyle = f.skinColor;
            if (f.state === 'PUNCH_LIGHT') {
                ctx.fillRect(f.facing === 1 ? 28 : -14, 22, 24, 10); // Fist extended
            } else if (f.state === 'PUNCH_HEAVY') {
                ctx.fillRect(f.facing === 1 ? 28 : -20, 20, 30, 14); // Heavy Fist
            } else if (f.state === 'BLOCK') {
                ctx.fillRect(14, 14, 16, 16); // Guard up
            } else if (f.state === 'HIT') {
                ctx.rotate((f.facing * -15 * Math.PI) / 180);
                ctx.fillRect(4, 24, 12, 12);
            } else {
                // Idle stance fists
                ctx.fillRect(4, 24, 10, 12);
                ctx.fillRect(30, 24, 10, 12);
            }

            // KO Sewer drop state animation
            if (f.state === 'KO') {
                ctx.translate(0, 30);
            }

            ctx.restore();
        }

        function render() {
            drawBackground();
            drawFighter(p1);
            drawFighter(p2);
        }

        function gameLoop() {
            updateGame();
            render();
            requestAnimationFrame(gameLoop);
        }

        // Start Game Loop
        gameLoop();
    </script>
</body>
</html>
EOF

# Ensure proper permissions and ownership
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Enable and restart Nginx
systemctl enable nginx
systemctl restart nginx

echo "=== 8bitCityChamp Startup Script Completed Successfully at $(date) ==="
