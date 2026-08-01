#!/bin/bash
set -e

# Logging setup
exec > >(tee -a /var/log/startup-script.log) 2>&1
echo "=== Starting 8bitCityChamp Startup Script (Mobile + Ambient NPCs Edition): $(date) ==="

# Update package list and install Nginx & curl
apt-get update -y
apt-get install -y nginx curl git

# Remove default Nginx index page
rm -rf /var/www/html/*

# Create Ultra Detailed 16-Bit Arcade Web Application with Mobile Touch Controls & Ambient Street NPCs
cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>8bitCityChamp - 16-Bit Mobile Arcade Edition</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #030407;
            --arcade-border: #141b26;
            --neon-blue: #00d2d3;
            --neon-green: #54a0ff;
            --neon-red: #ff4757;
            --neon-yellow: #feca57;
            --dictator-gold: #ffdd59;
            --snes-purple: #5f27cd;
        }

        * {
            box-sizing: border-box;
            user-select: none;
            -webkit-user-select: none;
            touch-action: manipulation;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--bg-color);
            background-image: 
                radial-gradient(circle at 50% 20%, #131c30 0%, #04060c 60%, #010204 100%);
            color: #ffffff;
            font-family: 'Press Start 2P', monospace, cursive;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 8px;
            overflow-x: hidden;
        }

        /* Arcade Header */
        header {
            text-align: center;
            margin-bottom: 8px;
        }

        .logo-title {
            font-size: 1.8rem;
            color: #54a0ff;
            text-shadow: 
                3px 3px 0px #000,
                -2px -2px 0px #ff4757,
                0 0 20px #54a0ff;
            letter-spacing: 2px;
            margin-bottom: 4px;
            animation: pulse-title 2s infinite alternate;
        }

        @keyframes pulse-title {
            0% { text-shadow: 3px 3px 0px #000, -2px -2px 0px #ff4757, 0 0 10px #54a0ff; }
            100% { text-shadow: 3px 3px 0px #000, -2px -2px 0px #ff4757, 0 0 25px #00d2d3; }
        }

        .subtitle {
            font-size: 0.58rem;
            color: var(--neon-yellow);
            letter-spacing: 1.2px;
        }

        /* Arcade Cabinet Frame */
        .arcade-cabinet {
            position: relative;
            background: #0b0e16;
            border: 10px solid #1a2332;
            border-radius: 16px;
            box-shadow: 
                0 0 0 4px #000,
                0 20px 50px rgba(0,0,0,0.95),
                inset 0 0 25px rgba(0,0,0,0.85);
            padding: 12px;
            max-width: 860px;
            width: 100%;
        }

        /* CRT Screen Shell */
        .crt-screen {
            position: relative;
            background: #000;
            border: 5px solid #06080e;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: inset 0 0 35px rgba(0,0,0,1);
        }

        /* CRT Scanline Effect */
        .crt-screen::before {
            content: " ";
            display: block;
            position: absolute;
            top: 0; left: 0; bottom: 0; right: 0;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.3) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.02), rgba(0, 255, 0, 0.01), rgba(0, 0, 255, 0.02));
            z-index: 10;
            background-size: 100% 4px, 6px 100%;
            pointer-events: none;
        }

        /* Top Bar for BGM Music Control */
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #07090e;
            padding: 6px 12px;
            border-bottom: 2px solid #161f2e;
            font-size: 0.55rem;
        }

        .music-toggle-btn {
            background: #1a2534;
            color: #feca57;
            border: 2px solid #54a0ff;
            padding: 5px 10px;
            font-family: inherit;
            font-size: 0.52rem;
            border-radius: 6px;
            cursor: pointer;
            box-shadow: 0 2px 0 #000;
        }

        .music-toggle-btn:active {
            transform: translateY(2px);
        }

        /* Game HUD Bar */
        .hud-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #030407;
            padding: 8px 12px;
            border-bottom: 4px solid #141c28;
            font-size: 0.6rem;
            z-index: 5;
            position: relative;
        }

        .hud-player {
            display: flex;
            flex-direction: column;
            gap: 4px;
            width: 38%;
        }

        .player-name {
            display: flex;
            justify-content: space-between;
            font-size: 0.55rem;
        }

        .p1-color { color: #54a0ff; }
        .p2-color { color: #ff4757; }

        .health-bar-container {
            width: 100%;
            height: 16px;
            background: #161d24;
            border: 2px solid #fff;
            position: relative;
            box-shadow: inset 0 0 6px #000;
        }

        .health-bar-fill {
            height: 100%;
            width: 100%;
            background: linear-gradient(90deg, #ff4757 0%, #ff9f43 50%, #10ac84 100%);
            transition: width 0.15s ease-out;
        }

        .hud-center {
            text-align: center;
            width: 24%;
        }

        .hud-timer {
            font-size: 1.2rem;
            color: #fff;
            text-shadow: 2px 2px #ff4757;
        }

        .hud-stage {
            font-size: 0.52rem;
            color: #feca57;
            margin-top: 2px;
        }

        /* Canvas Game Arena */
        canvas#gameCanvas {
            display: block;
            width: 100%;
            height: auto;
            background: #000;
            image-rendering: pixelated;
        }

        /* Mobile Touch Controls Container */
        .mobile-controls {
            display: flex;
            margin-top: 10px;
            width: 100%;
            justify-content: space-between;
            gap: 8px;
        }

        .btn-group {
            display: flex;
            gap: 6px;
        }

        .retro-btn {
            background: linear-gradient(180deg, #263544, #141b20);
            color: #fff;
            border: 2px solid #3c526d;
            padding: 12px 14px;
            font-family: inherit;
            font-size: 0.6rem;
            border-radius: 8px;
            box-shadow: 0 3px 0 #090d13;
            cursor: pointer;
            flex: 1;
            text-align: center;
        }

        .retro-btn:active {
            transform: translateY(2px);
            box-shadow: 0 1px 0 #090d13;
        }

        .btn-start { background: linear-gradient(180deg, #10ac84, #01a3a4); border-color: #55efc4; font-weight: bold; width: 100%; margin-top: 8px; padding: 12px; font-size: 0.75rem; }
        .btn-punch { background: linear-gradient(180deg, #ee5253, #10ac84); border-color: #ff6b6b; }
        .btn-kick { background: linear-gradient(180deg, #10ac84, #0fb9b1); border-color: #55efc4; }
        .btn-heavy { background: linear-gradient(180deg, #ff9f43, #ee5253); border-color: #feca57; }
        .btn-block { background: linear-gradient(180deg, #2e86de, #5f27cd); border-color: #54a0ff; }

        /* Controls Panel for Desktop */
        .controls-panel {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-top: 14px;
            background: #0e121c;
            padding: 12px;
            border-radius: 8px;
            border: 2px solid #1d2534;
        }

        .control-group {
            font-size: 0.55rem;
            line-height: 1.6;
        }

        .control-group h3 {
            color: #54a0ff;
            font-size: 0.62rem;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .key-badge {
            background: #202b3a;
            color: #fff;
            padding: 2px 5px;
            border-radius: 4px;
            border: 1px solid #36465c;
            box-shadow: 0 2px 0 #0a0e16;
        }

        @media (max-width: 768px) {
            .logo-title { font-size: 1.2rem; }
            .controls-panel { display: none; }
            .retro-btn { padding: 14px 12px; font-size: 0.62rem; }
        }

        /* Footer Info */
        footer {
            margin-top: 12px;
            text-align: center;
            font-size: 0.55rem;
            color: #777;
        }

        footer span {
            color: #54a0ff;
        }

        /* Overlay Messages */
        .overlay-msg {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 1.1rem;
            color: #feca57;
            text-shadow: 4px 4px 0 #000, -2px -2px 0 #ff4757;
            text-align: center;
            z-index: 20;
            pointer-events: none;
            display: none;
            width: 92%;
            line-height: 1.5;
        }
    </style>
</head>
<body>

    <header>
        <h1 class="logo-title">8bitCityChamp</h1>
        <p class="subtitle">MOBILE TOUCH GAMEPAD & STREET AMBIENT NPCs</p>
    </header>

    <main class="arcade-cabinet">
        <div class="top-bar">
            <span>16-BIT SNES SOUNDTRACK</span>
            <button class="music-toggle-btn" id="btnToggleMusic">🎵 BGM MUSIC: ON</button>
        </div>

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

        <!-- Mobile Touch Controls -->
        <div class="mobile-controls">
            <div class="btn-group" style="width: 40%;">
                <button class="retro-btn" id="btnLeft">◄ LEFT</button>
                <button class="retro-btn" id="btnRight">RIGHT ►</button>
            </div>
            <div class="btn-group" style="width: 60%;">
                <button class="retro-btn btn-punch" id="btnLight">JAB</button>
                <button class="retro-btn btn-kick" id="btnKick">KICK</button>
                <button class="retro-btn btn-heavy" id="btnHeavy">HEAVY</button>
                <button class="retro-btn btn-block" id="btnBlock">BLOCK</button>
            </div>
        </div>

        <!-- Controls Guide for Desktop -->
        <div class="controls-panel">
            <div class="control-group">
                <h3>🎮 CONTROLS (PLAYER 1)</h3>
                <p><span class="key-badge">◄</span> / <span class="key-badge">►</span> or <span class="key-badge">A</span> / <span class="key-badge">D</span> : Walk Left / Right</p>
                <p><span class="key-badge">Z</span> or <span class="key-badge">J</span> : Fast Jab Punch (12 DMG)</p>
                <p><span class="key-badge">C</span> or <span class="key-badge">L</span> : 💥 High Kick Attack (18 DMG)</p>
                <p><span class="key-badge">X</span> or <span class="key-badge">K</span> : Heavy Hook Punch (25 DMG + Blood FX)</p>
                <p><span class="key-badge">SPACE</span> or <span class="key-badge">S</span> : Block / Guard</p>
            </div>
            <div class="control-group">
                <h3>🌆 STREET AMBIENT NPCs & MOBILE UX</h3>
                <p>• <strong>Fast Street Walker & Staggering Drunkard</strong> NPCs in background!</p>
                <p>• <strong>Full Mobile Support:</strong> Touch D-Pad & Action Gamepad Buttons.</p>
                <p>• <strong>5 Fighters & Dictator Boss:</strong> General Ironclad (Stage 5).</p>
                <p>• Deployed on GCP Compute Engine via Terraform.</p>
            </div>
        </div>
    </main>

    <footer>
        <p>POWERED BY <span>GOOGLE CLOUD PLATFORM</span> & <span>TERRAFORM</span> | Mobile 16-Bit Edition</p>
    </footer>

    <script>
        // 16-Bit SNES Audio & Synth Engine
        class AudioEngine {
            constructor() {
                this.ctx = null;
                this.bgmEnabled = true;
                this.bgmTimer = null;
                this.noteIndex = 0;
            }
            init() {
                if (!this.ctx) {
                    this.ctx = new (window.AudioContext || window.webkitAudioContext)();
                }
                if (this.ctx.state === 'suspended') {
                    this.ctx.resume();
                }
            }
            toggleBGM() {
                this.bgmEnabled = !this.bgmEnabled;
                if (!this.bgmEnabled && this.bgmTimer) {
                    clearInterval(this.bgmTimer);
                    this.bgmTimer = null;
                } else if (this.bgmEnabled) {
                    this.startBGM();
                }
                return this.bgmEnabled;
            }
            startBGM() {
                if (!this.bgmEnabled) return;
                this.init();
                if (this.bgmTimer) clearInterval(this.bgmTimer);

                const melody = [
                    155.56, 207.65, 233.08, 311.13, 207.65, 233.08, 155.56, 207.65,
                    174.61, 220.00, 261.63, 349.23, 220.00, 261.63, 174.61, 220.00,
                    196.00, 246.94, 293.66, 392.00, 246.94, 293.66, 196.00, 246.94,
                    155.56, 207.65, 233.08, 311.13, 233.08, 311.13, 349.23, 415.30
                ];

                this.bgmTimer = setInterval(() => {
                    if (!this.ctx || !this.bgmEnabled) return;
                    
                    const freq = melody[this.noteIndex % melody.length];
                    this.noteIndex++;

                    const osc = this.ctx.createOscillator();
                    const gain = this.ctx.createGain();
                    osc.type = 'square';
                    osc.frequency.setValueAtTime(freq, this.ctx.currentTime);
                    gain.gain.setValueAtTime(0.06, this.ctx.currentTime);
                    gain.gain.exponentialRampToValueAtTime(0.001, this.ctx.currentTime + 0.16);
                    osc.connect(gain);
                    gain.connect(this.ctx.destination);
                    osc.start();
                    osc.stop(this.ctx.currentTime + 0.16);

                    const bassOsc = this.ctx.createOscillator();
                    const bassGain = this.ctx.createGain();
                    bassOsc.type = 'sawtooth';
                    bassOsc.frequency.setValueAtTime(freq / 2, this.ctx.currentTime);
                    bassGain.gain.setValueAtTime(0.08, this.ctx.currentTime);
                    bassGain.gain.exponentialRampToValueAtTime(0.001, this.ctx.currentTime + 0.18);
                    bassOsc.connect(bassGain);
                    bassGain.connect(this.ctx.destination);
                    bassOsc.start();
                    bassOsc.stop(this.ctx.currentTime + 0.18);

                }, 180);
            }
            playStart() {
                if (!this.ctx) return;
                const notes = [220, 277.18, 329.63, 440, 554.37];
                notes.forEach((freq, i) => {
                    const osc = this.ctx.createOscillator();
                    const gain = this.ctx.createGain();
                    osc.type = 'triangle';
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
                osc.frequency.setValueAtTime(isHeavy ? 140 : 280, this.ctx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(30, this.ctx.currentTime + 0.15);
                gain.gain.setValueAtTime(0.35, this.ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + 0.15);
                osc.connect(gain);
                gain.connect(this.ctx.destination);
                osc.start();
                osc.stop(this.ctx.currentTime + 0.15);
            }
            playKick() {
                if (!this.ctx) return;
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();
                osc.type = 'sawtooth';
                osc.frequency.setValueAtTime(220, this.ctx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(40, this.ctx.currentTime + 0.18);
                gain.gain.setValueAtTime(0.4, this.ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + 0.18);
                osc.connect(gain);
                gain.connect(this.ctx.destination);
                osc.start();
                osc.stop(this.ctx.currentTime + 0.18);
            }
            playHit(isHeavy) {
                if (!this.ctx) return;
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();
                osc.type = 'sawtooth';
                osc.frequency.setValueAtTime(isHeavy ? 110 : 160, this.ctx.currentTime);
                osc.frequency.linearRampToValueAtTime(30, this.ctx.currentTime + 0.22);
                gain.gain.setValueAtTime(0.45, this.ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + 0.22);
                osc.connect(gain);
                gain.connect(this.ctx.destination);
                osc.start();
                osc.stop(this.ctx.currentTime + 0.22);
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
                osc.frequency.linearRampToValueAtTime(950, this.ctx.currentTime + 0.25);
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
                const notes = [261.63, 329.63, 392.00, 523.25, 659.25, 783.99];
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
                const notes = [320, 260, 210, 150];
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

        const audio = new AudioEngine();

        // Canvas Setup
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        const overlay = document.getElementById('overlayMsg');

        // Particle System (Blood & Sparks)
        const hitParticles = [];
        const damageTexts = [];

        function spawnBloodParticles(x, y, isHeavy) {
            const count = isHeavy ? 24 : 12;
            for (let i = 0; i < count; i++) {
                hitParticles.push({
                    x: x + (Math.random() * 20 - 10),
                    y: y + (Math.random() * 20 - 10),
                    vx: (Math.random() - 0.5) * (isHeavy ? 10 : 6),
                    vy: (Math.random() - 0.7) * (isHeavy ? 9 : 5),
                    size: Math.random() * (isHeavy ? 5 : 3) + 2,
                    color: Math.random() < 0.85 ? '#ff4757' : '#ff6b6b',
                    life: 28
                });
            }
        }

        function spawnDamageText(x, y, amount) {
            damageTexts.push({
                x: x,
                y: y - 10,
                text: '-' + amount,
                vy: -1.5,
                alpha: 1.0,
                life: 32
            });
        }

        // Screen Shake FX
        let screenShakeTime = 0;

        function triggerScreenShake() {
            screenShakeTime = 8;
        }

        // Ambient Background Pedestrians (Street Walker & Staggering Drunkard)
        const ambientNPCs = {
            walker: {
                active: false,
                x: -50,
                y: 228,
                speed: 4.8
            },
            drunkard: {
                active: false,
                x: 560,
                y: 232,
                speed: -1.2,
                staggerOffset: 0
            }
        };

        // Opponents Definition
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
                speed: 1.7,
                aiAggression: 0.03,
                type: "PUNK"
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
                speed: 2.1,
                aiAggression: 0.05,
                type: "BRAWLER"
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
                speed: 2.4,
                aiAggression: 0.07,
                type: "BOXER"
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
                maxHealth: 145,
                damageMult: 1.45,
                speed: 2.8,
                aiAggression: 0.09,
                type: "NINJA"
            },
            {
                id: 5,
                name: "GEN. IRONCLAD",
                title: "FINAL BOSS: THE DICTATOR",
                difficulty: "BOSS",
                shirtColor: "#2d381c",
                pantsColor: "#1c2411",
                skinColor: "#d2b48c",
                hairColor: "#4a3c31",
                maxHealth: 175,
                damageMult: 1.8,
                speed: 3.0,
                aiAggression: 0.12,
                type: "DICTATOR"
            }
        ];

        // Game State Variables
        let currentStageIndex = 0;
        let gameState = 'TITLE';
        let timer = 99;
        let timerInterval = null;
        let p1ScoreVal = 0;
        let p2ScoreVal = 0;
        let titleFrame = 0;

        // Fighter Objects
        const p1 = {
            name: "URBAN CHAMP",
            type: "HERO",
            x: 140,
            y: 225,
            width: 54,
            height: 86,
            color: '#2e86de',
            pantsColor: '#192a56',
            skinColor: '#ffcc99',
            hairColor: '#5c3a21',
            health: 100,
            maxHealth: 100,
            state: 'IDLE',
            facing: 1,
            cooldown: 0,
            hitFlash: 0
        };

        const p2 = {
            name: OPPONENTS[0].name,
            type: OPPONENTS[0].type,
            x: 320,
            y: 225,
            width: 54,
            height: 86,
            color: OPPONENTS[0].shirtColor,
            pantsColor: OPPONENTS[0].pantsColor,
            skinColor: OPPONENTS[0].skinColor,
            hairColor: OPPONENTS[0].hairColor,
            health: 100,
            maxHealth: 100,
            state: 'IDLE',
            facing: -1,
            cooldown: 0,
            hitFlash: 0
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
            audio.init();
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

        // Touch Listeners for Mobile Gamepad
        function bindTouchBtn(elementId, keyCode) {
            const btn = document.getElementById(elementId);
            if (!btn) return;
            btn.addEventListener('touchstart', (e) => { e.preventDefault(); audio.init(); keys[keyCode] = true; });
            btn.addEventListener('touchend', (e) => { e.preventDefault(); keys[keyCode] = false; });
            btn.addEventListener('mousedown', (e) => { audio.init(); keys[keyCode] = true; });
            btn.addEventListener('mouseup', (e) => { keys[keyCode] = false; });
        }

        bindTouchBtn('btnLeft', 'ArrowLeft');
        bindTouchBtn('btnRight', 'ArrowRight');

        document.getElementById('btnStartGame').addEventListener('click', () => {
            audio.init();
            if (gameState === 'TITLE' || gameState === 'GAME_OVER' || gameState === 'GAME_VICTORY') {
                startNextGame();
            }
        });

        document.getElementById('btnToggleMusic').addEventListener('click', () => {
            audio.init();
            const active = audio.toggleBGM();
            document.getElementById('btnToggleMusic').innerText = active ? "🎵 BGM MUSIC: ON" : "🔇 BGM MUSIC: OFF";
        });

        document.getElementById('btnLight').addEventListener('click', () => { audio.init(); if(gameState==='PLAYING') triggerPunch(p1, false); });
        document.getElementById('btnKick').addEventListener('click', () => { audio.init(); if(gameState==='PLAYING') triggerKick(p1); });
        document.getElementById('btnHeavy').addEventListener('click', () => { audio.init(); if(gameState==='PLAYING') triggerPunch(p1, true); });
        document.getElementById('btnBlock').addEventListener('touchstart', (e) => { e.preventDefault(); keys['Space'] = true; });
        document.getElementById('btnBlock').addEventListener('touchend', (e) => { e.preventDefault(); keys['Space'] = false; });

        function startNextGame() {
            audio.playStart();
            audio.startBGM();
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
            p2.type = oppData.type;
            p2.color = oppData.shirtColor;
            p2.pantsColor = oppData.pantsColor;
            p2.skinColor = oppData.skinColor;
            p2.hairColor = oppData.hairColor;
            p2.health = oppData.maxHealth;
            p2.maxHealth = oppData.maxHealth;
            p2.x = 320;
            p2.state = 'IDLE';

            document.getElementById('p2Name').innerText = oppData.name;
            document.getElementById('stageLabel').innerText = `STAGE ${stageIdx + 1}/5`;

            updateHUD();

            overlay.innerHTML = `<div style="font-size:1.4rem; color:#54a0ff;">${oppData.title}</div><div style="font-size:0.85rem; margin-top:10px; color:#feca57;">VS ${oppData.name}</div>`;
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
                    // Random Street Walker Spawning
                    if (!ambientNPCs.walker.active && Math.random() < 0.04) {
                        ambientNPCs.walker.active = true;
                        ambientNPCs.walker.x = -60;
                    }
                    // Random Drunkard Spawning
                    if (!ambientNPCs.drunkard.active && Math.random() < 0.03) {
                        ambientNPCs.drunkard.active = true;
                        ambientNPCs.drunkard.x = 560;
                    }
                }
            }, 1000);
        }

        function triggerPunch(fighter, isHeavy) {
            if (fighter.state === 'IDLE' || fighter.state === 'WALK') {
                fighter.state = isHeavy ? 'PUNCH_HEAVY' : 'PUNCH_LIGHT';
                fighter.cooldown = isHeavy ? 22 : 12;
                audio.playPunch(isHeavy);
                
                const opponent = (fighter === p1) ? p2 : p1;
                const dist = Math.abs(fighter.x - opponent.x);

                if (dist < 62) {
                    executeHit(fighter, opponent, isHeavy ? 25 : 12, isHeavy ? 42 : 22, isHeavy);
                }
            }
        }

        function triggerKick(fighter) {
            if (fighter.state === 'IDLE' || fighter.state === 'WALK') {
                fighter.state = 'KICK';
                fighter.cooldown = 18;
                audio.playKick();

                const opponent = (fighter === p1) ? p2 : p1;
                const dist = Math.abs(fighter.x - opponent.x);

                if (dist < 68) {
                    executeHit(fighter, opponent, 18, 32, false);
                }
            }
        }

        function executeHit(fighter, opponent, baseDamage, knockbackDist, isHeavy) {
            if (opponent.state === 'BLOCK') {
                audio.playBlock();
                opponent.x += fighter.facing * 10;
            } else {
                audio.playHit(isHeavy);
                opponent.state = 'HIT';
                opponent.cooldown = 16;
                opponent.hitFlash = 10;

                const mult = (fighter === p2) ? OPPONENTS[currentStageIndex].damageMult : 1.0;
                const finalDamage = Math.round(baseDamage * mult);

                opponent.health = Math.max(0, opponent.health - finalDamage);
                opponent.x += fighter.facing * knockbackDist;

                const hitX = (fighter.x + opponent.x) / 2 + 15;
                const hitY = opponent.y + 25;
                spawnBloodParticles(hitX, hitY, isHeavy);
                spawnDamageText(hitX, hitY, finalDamage);

                if (isHeavy) triggerScreenShake();

                if (fighter === p1) p1ScoreVal += isHeavy ? 300 : (baseDamage === 18 ? 200 : 150);
                else p2ScoreVal += isHeavy ? 300 : (baseDamage === 18 ? 200 : 150);

                if (opponent.x >= street.manholeX - 10 && opponent.x <= street.manholeX + street.manholeWidth) {
                    opponent.state = 'KO';
                    audio.playWin();
                    setTimeout(() => processStageVictory(fighter === p1), 800);
                    return;
                }

                if (opponent.health <= 0) {
                    opponent.state = 'KO';
                    audio.playWin();
                    setTimeout(() => processStageVictory(fighter === p1), 800);
                }
            }
        }

        function processStageVictory(isP1Winner) {
            clearInterval(timerInterval);
            if (isP1Winner) {
                if (currentStageIndex < OPPONENTS.length - 1) {
                    currentStageIndex++;
                    overlay.innerHTML = `<div style="color:#54a0ff; font-size:1.3rem;">STAGE DEFEATED!</div><div style="font-size:0.75rem; margin-top:10px; color:#feca57;">GET READY FOR NEXT OPPONENT</div>`;
                    overlay.style.display = 'block';
                    gameState = 'STAGE_CLEAR';
                    setTimeout(() => loadStage(currentStageIndex), 3000);
                } else {
                    gameState = 'GAME_VICTORY';
                    overlay.innerHTML = `<div style="color:#feca57; font-size:1.4rem;">🏆 VICTORY! 🏆</div><div style="font-size:0.7rem; margin-top:12px; color:#fff;">YOU DEFEATED GENERAL IRONCLAD!</div><div style="font-size:0.65rem; margin-top:10px; color:#54a0ff;">CITY IS LIBERATED! PRESS START TO RESTART</div>`;
                    overlay.style.display = 'block';
                }
            } else {
                gameState = 'GAME_OVER';
                audio.playGameOver();
                overlay.innerHTML = `<div style="color:#ff4757; font-size:1.5rem;">GAME OVER</div><div style="font-size:0.7rem; margin-top:10px; color:#fff;">PRESS START TO RETRY STAGE 1</div>`;
                overlay.style.display = 'block';
            }
        }

        function triggerPolicePatrol() {
            street.policeActive = true;
            street.policeCarX = -150;
            audio.playSiren();
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

        function updateGame() {
            if (gameState !== 'PLAYING') return;

            if (p1.hitFlash > 0) p1.hitFlash--;
            if (p2.hitFlash > 0) p2.hitFlash--;

            // Update Blood & Spark Particles
            for (let i = hitParticles.length - 1; i >= 0; i--) {
                const p = hitParticles[i];
                p.x += p.vx;
                p.y += p.vy;
                p.vy += 0.45;
                p.life--;
                if (p.life <= 0) hitParticles.splice(i, 1);
            }

            // Update Floating Damage Texts
            for (let i = damageTexts.length - 1; i >= 0; i--) {
                const dt = damageTexts[i];
                dt.y += dt.vy;
                dt.alpha -= 0.03;
                dt.life--;
                if (dt.life <= 0) damageTexts.splice(i, 1);
            }

            if (screenShakeTime > 0) screenShakeTime--;

            // Update Ambient Background NPCs
            if (ambientNPCs.walker.active) {
                ambientNPCs.walker.x += ambientNPCs.walker.speed;
                if (ambientNPCs.walker.x > canvas.width + 60) {
                    ambientNPCs.walker.active = false;
                }
            }

            if (ambientNPCs.drunkard.active) {
                ambientNPCs.drunkard.x += ambientNPCs.drunkard.speed;
                ambientNPCs.drunkard.staggerOffset = Math.sin(Date.now() / 180) * 4;
                if (ambientNPCs.drunkard.x < -60) {
                    ambientNPCs.drunkard.active = false;
                }
            }

            // Player 1 Control
            if (p1.cooldown > 0) {
                p1.cooldown--;
                if (p1.cooldown === 0 && p1.state !== 'KO') p1.state = 'IDLE';
            } else {
                if (keys['Space'] || keys['KeyS']) {
                    p1.state = 'BLOCK';
                } else if (keys['KeyZ'] || keys['KeyJ']) {
                    triggerPunch(p1, false);
                } else if (keys['KeyC'] || keys['KeyL']) {
                    triggerKick(p1);
                } else if (keys['KeyX'] || keys['KeyK']) {
                    triggerPunch(p1, true);
                } else if (keys['ArrowLeft'] || keys['KeyA']) {
                    p1.x = Math.max(street.leftBoundary, p1.x - 3.4);
                    p1.state = 'WALK';
                } else if (keys['ArrowRight'] || keys['KeyD']) {
                    p1.x = Math.min(street.manholeX + 20, p1.x + 3.4);
                    p1.state = 'WALK';
                } else {
                    p1.state = 'IDLE';
                }
            }

            // CPU AI Engine
            const oppConfig = OPPONENTS[currentStageIndex];
            if (p2.cooldown > 0) {
                p2.cooldown--;
                if (p2.cooldown === 0 && p2.state !== 'KO') p2.state = 'IDLE';
            } else {
                const distance = Math.abs(p1.x - p2.x);
                if (distance > 55) {
                    p2.x -= oppConfig.speed;
                    p2.state = 'WALK';
                } else {
                    const aiChoice = Math.random();
                    if (aiChoice < oppConfig.aiAggression) {
                        triggerPunch(p2, false);
                    } else if (aiChoice < oppConfig.aiAggression + 0.035) {
                        triggerKick(p2);
                    } else if (aiChoice < oppConfig.aiAggression + 0.065) {
                        triggerPunch(p2, true);
                    } else if (aiChoice < oppConfig.aiAggression + 0.09) {
                        p2.state = 'BLOCK';
                    } else {
                        p2.state = 'IDLE';
                    }
                }
            }

            p1.x = Math.max(street.leftBoundary, Math.min(street.rightBoundary, p1.x));
            p2.x = Math.max(street.leftBoundary, Math.min(street.rightBoundary, p2.x));

            if (street.policeActive) {
                street.policeCarX += 7.5;
                if (street.policeCarX > canvas.width + 100) {
                    street.policeActive = false;
                }
            }

            updateHUD();
        }

        // Title Screen Drawing
        function drawVintageTitleScreen() {
            titleFrame++;

            ctx.fillStyle = '#060912';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            ctx.fillStyle = '#0f172a';
            ctx.fillRect(15, 140, 70, 170);
            ctx.fillRect(95, 100, 90, 210);
            ctx.fillRect(195, 120, 80, 190);
            ctx.fillRect(285, 80, 100, 230);
            ctx.fillRect(395, 130, 80, 180);

            ctx.fillStyle = (titleFrame % 60 < 30) ? '#feca57' : '#54a0ff';
            ctx.fillRect(110, 120, 18, 22);
            ctx.fillRect(145, 120, 18, 22);
            ctx.fillRect(305, 100, 22, 28);
            ctx.fillRect(345, 100, 22, 28);

            const titleGrad = ctx.createLinearGradient(40, 40, 472, 110);
            titleGrad.addColorStop(0, '#ee5253');
            titleGrad.addColorStop(1, '#5f27cd');
            ctx.fillStyle = titleGrad;
            ctx.fillRect(40, 35, 432, 75);
            ctx.strokeStyle = '#feca57';
            ctx.lineWidth = 6;
            ctx.strokeRect(36, 31, 440, 83);

            ctx.fillStyle = '#ffffff';
            ctx.font = '24px "Press Start 2P"';
            ctx.textAlign = 'center';
            ctx.shadowColor = '#000';
            ctx.shadowOffsetX = 4;
            ctx.shadowOffsetY = 4;
            ctx.fillText("8bitCityChamp", canvas.width / 2, 80);

            ctx.font = '10px "Press Start 2P"';
            ctx.fillStyle = '#feca57';
            ctx.fillText("MOBILE TOUCH & AMBIENT STREET EDITION", canvas.width / 2, 135);

            if (Math.floor(titleFrame / 30) % 2 === 0) {
                ctx.fillStyle = '#00d2d3';
                ctx.font = '12px "Press Start 2P"';
                ctx.fillText("PRESS START TO PLAY", canvas.width / 2, 225);
            }

            ctx.fillStyle = '#121724';
            ctx.fillRect(50, 265, 412, 80);
            ctx.strokeStyle = '#ffdd59';
            ctx.lineWidth = 3;
            ctx.strokeRect(50, 265, 412, 80);

            ctx.fillStyle = '#ff4757';
            ctx.font = '9px "Press Start 2P"';
            ctx.fillText("5 STAGES • FINAL BOSS: GENERAL IRONCLAD", canvas.width / 2, 290);
            ctx.fillStyle = '#c8d6e5';
            ctx.font = '8px "Press Start 2P"';
            ctx.fillText("STREET WALKERS & DRUNKARDS • MOBILE GAMEPAD", canvas.width / 2, 320);

            ctx.shadowOffsetX = 0;
            ctx.shadowOffsetY = 0;
        }

        function drawBackground() {
            ctx.save();
            if (screenShakeTime > 0) {
                const dx = (Math.random() - 0.5) * 8;
                const dy = (Math.random() - 0.5) * 8;
                ctx.translate(dx, dy);
            }

            const skyGrad = ctx.createLinearGradient(0, 0, 0, 260);
            skyGrad.addColorStop(0, '#070a14');
            skyGrad.addColorStop(1, '#18243b');
            ctx.fillStyle = skyGrad;
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            ctx.fillStyle = '#261730';
            ctx.fillRect(0, 40, canvas.width, 220);

            ctx.fillStyle = '#422550';
            ctx.fillRect(30, 70, 95, 85);
            ctx.fillRect(200, 70, 115, 85);
            ctx.fillRect(380, 70, 95, 85);

            ctx.fillStyle = '#feca57';
            ctx.fillRect(45, 85, 26, 32);
            ctx.fillRect(82, 85, 26, 32);
            ctx.fillRect(215, 85, 38, 32);
            ctx.fillRect(262, 85, 38, 32);

            ctx.fillStyle = '#ff4757';
            ctx.fillRect(20, 50, 115, 18);
            ctx.fillStyle = '#fff';
            ctx.font = '10px "Press Start 2P"';
            ctx.textAlign = 'left';
            ctx.fillText('BAR 16', 45, 64);

            ctx.fillStyle = '#54a0ff';
            ctx.fillRect(190, 50, 135, 18);
            ctx.fillStyle = '#fff';
            ctx.fillText('CLUB 84', 215, 64);

            // Sidewalk
            ctx.fillStyle = '#576574';
            ctx.fillRect(0, 260, canvas.width, 16);
            ctx.fillStyle = '#8395a7';
            ctx.fillRect(0, 260, canvas.width, 4);

            // DRAW AMBIENT BACKGROUND NPCs ON SIDEWALK
            if (ambientNPCs.walker.active) {
                drawStreetWalker(ambientNPCs.walker.x, ambientNPCs.walker.y);
            }
            if (ambientNPCs.drunkard.active) {
                drawStaggeringDrunkard(ambientNPCs.drunkard.x, ambientNPCs.drunkard.y + ambientNPCs.drunkard.staggerOffset);
            }

            // Road Asphalt
            ctx.fillStyle = '#1e272e';
            ctx.fillRect(0, 276, canvas.width, 110);

            ctx.fillStyle = '#0a0e14';
            ctx.beginPath();
            ctx.ellipse(street.manholeX + 25, 320, 26, 9, 0, 0, Math.PI * 2);
            ctx.fill();
            ctx.strokeStyle = '#485460';
            ctx.lineWidth = 3;
            ctx.stroke();

            if (street.policeActive) {
                drawPoliceCar(street.policeCarX, 290);
            }
        }

        // Draw Fast Street Walker Ambient NPC
        function drawStreetWalker(x, y) {
            ctx.save();
            ctx.translate(x, y);

            // Shadow
            ctx.fillStyle = 'rgba(0,0,0,0.3)';
            ctx.beginPath(); ctx.ellipse(12, 38, 12, 4, 0, 0, Math.PI * 2); ctx.fill();

            // Hair & Head
            ctx.fillStyle = '#e84393'; ctx.fillRect(4, 0, 16, 8); // Pink Hair
            ctx.fillStyle = '#ffdd59'; ctx.fillRect(6, 4, 12, 10); // Skin Face

            // Bright Pink Top & Handbag
            ctx.fillStyle = '#fd79a8'; ctx.fillRect(4, 14, 16, 12);
            ctx.fillStyle = '#e17055'; ctx.fillRect(18, 18, 6, 8); // Handbag

            // Skirt
            ctx.fillStyle = '#2d3436'; ctx.fillRect(6, 26, 12, 8);

            // Legs & High Heels (Fast Walk Animation)
            const legSwing = Math.sin(Date.now() / 80) * 5;
            ctx.fillStyle = '#ffdd59';
            ctx.fillRect(6 + legSwing, 34, 4, 10);
            ctx.fillRect(12 - legSwing, 34, 4, 10);
            ctx.fillStyle = '#d63031'; // High Heels
            ctx.fillRect(6 + legSwing, 44, 5, 4);
            ctx.fillRect(12 - legSwing, 44, 5, 4);

            ctx.restore();
        }

        // Draw Staggering Drunkard Ambient NPC
        function drawStaggeringDrunkard(x, y) {
            ctx.save();
            ctx.translate(x, y);

            // Shadow
            ctx.fillStyle = 'rgba(0,0,0,0.3)';
            ctx.beginPath(); ctx.ellipse(14, 42, 14, 4, 0, 0, Math.PI * 2); ctx.fill();

            // Stumbling Head & Messy Hair
            ctx.fillStyle = '#636e72'; ctx.fillRect(4, 0, 18, 8);
            ctx.fillStyle = '#ffcc99'; ctx.fillRect(6, 6, 14, 10);
            ctx.fillStyle = '#d63031'; ctx.fillRect(14, 10, 4, 4); // Red Nose

            // Stained Shirt
            ctx.fillStyle = '#b2bec3'; ctx.fillRect(6, 16, 16, 16);

            // Holding Brown Bottle
            ctx.fillStyle = '#e17055'; ctx.fillRect(-2, 22, 6, 10); // Bottle
            ctx.fillStyle = '#f1c40f'; ctx.fillRect(-1, 20, 4, 3);  // Cap

            // Pants & Stumbling Legs
            ctx.fillStyle = '#2d3436'; ctx.fillRect(8, 32, 12, 12);

            ctx.restore();
        }

        function drawPoliceCar(x, y) {
            ctx.fillStyle = '#000';
            ctx.fillRect(x, y, 105, 36);
            ctx.fillStyle = '#fff';
            ctx.fillRect(x + 22, y, 62, 19);
            ctx.fillStyle = Math.floor(Date.now() / 140) % 2 === 0 ? '#ff4757' : '#00d2d3';
            ctx.fillRect(x + 46, y - 9, 14, 9);
            ctx.fillStyle = '#8395a7';
            ctx.beginPath();
            ctx.arc(x + 22, y + 36, 11, 0, Math.PI * 2);
            ctx.arc(x + 84, y + 36, 11, 0, Math.PI * 2);
            ctx.fill();
        }

        // ULTRA HIGH-DETAIL 16-BIT FIGHTER DRAWING ENGINE
        function drawFighter(f) {
            ctx.save();

            const breatheY = (f.state === 'IDLE') ? Math.sin(Date.now() / 220) * 1.5 : 0;
            ctx.translate(f.x, f.y + breatheY);

            if (f.hitFlash > 0) {
                ctx.filter = 'brightness(1.6) drop-shadow(0px 0px 10px #ff4757)';
            }

            // Shadow
            ctx.fillStyle = 'rgba(0,0,0,0.5)';
            ctx.beginPath();
            ctx.ellipse(f.width/2, f.height + 4, 27, 7, 0, 0, Math.PI * 2);
            ctx.fill();

            // Head
            ctx.fillStyle = f.skinColor;
            ctx.fillRect(14, 0, 26, 22);

            // Facial details
            ctx.fillStyle = '#222';
            if (f.facing === 1) ctx.fillRect(26, 4, 10, 3);
            else ctx.fillRect(18, 4, 10, 3);

            ctx.fillStyle = f.state === 'HIT' ? '#ff4757' : (f.state === 'KO' ? '#666' : '#000');
            if (f.facing === 1) {
                ctx.fillRect(28, 8, 5, 5);
                ctx.fillStyle = '#fff'; ctx.fillRect(29, 9, 2, 2);
            } else {
                ctx.fillRect(21, 8, 5, 5);
                ctx.fillStyle = '#fff'; ctx.fillRect(22, 9, 2, 2);
            }

            ctx.fillStyle = f.state === 'PUNCH_HEAVY' || f.state === 'KICK' || f.state === 'HIT' ? '#ff4757' : '#552211';
            ctx.fillRect(22, 16, 10, 3);

            // Character Specific Gear & Costumes
            if (f.type === 'DICTATOR') {
                ctx.fillStyle = '#1c2413'; ctx.fillRect(8, -12, 38, 14);
                ctx.fillStyle = '#ffdd59'; ctx.fillRect(8, -2, 38, 3);
                ctx.fillStyle = '#111'; ctx.fillRect(6, 1, 42, 4);
                ctx.fillStyle = '#ffdd59'; ctx.fillRect(23, -8, 8, 6); ctx.fillRect(21, -6, 12, 3);

                ctx.fillStyle = '#19130c'; ctx.fillRect(16, 13, 22, 5); ctx.fillRect(14, 16, 4, 3); ctx.fillRect(36, 16, 4, 3);

                ctx.fillStyle = f.color; ctx.fillRect(10, 22, 34, 34);

                ctx.fillStyle = '#ff4757'; ctx.fillRect(18, 22, 6, 4); ctx.fillRect(30, 22, 6, 4);

                ctx.fillStyle = '#ffdd59'; ctx.fillRect(4, 20, 11, 8); ctx.fillRect(39, 20, 11, 8);
                ctx.fillStyle = '#e1b12c'; ctx.fillRect(4, 28, 11, 4); ctx.fillRect(39, 28, 11, 4);

                ctx.fillStyle = '#ff4757'; ctx.fillRect(15, 27, 6, 4);
                ctx.fillStyle = '#54a0ff'; ctx.fillRect(22, 27, 6, 4);
                ctx.fillStyle = '#10ac84'; ctx.fillRect(29, 27, 6, 4);
                ctx.fillStyle = '#feca57'; ctx.fillRect(15, 32, 6, 4);
                ctx.fillStyle = '#5f27cd'; ctx.fillRect(22, 32, 6, 4);

                ctx.fillStyle = '#ffdd59';
                ctx.fillRect(16, 38, 4, 4); ctx.fillRect(34, 38, 4, 4);
                ctx.fillRect(16, 45, 4, 4); ctx.fillRect(34, 45, 4, 4);

                ctx.fillStyle = '#0f141a'; ctx.fillRect(10, 50, 34, 7);
                ctx.fillStyle = '#ffdd59'; ctx.fillRect(23, 49, 8, 9);
            } else if (f.type === 'PUNK') {
                ctx.fillStyle = '#ff4757'; ctx.fillRect(20, -12, 14, 6);
                ctx.fillStyle = '#f1c40f'; ctx.fillRect(22, -6, 10, 8);
                ctx.fillStyle = f.color; ctx.fillRect(10, 22, 34, 32);
                ctx.fillStyle = '#c8d6e5'; ctx.fillRect(8, 22, 4, 4); ctx.fillRect(42, 22, 4, 4); ctx.fillRect(8, 28, 4, 4); ctx.fillRect(42, 28, 4, 4);
                ctx.fillStyle = '#222'; ctx.fillRect(10, 50, 34, 6);
                ctx.fillStyle = '#fff'; ctx.fillRect(24, 49, 6, 7);
            } else if (f.type === 'BRAWLER') {
                ctx.fillStyle = '#ff4757'; ctx.fillRect(12, 2, 30, 5); ctx.fillRect(f.facing === 1 ? 4 : 40, 4, 8, 12);
                ctx.fillStyle = f.color; ctx.fillRect(12, 22, 30, 30);
                ctx.fillStyle = '#1e272e'; ctx.fillRect(16, 26, 8, 8); ctx.fillRect(28, 34, 8, 8);
            } else if (f.type === 'BOXER') {
                ctx.fillStyle = 'rgba(255,255,255,0.4)'; ctx.fillRect(26, 1, 6, 4);
                ctx.fillStyle = '#ffdd59'; ctx.fillRect(18, 22, 18, 4);
                ctx.fillStyle = f.color; ctx.fillRect(10, 48, 34, 14);
                ctx.fillStyle = '#ffdd59'; ctx.fillRect(10, 48, 34, 4);
            } else if (f.type === 'NINJA') {
                ctx.fillStyle = '#111'; ctx.fillRect(12, 0, 30, 22);
                ctx.fillStyle = '#8395a7'; ctx.fillRect(18, 4, 18, 6);
                ctx.fillStyle = '#000'; ctx.fillRect(24, 6, 6, 2);
                ctx.fillStyle = f.skinColor; ctx.fillRect(20, 10, 14, 8);
                ctx.fillStyle = f.color; ctx.fillRect(10, 22, 34, 34);
                ctx.fillStyle = '#ffdd59'; ctx.fillRect(24, 22, 6, 34);
            } else {
                ctx.fillStyle = f.hairColor; ctx.fillRect(12, -6, 30, 10);
                ctx.fillStyle = '#a55eea'; ctx.fillRect(20, -6, 8, 4);
                ctx.fillStyle = f.color; ctx.fillRect(10, 22, 34, 32);
                ctx.fillStyle = '#fff'; ctx.fillRect(22, 22, 10, 18);
                ctx.fillStyle = '#c8d6e5'; ctx.fillRect(26, 22, 2, 20);
            }

            // Pants & Leg Stance
            ctx.fillStyle = f.pantsColor || '#192a56';

            if (f.state === 'KICK') {
                ctx.fillRect(12, 54, 16, 20);
                ctx.fillStyle = f.skinColor;
                ctx.fillRect(12, 74, 16, 12);
                ctx.fillStyle = f.pantsColor || '#192a56';
                ctx.fillRect(f.facing === 1 ? 26 : -18, 44, 32, 14);
                ctx.fillStyle = '#0b0e14';
                ctx.fillRect(f.facing === 1 ? 58 : -28, 42, 14, 18);
            } else {
                ctx.fillRect(12, 54, 30, 26);
                ctx.fillStyle = 'rgba(255,255,255,0.12)';
                ctx.fillRect(16, 60, 8, 10); ctx.fillRect(30, 60, 8, 10);

                ctx.fillStyle = '#0b0e14';
                ctx.fillRect(10, 76, 14, 12); ctx.fillRect(30, 76, 14, 12);
                ctx.fillStyle = '#8395a7';
                ctx.fillRect(16, 78, 2, 6); ctx.fillRect(36, 78, 2, 6);
            }

            // Arms & Combat Stances
            ctx.fillStyle = f.skinColor;
            if (f.state === 'PUNCH_LIGHT') {
                ctx.fillRect(f.facing === 1 ? 36 : -18, 24, 28, 14);
                ctx.fillStyle = '#222';
                ctx.fillRect(f.facing === 1 ? 54 : -18, 24, 10, 14);
            } else if (f.state === 'PUNCH_HEAVY') {
                ctx.fillRect(f.facing === 1 ? 36 : -24, 22, 34, 16);
                ctx.fillStyle = '#222';
                ctx.fillRect(f.facing === 1 ? 58 : -24, 22, 12, 16);
                if (f.type === 'DICTATOR') {
                    ctx.fillStyle = '#ffdd59';
                    ctx.fillRect(f.facing === 1 ? 64 : -28, 18, 8, 24);
                }
            } else if (f.state === 'KICK') {
                ctx.fillRect(4, 22, 14, 14);
                ctx.fillRect(34, 22, 14, 14);
            } else if (f.state === 'BLOCK') {
                ctx.fillRect(16, 14, 22, 20);
                ctx.fillStyle = 'rgba(84, 160, 255, 0.4)';
                ctx.fillRect(12, 10, 30, 30);
            } else if (f.state === 'HIT') {
                ctx.rotate((f.facing * -15 * Math.PI) / 180);
                ctx.fillRect(6, 26, 16, 16);
            } else {
                ctx.fillRect(4, 26, 14, 16);
                ctx.fillRect(36, 26, 14, 16);
                ctx.fillStyle = '#222';
                ctx.fillRect(4, 34, 14, 8); ctx.fillRect(36, 34, 14, 8);
            }

            if (f.state === 'KO') {
                ctx.translate(0, 34);
            }

            ctx.restore();
        }

        // Draw Blood FX Particles & Damage Floating Text
        function drawParticles() {
            ctx.save();

            for (let p of hitParticles) {
                ctx.fillStyle = p.color;
                ctx.fillRect(p.x, p.y, p.size, p.size);
            }

            ctx.font = '10px "Press Start 2P"';
            ctx.shadowColor = '#000';
            ctx.shadowOffsetX = 2;
            ctx.shadowOffsetY = 2;
            for (let dt of damageTexts) {
                ctx.fillStyle = `rgba(255, 71, 87, ${dt.alpha})`;
                ctx.fillText(dt.text, dt.x, dt.y);
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
                drawParticles();
                ctx.restore();
            }
        }

        function gameLoop() {
            updateGame();
            render();
            requestAnimationFrame(gameLoop);
        }

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

echo "=== 8bitCityChamp Startup Script Completed Successfully (Mobile + Ambient NPCs Edition) at $(date) ==="
