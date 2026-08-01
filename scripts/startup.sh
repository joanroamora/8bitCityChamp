#!/bin/bash
set -e

# Logging setup
exec > >(tee -a /var/log/startup-script.log) 2>&1
echo "=== Starting 8bitCityChamp Startup Script (Feature2Game Edition): $(date) ==="

# Update package list and install Nginx & curl
apt-get update -y
apt-get install -y nginx curl git

# Remove default Nginx index page
rm -rf /var/www/html/*

# Create retro Urban Champion 8-Bit web application with Vintage Start Screen, 5 Opponents & Dictator Boss
cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>8bitCityChamp - Vintage Urban Champion 8-Bit NES Edition</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #08090d;
            --arcade-border: #1f2833;
            --neon-blue: #45a29e;
            --neon-green: #66fcf1;
            --neon-red: #ff3366;
            --neon-yellow: #f8c210;
            --dictator-gold: #ffd700;
        }

        * {
            box-sizing: border-box;
            user-select: none;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--bg-color);
            background-image: radial-gradient(circle at 50% 30%, #151824 0%, #040507 100%);
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
            font-size: 0.65rem;
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
            font-size: 0.65rem;
            z-index: 5;
            position: relative;
        }

        .hud-player {
            display: flex;
            flex-direction: column;
            gap: 6px;
            width: 38%;
        }

        .player-name {
            display: flex;
            justify-content: space-between;
            font-size: 0.6rem;
        }

        .p1-color { color: #5c94fc; }
        .p2-color { color: #ff3366; }

        .health-bar-container {
            width: 100%;
            height: 16px;
            background: #222;
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
            width: 24%;
        }

        .hud-timer {
            font-size: 1.2rem;
            color: #fff;
            text-shadow: 2px 2px #ff0000;
        }

        .hud-stage {
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
            font-size: 0.6rem;
            line-height: 1.7;
        }

        .control-group h3 {
            color: var(--neon-green);
            font-size: 0.7rem;
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
            font-size: 0.65rem;
            border-radius: 8px;
            box-shadow: 0 4px 0 #11141b;
            cursor: pointer;
        }

        .retro-btn:active {
            transform: translateY(3px);
            box-shadow: 0 1px 0 #11141b;
        }

        .btn-start { background: linear-gradient(180deg, #00b894, #006266); border-color: #55efc4; font-weight: bold; width: 100%; margin-top: 10px; padding: 14px; font-size: 0.8rem; }
        .btn-punch { background: linear-gradient(180deg, #d63031, #8b0000); border-color: #ff7675; }
        .btn-heavy { background: linear-gradient(180deg, #e17055, #d35400); border-color: #fab1a0; }
        .btn-block { background: linear-gradient(180deg, #0984e3, #0056b3); border-color: #74b9ff; }

        /* Footer Info */
        footer {
            margin-top: 20px;
            text-align: center;
            font-size: 0.6rem;
            color: #888;
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
            font-size: 1.2rem;
            color: #ffe600;
            text-shadow: 4px 4px 0 #000, -2px -2px 0 #ff0000;
            text-align: center;
            z-index: 20;
            pointer-events: none;
            display: none;
            width: 90%;
            line-height: 1.6;
        }
    </style>
</head>
<body>

    <header>
        <h1 class="logo-title">8bitCityChamp</h1>
        <p class="subtitle">VINTAGE NES URBAN CHAMPION • FEATURE2 EDITION</p>
    </header>

    <main class="arcade-cabinet">
        <div class="crt-screen">
            <!-- HUD -->
            <div class="hud-bar" id="hudBar">
                <div class="hud-player">
                    <div class="player-name">
                        <span class="p1-color">PLAYER 1</span>
                        <span id="p1Score">00000</span>
                    </div>
                    <div class="health-bar-container">
                        <div id="p1Health" class="health-bar-fill"></div>
                    </div>
                </div>

                <div class="hud-center">
                    <div class="hud-timer" id="gameTimer">99</div>
                    <div class="hud-stage" id="stageLabel">STAGE 1/5</div>
                </div>

                <div class="hud-player">
                    <div class="player-name">
                        <span class="p2-color" id="p2Name">OPPONENT</span>
                        <span id="p2Score">00000</span>
                    </div>
                    <div class="health-bar-container">
                        <div id="p2Health" class="health-bar-fill"></div>
                    </div>
                </div>
            </div>

            <!-- Canvas Game Arena -->
            <canvas id="gameCanvas" width="512" height="384"></canvas>
            
            <div id="overlayMsg" class="overlay-msg">PRESS START TO PLAY</div>
        </div>

        <!-- Start Button for All Devices -->
        <button class="retro-btn btn-start" id="btnStartGame">🎮 PRESS START / BEGIN BATTLE</button>

        <!-- Mobile Touch Buttons -->
        <div class="mobile-controls">
            <div class="btn-group">
                <button class="retro-btn" id="btnLeft">◄ MOVE</button>
                <button class="retro-btn" id="btnRight">MOVE ►</button>
            </div>
            <div class="btn-group">
                <button class="retro-btn btn-punch" id="btnLight">JAB</button>
                <button class="retro-btn btn-heavy" id="btnHeavy">HEAVY</button>
                <button class="retro-btn btn-block" id="btnBlock">BLOCK</button>
            </div>
        </div>

        <!-- Controls & Rules Guide in English -->
        <div class="controls-panel">
            <div class="control-group">
                <h3>🎮 CONTROLS (PLAYER 1)</h3>
                <p><span class="key-badge">◄</span> / <span class="key-badge">►</span> or <span class="key-badge">A</span> / <span class="key-badge">D</span> : Walk Left / Right</p>
                <p><span class="key-badge">Z</span> or <span class="key-badge">J</span> : Fast Jab Punch</p>
                <p><span class="key-badge">X</span> or <span class="key-badge">K</span> : Heavy Hook Punch</p>
                <p><span class="key-badge">SPACE</span> or <span class="key-badge">S</span> : Block / Guard</p>
                <p><span class="key-badge">ENTER</span> : Start / Pause Game</p>
            </div>
            <div class="control-group">
                <h3>⚡ ARCADE STAGES & DICTATOR BOSS</h3>
                <p>• Push your rival off the street edge or into the sewer pit!</p>
                <p>• <strong>5 Opponents:</strong> Spike, Bruno, Duke, Kage & Dictator Boss!</p>
                <p>• <strong>Final Boss (Stage 5):</strong> Defeat General Ironclad to liberate the city!</p>
                <p>• Beware of passing Police Patrol cars 🚓.</p>
                <p>• Infrastructure deployed on GCP Compute Engine via Terraform.</p>
            </div>
        </div>
    </main>

    <footer>
        <p>POWERED BY <span>GOOGLE CLOUD PLATFORM</span> & <span>TERRAFORM</span> | 8bitCityChamp Feature2</p>
    </footer>

    <script>
        // 8-Bit Synthesizer Audio Engine
        class SoundFX {
            constructor() {
                this.ctx = null;
            }
            init() {
                if (!this.ctx) {
                    this.ctx = new (window.AudioContext || window.webkitAudioContext)();
                }
            }
            playStart() {
                if (!this.ctx) return;
                const notes = [220, 277.18, 329.63, 440];
                notes.forEach((freq, i) => {
                    const osc = this.ctx.createOscillator();
                    const gain = this.ctx.createGain();
                    osc.type = 'square';
                    osc.frequency.value = freq;
                    gain.gain.setValueAtTime(0.2, this.ctx.currentTime + i * 0.08);
                    gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + (i + 1) * 0.08);
                    osc.connect(gain);
                    gain.connect(this.ctx.destination);
                    osc.start(this.ctx.currentTime + i * 0.08);
                    osc.stop(this.ctx.currentTime + (i + 1) * 0.08);
                });
            }
            playPunch(isHeavy) {
                if (!this.ctx) return;
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();
                osc.type = isHeavy ? 'triangle' : 'square';
                osc.frequency.setValueAtTime(isHeavy ? 130 : 250, this.ctx.currentTime);
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
                osc.frequency.setValueAtTime(90, this.ctx.currentTime);
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
                const notes = [261.63, 329.63, 392.00, 523.25, 659.25];
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
            playGameOver() {
                if (!this.ctx) return;
                const notes = [300, 250, 200, 150];
                notes.forEach((freq, i) => {
                    const osc = this.ctx.createOscillator();
                    const gain = this.ctx.createGain();
                    osc.type = 'sawtooth';
                    osc.frequency.value = freq;
                    gain.gain.setValueAtTime(0.3, this.ctx.currentTime + i * 0.18);
                    gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + (i + 1) * 0.18);
                    osc.connect(gain);
                    gain.connect(this.ctx.destination);
                    osc.start(this.ctx.currentTime + i * 0.18);
                    osc.stop(this.ctx.currentTime + (i + 1) * 0.18);
                });
            }
        }

        const sfx = new SoundFX();

        // Canvas Setup
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        const overlay = document.getElementById('overlayMsg');

        // Opponents Roster Definition (4 ascending difficulty fighters + 1 Dictator Boss)
        const OPPONENTS = [
            {
                id: 1,
                name: "SPIKE (ROOKIE)",
                title: "STAGE 1: STREET PUNK",
                difficulty: "EASY",
                shirtColor: "#e74c3c",
                pantsColor: "#2c3e50",
                skinColor: "#ffcc99",
                hairColor: "#f1c40f",
                maxHealth: 100,
                damageMult: 0.8,
                speed: 1.6,
                aiAggression: 0.03,
                isBoss: false
            },
            {
                id: 2,
                name: "BRUNO (BRAWLER)",
                title: "STAGE 2: ALLEY CHAMP",
                difficulty: "MEDIUM",
                shirtColor: "#2ecc71",
                pantsColor: "#34495e",
                skinColor: "#e0ac69",
                hairColor: "#2c3e50",
                maxHealth: 115,
                damageMult: 1.0,
                speed: 2.0,
                aiAggression: 0.05,
                isBoss: false
            },
            {
                id: 3,
                name: "DUKE (HEAVYWEIGHT)",
                title: "STAGE 3: IRON DUKE",
                difficulty: "HARD",
                shirtColor: "#f39c12",
                pantsColor: "#1e272e",
                skinColor: "#8d5524",
                hairColor: "#ffffff",
                maxHealth: 130,
                damageMult: 1.25,
                speed: 2.3,
                aiAggression: 0.07,
                isBoss: false
            },
            {
                id: 4,
                name: "KAGE (SHADOW)",
                title: "STAGE 4: SHADOW NINJA",
                difficulty: "EXPERT",
                shirtColor: "#8e44ad",
                pantsColor: "#2c3e50",
                skinColor: "#f5cda7",
                hairColor: "#111111",
                maxHealth: 140,
                damageMult: 1.4,
                speed: 2.7,
                aiAggression: 0.09,
                isBoss: false
            },
            {
                id: 5,
                name: "GEN. IRONCLAD",
                title: "FINAL BOSS: THE DICTATOR",
                difficulty: "BOSS",
                shirtColor: "#3b4d28", // Vintage Military Olive Uniform
                pantsColor: "#253318",
                skinColor: "#d2b48c",
                hairColor: "#4a3c31",
                maxHealth: 165,
                damageMult: 1.7,
                speed: 2.9,
                aiAggression: 0.11,
                isBoss: true // Vintage Dictator with military uniform, cap, epaulets & moustache
            }
        ];

        // Game State Variables
        let currentStageIndex = 0;
        let gameState = 'TITLE'; // TITLE, STAGE_INTRO, PLAYING, ROUND_OVER, STAGE_CLEAR, GAME_OVER, GAME_VICTORY
        let timer = 99;
        let timerInterval = null;
        let p1ScoreVal = 0;
        let p2ScoreVal = 0;
        let titleFrame = 0;

        // Fighter Objects
        const p1 = {
            name: "URBAN CHAMP",
            x: 140,
            y: 240,
            width: 44,
            height: 72,
            color: '#3498db',
            skinColor: '#ffcc99',
            hairColor: '#5c3a21',
            health: 100,
            maxHealth: 100,
            state: 'IDLE', // IDLE, WALK, PUNCH_LIGHT, PUNCH_HEAVY, BLOCK, HIT, KO
            frame: 0,
            facing: 1,
            cooldown: 0
        };

        const p2 = {
            name: OPPONENTS[0].name,
            x: 320,
            y: 240,
            width: 44,
            height: 72,
            color: OPPONENTS[0].shirtColor,
            pantsColor: OPPONENTS[0].pantsColor,
            skinColor: OPPONENTS[0].skinColor,
            hairColor: OPPONENTS[0].hairColor,
            health: 100,
            maxHealth: 100,
            state: 'IDLE',
            frame: 0,
            facing: -1,
            cooldown: 0,
            isBoss: false
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

        // Keyboard Controls
        const keys = {};

        window.addEventListener('keydown', (e) => {
            sfx.init();
            keys[e.code] = true;
            if (e.code === 'Enter' || e.code === 'Space') {
                if (gameState === 'TITLE' || gameState === 'GAME_OVER' || gameState === 'GAME_VICTORY') {
                    startNextGame();
                }
            }
        });

        window.addEventListener('keyup', (e) => {
            keys[e.code] = false;
        });

        // Touch & Button Click Listeners
        document.getElementById('btnStartGame').addEventListener('click', () => {
            sfx.init();
            if (gameState === 'TITLE' || gameState === 'GAME_OVER' || gameState === 'GAME_VICTORY') {
                startNextGame();
            }
        });

        document.getElementById('btnLeft').addEventListener('touchstart', (e) => { e.preventDefault(); keys['ArrowLeft'] = true; });
        document.getElementById('btnLeft').addEventListener('touchend', (e) => { e.preventDefault(); keys['ArrowLeft'] = false; });
        document.getElementById('btnRight').addEventListener('touchstart', (e) => { e.preventDefault(); keys['ArrowRight'] = true; });
        document.getElementById('btnRight').addEventListener('touchend', (e) => { e.preventDefault(); keys['ArrowRight'] = false; });
        
        document.getElementById('btnLight').addEventListener('click', () => { sfx.init(); if(gameState==='PLAYING') triggerPunch(p1, false); });
        document.getElementById('btnHeavy').addEventListener('click', () => { sfx.init(); if(gameState==='PLAYING') triggerPunch(p1, true); });
        document.getElementById('btnBlock').addEventListener('touchstart', (e) => { e.preventDefault(); keys['Space'] = true; });
        document.getElementById('btnBlock').addEventListener('touchend', (e) => { e.preventDefault(); keys['Space'] = false; });

        function startNextGame() {
            sfx.playStart();
            if (gameState === 'GAME_OVER' || gameState === 'GAME_VICTORY') {
                currentStageIndex = 0;
                p1ScoreVal = 0;
            }
            loadStage(currentStageIndex);
        }

        function loadStage(stageIdx) {
            const oppData = OPPONENTS[stageIdx];
            gameState = 'STAGE_INTRO';
            
            p1.health = p1.maxHealth;
            p1.x = 140;
            p1.state = 'IDLE';

            p2.name = oppData.name;
            p2.color = oppData.shirtColor;
            p2.pantsColor = oppData.pantsColor;
            p2.skinColor = oppData.skinColor;
            p2.hairColor = oppData.hairColor;
            p2.health = oppData.maxHealth;
            p2.maxHealth = oppData.maxHealth;
            p2.x = 320;
            p2.state = 'IDLE';
            p2.isBoss = oppData.isBoss;

            document.getElementById('p2Name').innerText = oppData.name;
            document.getElementById('stageLabel').innerText = `STAGE ${stageIdx + 1}/5`;

            updateHUD();

            overlay.innerHTML = `<div style="font-size:1.4rem; color:#66fcf1;">${oppData.title}</div><div style="font-size:0.8rem; margin-top:10px; color:#ffd700;">VS ${oppData.name}</div>`;
            overlay.style.display = 'block';

            setTimeout(() => {
                if (gameState === 'STAGE_INTRO') {
                    gameState = 'PLAYING';
                    overlay.style.display = 'none';
                    startTimer();
                }
            }, 2500);
        }

        function startTimer() {
            timer = 99;
            if (timerInterval) clearInterval(timerInterval);
            timerInterval = setInterval(() => {
                if (gameState === 'PLAYING') {
                    timer--;
                    document.getElementById('gameTimer').innerText = timer < 10 ? '0' + timer : timer;
                    if (timer <= 0) {
                        endRound('TIME OUT!');
                    }
                    if (timer > 20 && Math.random() < 0.03 && !street.policeActive) {
                        triggerPolicePatrol();
                    }
                }
            }, 1000);
        }

        function triggerPunch(fighter, isHeavy) {
            if (fighter.state === 'IDLE' || fighter.state === 'WALK') {
                fighter.state = isHeavy ? 'PUNCH_HEAVY' : 'PUNCH_LIGHT';
                fighter.cooldown = isHeavy ? 22 : 12;
                sfx.playPunch(isHeavy);
                
                const opponent = (fighter === p1) ? p2 : p1;
                const dist = Math.abs(fighter.x - opponent.x);
                if (dist < 55) {
                    if (opponent.state === 'BLOCK') {
                        sfx.playBlock();
                        opponent.x += fighter.facing * 8;
                    } else {
                        sfx.playHit();
                        opponent.state = 'HIT';
                        opponent.cooldown = 16;

                        const baseDamage = isHeavy ? 20 : 10;
                        const mult = (fighter === p2) ? OPPONENTS[currentStageIndex].damageMult : 1.0;
                        const finalDamage = Math.round(baseDamage * mult);
                        const knockback = isHeavy ? 35 : 18;

                        opponent.health = Math.max(0, opponent.health - finalDamage);
                        opponent.x += fighter.facing * knockback;

                        if (fighter === p1) p1ScoreVal += isHeavy ? 250 : 100;
                        else p2ScoreVal += isHeavy ? 250 : 100;

                        // Sewer Fall Win Condition
                        if (opponent.x >= street.manholeX - 10 && opponent.x <= street.manholeX + street.manholeWidth) {
                            opponent.state = 'KO';
                            sfx.playWin();
                            setTimeout(() => processStageVictory(fighter === p1), 800);
                            return;
                        }

                        if (opponent.health <= 0) {
                            opponent.state = 'KO';
                            sfx.playWin();
                            setTimeout(() => processStageVictory(fighter === p1), 800);
                        }
                    }
                }
            }
        }

        function processStageVictory(isP1Winner) {
            clearInterval(timerInterval);
            if (isP1Winner) {
                if (currentStageIndex < OPPONENTS.length - 1) {
                    currentStageIndex++;
                    overlay.innerHTML = `<div style="color:#66fcf1; font-size:1.3rem;">STAGE DEFEATED!</div><div style="font-size:0.75rem; margin-top:10px; color:#ffe600;">GET READY FOR NEXT OPPONENT</div>`;
                    overlay.style.display = 'block';
                    gameState = 'STAGE_CLEAR';
                    setTimeout(() => loadStage(currentStageIndex), 3000);
                } else {
                    // Defeated Dictator Boss
                    gameState = 'GAME_VICTORY';
                    overlay.innerHTML = `<div style="color:#ffd700; font-size:1.4rem;">🏆 VICTORY! 🏆</div><div style="font-size:0.7rem; margin-top:12px; color:#fff;">YOU DEFEATED THE DICTATOR GENERAL IRONCLAD!</div><div style="font-size:0.65rem; margin-top:10px; color:#66fcf1;">CITY IS LIBERATED! PRESS START TO RESTART</div>`;
                    overlay.style.display = 'block';
                }
            } else {
                gameState = 'GAME_OVER';
                sfx.playGameOver();
                overlay.innerHTML = `<div style="color:#ff3366; font-size:1.5rem;">GAME OVER</div><div style="font-size:0.7rem; margin-top:10px; color:#fff;">PRESS START TO RETRY STAGE 1</div>`;
                overlay.style.display = 'block';
            }
        }

        function triggerPolicePatrol() {
            street.policeActive = true;
            street.policeCarX = -150;
            sfx.playSiren();
            overlay.innerText = '🚨 POLICE PATROL INCOMING! 🚨';
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
                if (p1.health > p2.health) processStageVictory(true);
                else processStageVictory(false);
            }, 2500);
        }

        function updateHUD() {
            document.getElementById('p1Health').style.width = (p1.health / p1.maxHealth * 100) + '%';
            document.getElementById('p2Health').style.width = (p2.health / p2.maxHealth * 100) + '%';
            document.getElementById('p1Score').innerText = String(p1ScoreVal).padStart(5, '0');
            document.getElementById('p2Score').innerText = String(p2ScoreVal).padStart(5, '0');
        }

        // Game AI & Physics Updates
        function updateGame() {
            if (gameState !== 'PLAYING') return;

            // Player 1 Control
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

            // CPU AI Engine scaled with difficulty
            const oppConfig = OPPONENTS[currentStageIndex];
            if (p2.cooldown > 0) {
                p2.cooldown--;
                if (p2.cooldown === 0 && p2.state !== 'KO') p2.state = 'IDLE';
            } else {
                const distance = Math.abs(p1.x - p2.x);
                if (distance > 50) {
                    p2.x -= oppConfig.speed;
                    p2.state = 'WALK';
                } else {
                    const aiChoice = Math.random();
                    if (aiChoice < oppConfig.aiAggression) {
                        triggerPunch(p2, false);
                    } else if (aiChoice < oppConfig.aiAggression + 0.04) {
                        triggerPunch(p2, true);
                    } else if (aiChoice < oppConfig.aiAggression + 0.08) {
                        p2.state = 'BLOCK';
                    } else {
                        p2.state = 'IDLE';
                    }
                }
            }

            // Keep in arena
            p1.x = Math.max(street.leftBoundary, Math.min(street.rightBoundary, p1.x));
            p2.x = Math.max(street.leftBoundary, Math.min(street.rightBoundary, p2.x));

            // Police Car Patrol Movement
            if (street.policeActive) {
                street.policeCarX += 7;
                if (street.policeCarX > canvas.width + 100) {
                    street.policeActive = false;
                }
            }

            updateHUD();
        }

        // Retro Drawing Functions
        function drawVintageTitleScreen() {
            titleFrame++;

            // Dark CRT Title Screen Background
            ctx.fillStyle = '#050814';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // 8-Bit Pixel City Skyline Silhouette
            ctx.fillStyle = '#101728';
            ctx.fillRect(20, 160, 60, 150);
            ctx.fillRect(90, 120, 80, 190);
            ctx.fillRect(190, 140, 70, 170);
            ctx.fillRect(280, 100, 90, 210);
            ctx.fillRect(390, 150, 70, 160);

            // Glowing City Windows
            ctx.fillStyle = (titleFrame % 60 < 30) ? '#f8c210' : '#45a29e';
            ctx.fillRect(105, 140, 15, 20);
            ctx.fillRect(135, 140, 15, 20);
            ctx.fillRect(300, 120, 20, 25);
            ctx.fillRect(330, 120, 20, 25);
            ctx.fillRect(300, 170, 20, 25);

            // Big 8-Bit Title Box
            ctx.fillStyle = '#e74c3c';
            ctx.fillRect(40, 40, 432, 70);
            ctx.strokeStyle = '#f1c40f';
            ctx.lineWidth = 6;
            ctx.strokeRect(36, 36, 440, 78);

            ctx.fillStyle = '#66fcf1';
            ctx.font = '24px "Press Start 2P"';
            ctx.textAlign = 'center';
            ctx.shadowColor = '#000';
            ctx.shadowOffsetX = 4;
            ctx.shadowOffsetY = 4;
            ctx.fillText("8bitCityChamp", canvas.width / 2, 85);

            ctx.font = '10px "Press Start 2P"';
            ctx.fillStyle = '#ffd700';
            ctx.fillText("VINTAGE URBAN CHAMPION NES EDITION", canvas.width / 2, 140);

            // Blinking PRESS START Prompt
            if (Math.floor(titleFrame / 30) % 2 === 0) {
                ctx.fillStyle = '#ffffff';
                ctx.font = '12px "Press Start 2P"';
                ctx.fillText("PRESS START TO PLAY", canvas.width / 2, 230);
            }

            // Dictator Boss Preview Banner
            ctx.fillStyle = '#181c26';
            ctx.fillRect(60, 270, 392, 70);
            ctx.strokeStyle = '#ffd700';
            ctx.lineWidth = 3;
            ctx.strokeRect(60, 270, 392, 70);

            ctx.fillStyle = '#ff3366';
            ctx.font = '9px "Press Start 2P"';
            ctx.fillText("5 STAGES • FINAL BOSS: GENERAL IRONCLAD", canvas.width / 2, 295);
            ctx.fillStyle = '#888';
            ctx.font = '8px "Press Start 2P"';
            ctx.fillText("DEFEAT THE VINTAGE MILITARY DICTATOR!", canvas.width / 2, 320);

            ctx.shadowOffsetX = 0;
            ctx.shadowOffsetY = 0;
        }

        function drawBackground() {
            // Night Sky
            ctx.fillStyle = '#0f1423';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Brick Buildings
            ctx.fillStyle = '#2d1b36';
            ctx.fillRect(0, 40, canvas.width, 220);

            ctx.fillStyle = '#4a2e56';
            ctx.fillRect(30, 70, 90, 80);
            ctx.fillRect(200, 70, 110, 80);
            ctx.fillRect(380, 70, 90, 80);

            ctx.fillStyle = '#f8c210';
            ctx.fillRect(45, 85, 25, 30);
            ctx.fillRect(80, 85, 25, 30);
            ctx.fillRect(215, 85, 35, 30);
            ctx.fillRect(260, 85, 35, 30);

            // Neon Signboards
            ctx.fillStyle = '#e74c3c';
            ctx.fillRect(20, 50, 110, 16);
            ctx.fillStyle = '#fff';
            ctx.font = '10px "Press Start 2P"';
            ctx.textAlign = 'left';
            ctx.fillText('BAR', 55, 63);

            ctx.fillStyle = '#3498db';
            ctx.fillRect(190, 50, 130, 16);
            ctx.fillStyle = '#fff';
            ctx.fillText('CLUB', 225, 63);

            // Sidewalk
            ctx.fillStyle = '#7f8c8d';
            ctx.fillRect(0, 260, canvas.width, 15);
            ctx.fillStyle = '#bdc3c7';
            ctx.fillRect(0, 260, canvas.width, 3);

            // Road Asphalt
            ctx.fillStyle = '#1e272e';
            ctx.fillRect(0, 275, canvas.width, 110);

            // Sewer Pit
            ctx.fillStyle = '#0f171e';
            ctx.beginPath();
            ctx.ellipse(street.manholeX + 25, 320, 25, 8, 0, 0, Math.PI * 2);
            ctx.fill();
            ctx.strokeStyle = '#485460';
            ctx.lineWidth = 3;
            ctx.stroke();

            // Police Car Patrol
            if (street.policeActive) {
                drawPoliceCar(street.policeCarX, 290);
            }
        }

        function drawPoliceCar(x, y) {
            ctx.fillStyle = '#000';
            ctx.fillRect(x, y, 100, 35);
            ctx.fillStyle = '#fff';
            ctx.fillRect(x + 20, y, 60, 18);
            ctx.fillStyle = Math.floor(Date.now() / 150) % 2 === 0 ? '#ff0000' : '#00ffff';
            ctx.fillRect(x + 45, y - 8, 12, 8);
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

            // Hair / Headgear
            if (f.isBoss) {
                // Dictator Military Officer Peak Cap (Vintage Dictator Hat with Gold Medal Star)
                ctx.fillStyle = '#222d17'; // Dark Military Green Hat Base
                ctx.fillRect(6, -8, 32, 10);
                ctx.fillStyle = '#111'; // Visor
                ctx.fillRect(4, 0, 36, 4);
                ctx.fillStyle = '#ffd700'; // Dictator Gold Star Badge
                ctx.fillRect(19, -6, 6, 6);
            } else {
                ctx.fillStyle = f.hairColor;
                ctx.fillRect(8, -4, 28, 10);
            }

            // Dictator Moustache
            if (f.isBoss) {
                ctx.fillStyle = '#222';
                ctx.fillRect(12, 12, 20, 5); // Vintage Dictator Moustache
            }

            // Eyes
            ctx.fillStyle = '#000';
            if (f.facing === 1) ctx.fillRect(24, 6, 4, 4);
            else ctx.fillRect(16, 6, 4, 4);

            // Body / Uniform Shirt
            ctx.fillStyle = f.color;
            ctx.fillRect(8, 20, 28, 30);

            // Dictator Uniform Gold Epaulets, Medals & Belt
            if (f.isBoss) {
                // Golden Epaulets on shoulders
                ctx.fillStyle = '#ffd700';
                ctx.fillRect(4, 18, 8, 6);
                ctx.fillRect(32, 18, 8, 6);

                // Military Medals on chest
                ctx.fillStyle = '#e74c3c'; ctx.fillRect(12, 24, 4, 4);
                ctx.fillStyle = '#3498db'; ctx.fillRect(18, 24, 4, 4);
                ctx.fillStyle = '#f1c40f'; ctx.fillRect(24, 24, 4, 4);

                // Military Belt & Gold Buckle
                ctx.fillStyle = '#111'; ctx.fillRect(8, 44, 28, 6);
                ctx.fillStyle = '#ffd700'; ctx.fillRect(18, 43, 8, 8);
            }

            // Pants
            ctx.fillStyle = f.pantsColor || '#2c3e50';
            ctx.fillRect(10, 50, 24, 22);

            // Arms & Combat Stances
            ctx.fillStyle = f.skinColor;
            if (f.state === 'PUNCH_LIGHT') {
                ctx.fillRect(f.facing === 1 ? 28 : -14, 22, 24, 10);
            } else if (f.state === 'PUNCH_HEAVY') {
                ctx.fillRect(f.facing === 1 ? 28 : -20, 20, 30, 14);
                if (f.isBoss) { // Heavy Boss Glow
                    ctx.fillStyle = '#ffd700';
                    ctx.fillRect(f.facing === 1 ? 52 : -24, 18, 8, 18);
                }
            } else if (f.state === 'BLOCK') {
                ctx.fillRect(14, 14, 16, 16);
            } else if (f.state === 'HIT') {
                ctx.rotate((f.facing * -15 * Math.PI) / 180);
                ctx.fillRect(4, 24, 12, 12);
            } else {
                ctx.fillRect(4, 24, 10, 12);
                ctx.fillRect(30, 24, 10, 12);
            }

            if (f.state === 'KO') {
                ctx.translate(0, 30);
            }

            ctx.restore();
        }

        function render() {
            if (gameState === 'TITLE') {
                drawVintageTitleScreen();
                document.getElementById('hudBar').style.display = 'none';
            } else {
                document.getElementById('hudBar').style.display = 'flex';
                drawBackground();
                drawFighter(p1);
                drawFighter(p2);
            }
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

echo "=== 8bitCityChamp Startup Script Completed Successfully (Feature2Game) at $(date) ==="
