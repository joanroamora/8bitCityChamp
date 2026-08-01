#!/bin/bash
set -e

# Logging setup
exec > >(tee -a /var/log/startup-script.log) 2>&1
echo "=== Starting 8bitCityChamp Startup Script (Multi-Game Arcade Hub + Paper Mario Snake Whack): $(date) ==="

# Update package list and install Nginx & curl
apt-get update -y
apt-get install -y nginx curl git

# Remove default Nginx index page
rm -rf /var/www/html/*

# Create Multi-Game Arcade Hub with 8bitCityChamp & Paper Mario Persian Market Snake Whack
cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>8bit Arcade Hub - CityChamp & Paper Snake Bazaar</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&family=Fredoka+One&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #05070e;
            --neon-blue: #00d2d3;
            --neon-pink: #ff4757;
            --paper-gold: #f1c40f;
            --paper-orange: #e67e22;
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
            background-image: radial-gradient(circle at 50% 20%, #151d30 0%, #060912 70%, #010205 100%);
            color: #ffffff;
            font-family: 'Press Start 2P', monospace, cursive;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            padding: 10px;
            overflow-x: hidden;
        }

        /* Top Hub Header Bar */
        .hub-header {
            text-align: center;
            margin-bottom: 16px;
            width: 100%;
            max-width: 900px;
        }

        .hub-title {
            font-size: 1.8rem;
            color: #54a0ff;
            text-shadow: 3px 3px 0 #000, -2px -2px 0 #ff4757, 0 0 20px #54a0ff;
            letter-spacing: 2px;
            margin-bottom: 6px;
        }

        .hub-subtitle {
            font-size: 0.6rem;
            color: #feca57;
            letter-spacing: 1.5px;
        }

        .btn-back-hub {
            background: linear-gradient(180deg, #ff4757, #c0392b);
            color: #fff;
            border: 3px solid #fff;
            padding: 8px 16px;
            font-family: inherit;
            font-size: 0.6rem;
            border-radius: 8px;
            box-shadow: 0 4px 0 #000;
            cursor: pointer;
            display: none;
            margin-bottom: 12px;
        }
        .btn-back-hub:active { transform: translateY(2px); }

        /* Main Game Grid Selection Screen */
        .game-grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 20px;
            width: 100%;
            max-width: 880px;
        }

        .game-card {
            background: #0f172a;
            border: 4px solid #1e293b;
            border-radius: 14px;
            padding: 16px;
            display: flex;
            flex-direction: column;
            align-items: center;
            cursor: pointer;
            transition: transform 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 10px 25px rgba(0,0,0,0.6);
        }

        .game-card:hover {
            transform: translateY(-6px);
            border-color: #54a0ff;
            box-shadow: 0 15px 30px rgba(84, 160, 255, 0.4);
        }

        .game-card-thumb {
            width: 100%;
            height: 180px;
            border-radius: 8px;
            border: 3px solid #000;
            overflow: hidden;
            position: relative;
            background: #000;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .game-card-title {
            font-size: 0.95rem;
            color: #feca57;
            margin-bottom: 8px;
            text-shadow: 2px 2px #000;
            text-align: center;
        }

        .game-card-desc {
            font-size: 0.52rem;
            color: #cbd5e1;
            line-height: 1.6;
            text-align: center;
            margin-bottom: 12px;
        }

        .btn-play-card {
            background: linear-gradient(180deg, #10ac84, #01a3a4);
            color: #fff;
            border: 2px solid #55efc4;
            padding: 10px 20px;
            font-family: inherit;
            font-size: 0.65rem;
            border-radius: 6px;
            box-shadow: 0 3px 0 #000;
            width: 100%;
            text-align: center;
        }

        /* ---------------------------------------------------- */
        /* GAME 1: 8bitCityChamp Container */
        /* ---------------------------------------------------- */
        #game1View {
            display: none;
            width: 100%;
            max-width: 860px;
        }

        /* Arcade Cabinet Frame */
        .arcade-cabinet {
            position: relative;
            background: #0b0e16;
            border: 10px solid #1a2332;
            border-radius: 16px;
            box-shadow: 0 0 0 4px #000, 0 20px 50px rgba(0,0,0,0.95), inset 0 0 25px rgba(0,0,0,0.85);
            padding: 12px;
            width: 100%;
        }

        .crt-screen {
            position: relative;
            background: #000;
            border: 5px solid #06080e;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: inset 0 0 35px rgba(0,0,0,1);
        }

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
        }

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

        .hud-player { display: flex; flex-direction: column; gap: 4px; width: 38%; }
        .player-name { display: flex; justify-content: space-between; font-size: 0.55rem; }
        .p1-color { color: #54a0ff; } .p2-color { color: #ff4757; }
        .health-bar-container { width: 100%; height: 16px; background: #161d24; border: 2px solid #fff; position: relative; }
        .health-bar-fill { height: 100%; width: 100%; background: linear-gradient(90deg, #ff4757 0%, #ff9f43 50%, #10ac84 100%); transition: width 0.15s ease-out; }
        .hud-center { text-align: center; width: 24%; }
        .hud-timer { font-size: 1.2rem; color: #fff; text-shadow: 2px 2px #ff4757; }
        .hud-stage { font-size: 0.52rem; color: #feca57; margin-top: 2px; }

        canvas#gameCanvas { display: block; width: 100%; height: auto; background: #000; image-rendering: pixelated; }

        .mobile-controls { display: flex; margin-top: 10px; width: 100%; justify-content: space-between; gap: 8px; }
        .btn-group { display: flex; gap: 6px; }
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
        .btn-start { background: linear-gradient(180deg, #10ac84, #01a3a4); border-color: #55efc4; font-weight: bold; width: 100%; margin-top: 8px; padding: 12px; font-size: 0.75rem; }
        .btn-punch { background: linear-gradient(180deg, #ee5253, #10ac84); border-color: #ff6b6b; }
        .btn-kick { background: linear-gradient(180deg, #10ac84, #0fb9b1); border-color: #55efc4; }
        .btn-heavy { background: linear-gradient(180deg, #ff9f43, #ee5253); border-color: #feca57; }
        .btn-block { background: linear-gradient(180deg, #2e86de, #5f27cd); border-color: #54a0ff; }

        /* ---------------------------------------------------- */
        /* GAME 2: Paper Mario Persian Market Snake Whack       */
        /* ---------------------------------------------------- */
        #game2View {
            display: none;
            width: 100%;
            max-width: 860px;
        }

        .paper-cabinet {
            background: #2c1a0e;
            border: 10px solid #5c3818;
            border-radius: 16px;
            padding: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.8), inset 0 0 20px rgba(0,0,0,0.9);
            width: 100%;
        }

        .snake-score-hud {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #3e2714;
            border: 3px solid #8c531d;
            border-radius: 8px;
            padding: 8px 16px;
            margin-bottom: 8px;
            font-size: 0.65rem;
            color: #f1c40f;
        }

        canvas#snakeCanvas {
            display: block;
            width: 100%;
            height: auto;
            background: #110904;
            border: 4px solid #f1c40f;
            border-radius: 10px;
            image-rendering: pixelated;
        }

        .snake-touch-pad {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 8px;
            margin-top: 10px;
        }

        .basket-touch-btn {
            background: linear-gradient(180deg, #d35400, #a04000);
            color: #fff;
            border: 3px solid #f39c12;
            padding: 14px 4px;
            font-family: inherit;
            font-size: 0.8rem;
            border-radius: 10px;
            box-shadow: 0 4px 0 #5e2600, 3px 3px 0 rgba(0,0,0,0.4);
            cursor: pointer;
            text-align: center;
            font-weight: bold;
        }

        .basket-touch-btn:active {
            transform: translateY(3px);
            box-shadow: 0 1px 0 #5e2600;
        }

        /* Clean Mobile CSS Overlay */
        @media (max-width: 768px) {
            body { padding: 2px; }
            .hub-header { margin-bottom: 8px; }
            .hub-title { font-size: 1.2rem; }
            .top-bar { display: none !important; }
            .retro-btn { padding: 16px 8px; font-size: 0.68rem; }
            .basket-touch-btn { padding: 18px 4px; font-size: 0.9rem; }
        }

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

    <!-- Main Hub Header -->
    <header class="hub-header">
        <h1 class="hub-title">8BIT ARCADE HUB</h1>
        <p class="hub-subtitle">SELECT A GAME TO PLAY ON MOBILE OR PC</p>
    </header>

    <!-- Return to Hub Button -->
    <button class="btn-back-hub" id="btnBackHub">◄ BACK TO ARCADE HUB</button>

    <!-- Main Game Grid Selection Screen -->
    <main class="game-grid-container" id="hubView">

        <!-- Game 1 Card -->
        <div class="game-card" onclick="openGame(1)">
            <div class="game-card-thumb" style="background: linear-gradient(135deg, #1e272e, #090d13);">
                <div style="font-size:2.8rem;">🥊</div>
            </div>
            <h2 class="game-card-title">8bitCityChamp</h2>
            <p class="game-card-desc">16-Bit SNES Arcade Fighter! 5 Stages, Dictator Boss, High Kick Attack, Blood FX & Street Fauna.</p>
            <div class="btn-play-card">▶ PLAY CITY CHAMP</div>
        </div>

        <!-- Game 2 Card -->
        <div class="game-card" onclick="openGame(2)">
            <div class="game-card-thumb" style="background: linear-gradient(135deg, #4d2600, #1f0f00);">
                <div style="font-size:2.8rem;">🐍🧺</div>
            </div>
            <h2 class="game-card-title">Paper Snake Bazaar</h2>
            <p class="game-card-desc">Paper Mario Style Whack-a-Snake! 5 Woven Baskets in Persian Market. Hit A-S-D-F-G to swing wooden club!</p>
            <div class="btn-play-card">▶ PLAY PAPER SNAKE</div>
        </div>

    </main>

    <!-- ======================================================== -->
    <!-- GAME 1 CONTAINER: 8bitCityChamp                          -->
    <!-- ======================================================== -->
    <section id="game1View">
        <div class="arcade-cabinet">
            <div class="top-bar">
                <span>16-BIT SNES SOUNDTRACK</span>
                <button class="music-toggle-btn" id="btnToggleMusic">🎵 BGM MUSIC: ON</button>
            </div>

            <div class="crt-screen">
                <div class="hud-bar" id="hudBar">
                    <div class="hud-player">
                        <div class="player-name"><span class="p1-color">PLAYER 1</span><span id="p1Score">00000</span></div>
                        <div class="health-bar-container"><div id="p1Health" class="health-bar-fill"></div></div>
                    </div>
                    <div class="hud-center">
                        <div class="hud-timer" id="gameTimer">99</div>
                        <div class="hud-stage" id="stageLabel">STAGE 1/5</div>
                    </div>
                    <div class="hud-player">
                        <div class="player-name"><span class="p2-color" id="p2Name">OPPONENT</span><span id="p2Score">00000</span></div>
                        <div class="health-bar-container"><div id="p2Health" class="health-bar-fill"></div></div>
                    </div>
                </div>

                <canvas id="gameCanvas" width="512" height="384"></canvas>
                <div id="overlayMsg" class="overlay-msg">PRESS START TO PLAY</div>
            </div>

            <button class="retro-btn btn-start" id="btnStartGame">🎮 PRESS START / BEGIN BATTLE</button>

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
        </div>
    </section>

    <!-- ======================================================== -->
    <!-- GAME 2 CONTAINER: Paper Mario Persian Market Snake Whack -->
    <!-- ======================================================== -->
    <section id="game2View">
        <div class="paper-cabinet">
            <div class="snake-score-hud">
                <div>SCORE: <span id="snakeScore">0000</span></div>
                <div>PERSIAN BAZAAR WHACK-A-SNAKE</div>
                <div>TIME: <span id="snakeTimer">45</span>s</div>
            </div>

            <div style="position:relative;">
                <canvas id="snakeCanvas" width="512" height="384"></canvas>
                <div id="snakeOverlay" class="overlay-msg">PAPER SNAKE BAZAAR<br><span style="font-size:0.7rem; color:#fff;">PRESS A-S-D-F-G OR TAP BASKETS!</span></div>
            </div>

            <!-- 5 Touch Buttons Mapped to Baskets A, S, D, F, G -->
            <div class="snake-touch-pad">
                <button class="basket-touch-btn" id="btnBasket0">🧺 [A]</button>
                <button class="basket-touch-btn" id="btnBasket1">🧺 [S]</button>
                <button class="basket-touch-btn" id="btnBasket2">🧺 [D]</button>
                <button class="basket-touch-btn" id="btnBasket3">🧺 [F]</button>
                <button class="basket-touch-btn" id="btnBasket4">🧺 [G]</button>
            </div>

            <button class="retro-btn btn-start" id="btnStartSnake" style="margin-top:10px;">🐍 START PAPER SNAKE GAME</button>
        </div>
    </section>

    <script>
        // ----------------------------------------------------
        // HUB NAVIGATION CONTROLLER
        // ----------------------------------------------------
        let activeGame = 0;

        function openGame(gameId) {
            activeGame = gameId;
            document.getElementById('hubView').style.display = 'none';
            document.getElementById('btnBackHub').style.display = 'block';

            if (gameId === 1) {
                document.getElementById('game1View').style.display = 'block';
                document.getElementById('game2View').style.display = 'none';
            } else if (gameId === 2) {
                document.getElementById('game1View').style.display = 'none';
                document.getElementById('game2View').style.display = 'block';
                initSnakeGame();
            }
        }

        document.getElementById('btnBackHub').addEventListener('click', () => {
            activeGame = 0;
            document.getElementById('game1View').style.display = 'none';
            document.getElementById('game2View').style.display = 'none';
            document.getElementById('hubView').style.display = 'grid';
            document.getElementById('btnBackHub').style.display = 'none';
        });

        // ----------------------------------------------------
        // AUDIO ENGINE FOR BOTH GAMES
        // ----------------------------------------------------
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
                }, 180);
            }
            playStart() {
                if (!this.ctx) return;
                const notes = [220, 277.18, 329.63, 440];
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
            playWhack() {
                if (!this.ctx) return;
                const osc = this.ctx.createOscillator();
                const gain = this.ctx.createGain();
                osc.type = 'square';
                osc.frequency.setValueAtTime(320, this.ctx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(50, this.ctx.currentTime + 0.18);
                gain.gain.setValueAtTime(0.4, this.ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + 0.18);
                osc.connect(gain);
                gain.connect(this.ctx.destination);
                osc.start();
                osc.stop(this.ctx.currentTime + 0.18);
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

        // ----------------------------------------------------
        // GAME 1 ENGINE: 8bitCityChamp
        // ----------------------------------------------------
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        const overlay = document.getElementById('overlayMsg');

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
            damageTexts.push({ x: x, y: y - 10, text: '-' + amount, vy: -1.5, alpha: 1.0, life: 32 });
        }

        let screenShakeTime = 0;
        function triggerScreenShake() { screenShakeTime = 8; }

        const ambientNPCs = {
            walker: { active: true, x: -40, y: 212, speed: 3.4, timer: 0 },
            drunkard: { active: true, x: 540, y: 212, speed: -1.4, staggerOffset: 0, timer: 60 },
            blackCat: { active: true, x: -50, y: 246, speed: 6.2, timer: 120 },
            rats: { active: true, x: 550, y: 250, speed: -7.8, timer: 180 }
        };

        const OPPONENTS = [
            { id: 1, name: "SPIKE (ROOKIE)", title: "STAGE 1: STREET PUNK", shirtColor: "#e74c3c", pantsColor: "#2c3e50", skinColor: "#ffcc99", hairColor: "#f1c40f", maxHealth: 100, damageMult: 0.8, speed: 1.7, aiAggression: 0.03, type: "PUNK" },
            { id: 2, name: "BRUNO (BRAWLER)", title: "STAGE 2: ALLEY CHAMP", shirtColor: "#2ecc71", pantsColor: "#34495e", skinColor: "#e0ac69", hairColor: "#2c3e50", maxHealth: 115, damageMult: 1.0, speed: 2.1, aiAggression: 0.05, type: "BRAWLER" },
            { id: 3, name: "DUKE (HEAVYWEIGHT)", title: "STAGE 3: IRON DUKE", shirtColor: "#f39c12", pantsColor: "#1e272e", skinColor: "#8d5524", hairColor: "#ffffff", maxHealth: 130, damageMult: 1.25, speed: 2.4, aiAggression: 0.07, type: "BOXER" },
            { id: 4, name: "KAGE (SHADOW)", title: "STAGE 4: SHADOW NINJA", shirtColor: "#8e44ad", pantsColor: "#2c3e50", skinColor: "#f5cda7", hairColor: "#111111", maxHealth: 145, damageMult: 1.45, speed: 2.8, aiAggression: 0.09, type: "NINJA" },
            { id: 5, name: "GEN. IRONCLAD", title: "FINAL BOSS: THE DICTATOR", shirtColor: "#2d381c", pantsColor: "#1c2411", skinColor: "#d2b48c", hairColor: "#4a3c31", maxHealth: 175, damageMult: 1.8, speed: 3.0, aiAggression: 0.12, type: "DICTATOR" }
        ];

        let currentStageIndex = 0;
        let gameState = 'TITLE';
        let timer = 99;
        let timerInterval = null;
        let p1ScoreVal = 0;
        let p2ScoreVal = 0;
        let titleFrame = 0;

        const p1 = { name: "URBAN CHAMP", type: "HERO", x: 140, y: 225, width: 54, height: 86, color: '#2e86de', pantsColor: '#192a56', skinColor: '#ffcc99', hairColor: '#5c3a21', health: 100, maxHealth: 100, state: 'IDLE', facing: 1, cooldown: 0, hitFlash: 0 };
        const p2 = { name: OPPONENTS[0].name, type: OPPONENTS[0].type, x: 320, y: 225, width: 54, height: 86, color: OPPONENTS[0].shirtColor, pantsColor: OPPONENTS[0].pantsColor, skinColor: OPPONENTS[0].skinColor, hairColor: OPPONENTS[0].hairColor, health: 100, maxHealth: 100, state: 'IDLE', facing: -1, cooldown: 0, hitFlash: 0 };

        const street = { leftBoundary: 40, rightBoundary: 470, manholeX: 430, manholeWidth: 50, policeCarX: -150, policeActive: false };

        const keys = {};
        window.addEventListener('keydown', (e) => {
            if (activeGame === 1) {
                audio.init();
                keys[e.code] = true;
                if (e.code === 'Enter' || e.code === 'Space') {
                    if (gameState === 'TITLE' || gameState === 'GAME_OVER' || gameState === 'GAME_VICTORY') startNextGame();
                }
            } else if (activeGame === 2) {
                audio.init();
                handleSnakeKeyPress(e.code);
            }
        });
        window.addEventListener('keyup', (e) => { if (activeGame === 1) keys[e.code] = false; });

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

        document.getElementById('btnStartGame').addEventListener('click', () => { audio.init(); if (gameState === 'TITLE' || gameState === 'GAME_OVER' || gameState === 'GAME_VICTORY') startNextGame(); });
        document.getElementById('btnToggleMusic').addEventListener('click', () => { audio.init(); const active = audio.toggleBGM(); document.getElementById('btnToggleMusic').innerText = active ? "🎵 BGM MUSIC: ON" : "🔇 BGM MUSIC: OFF"; });
        document.getElementById('btnLight').addEventListener('click', () => { audio.init(); if(gameState==='PLAYING') triggerPunch(p1, false); });
        document.getElementById('btnKick').addEventListener('click', () => { audio.init(); if(gameState==='PLAYING') triggerKick(p1); });
        document.getElementById('btnHeavy').addEventListener('click', () => { audio.init(); if(gameState==='PLAYING') triggerPunch(p1, true); });
        document.getElementById('btnBlock').addEventListener('touchstart', (e) => { e.preventDefault(); keys['Space'] = true; });
        document.getElementById('btnBlock').addEventListener('touchend', (e) => { e.preventDefault(); keys['Space'] = false; });

        function startNextGame() {
            audio.playStart();
            audio.startBGM();
            if (gameState === 'GAME_OVER' || gameState === 'GAME_VICTORY') { currentStageIndex = 0; p1ScoreVal = 0; }
            loadStage(currentStageIndex);
        }

        function loadStage(stageIdx) {
            const oppData = OPPONENTS[stageIdx];
            gameState = 'STAGE_INTRO';
            p1.health = p1.maxHealth; p1.x = 140; p1.state = 'IDLE';
            p2.name = oppData.name; p2.type = oppData.type; p2.color = oppData.shirtColor; p2.pantsColor = oppData.pantsColor; p2.skinColor = oppData.skinColor; p2.hairColor = oppData.hairColor; p2.health = oppData.maxHealth; p2.maxHealth = oppData.maxHealth; p2.x = 320; p2.state = 'IDLE';
            document.getElementById('p2Name').innerText = oppData.name;
            document.getElementById('stageLabel').innerText = `STAGE ${stageIdx + 1}/5`;
            updateHUD();
            overlay.innerHTML = `<div style="font-size:1.4rem; color:#54a0ff;">${oppData.title}</div><div style="font-size:0.85rem; margin-top:10px; color:#feca57;">VS ${oppData.name}</div>`;
            overlay.style.display = 'block';
            setTimeout(() => { if (gameState === 'STAGE_INTRO') { gameState = 'PLAYING'; overlay.style.display = 'none'; startTimer(); } }, 2500);
        }

        function startTimer() {
            timer = 99;
            if (timerInterval) clearInterval(timerInterval);
            timerInterval = setInterval(() => {
                if (gameState === 'PLAYING') {
                    timer--;
                    document.getElementById('gameTimer').innerText = timer < 10 ? '0' + timer : timer;
                    if (timer <= 0) endRound('TIME OUT!');
                    if (timer > 20 && Math.random() < 0.03 && !street.policeActive) triggerPolicePatrol();
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
                if (dist < 62) executeHit(fighter, opponent, isHeavy ? 25 : 12, isHeavy ? 42 : 22, isHeavy);
            }
        }

        function triggerKick(fighter) {
            if (fighter.state === 'IDLE' || fighter.state === 'WALK') {
                fighter.state = 'KICK';
                fighter.cooldown = 18;
                audio.playKick();
                const opponent = (fighter === p1) ? p2 : p1;
                const dist = Math.abs(fighter.x - opponent.x);
                if (dist < 68) executeHit(fighter, opponent, 18, 32, false);
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
                    overlay.innerHTML = `<div style="color:#feca57; font-size:1.4rem;">🏆 VICTORY! 🏆</div><div style="font-size:0.7rem; margin-top:12px; color:#fff;">YOU DEFEATED GENERAL IRONCLAD!</div>`;
                    overlay.style.display = 'block';
                }
            } else {
                gameState = 'GAME_OVER';
                audio.playGameOver();
                overlay.innerHTML = `<div style="color:#ff4757; font-size:1.5rem;">GAME OVER</div><div style="font-size:0.7rem; margin-top:10px; color:#fff;">PRESS START TO RETRY</div>`;
                overlay.style.display = 'block';
            }
        }

        function triggerPolicePatrol() {
            street.policeActive = true;
            street.policeCarX = -150;
            audio.playSiren();
            overlay.innerText = '🚨 POLICE PATROL INCOMING! 🚨';
            overlay.style.display = 'block';
            setTimeout(() => { if (gameState === 'PLAYING') overlay.style.display = 'none'; }, 2500);
        }

        function endRound(msg) {
            gameState = 'ROUND_OVER';
            clearInterval(timerInterval);
            overlay.innerText = msg;
            overlay.style.display = 'block';
            setTimeout(() => { if (p1.health > p2.health) processStageVictory(true); else processStageVictory(false); }, 2500);
        }

        function updateHUD() {
            document.getElementById('p1Health').style.width = (p1.health / p1.maxHealth * 100) + '%';
            document.getElementById('p2Health').style.width = (p2.health / p2.maxHealth * 100) + '%';
            document.getElementById('p1Score').innerText = String(p1ScoreVal).padStart(5, '0');
            document.getElementById('p2Score').innerText = String(p2ScoreVal).padStart(5, '0');
        }

        function updateGame() {
            if (activeGame !== 1 || gameState !== 'PLAYING') return;

            if (p1.hitFlash > 0) p1.hitFlash--;
            if (p2.hitFlash > 0) p2.hitFlash--;

            for (let i = hitParticles.length - 1; i >= 0; i--) {
                const p = hitParticles[i];
                p.x += p.vx; p.y += p.vy; p.vy += 0.45; p.life--;
                if (p.life <= 0) hitParticles.splice(i, 1);
            }

            for (let i = damageTexts.length - 1; i >= 0; i--) {
                const dt = damageTexts[i];
                dt.y += dt.vy; dt.alpha -= 0.03; dt.life--;
                if (dt.life <= 0) damageTexts.splice(i, 1);
            }

            if (screenShakeTime > 0) screenShakeTime--;

            // Continuous NPCs
            if (ambientNPCs.walker.active) {
                ambientNPCs.walker.x += ambientNPCs.walker.speed;
                if (ambientNPCs.walker.x > canvas.width + 60) { ambientNPCs.walker.active = false; ambientNPCs.walker.timer = 120; }
            } else {
                ambientNPCs.walker.timer--; if (ambientNPCs.walker.timer <= 0) { ambientNPCs.walker.active = true; ambientNPCs.walker.x = -60; }
            }

            if (ambientNPCs.drunkard.active) {
                ambientNPCs.drunkard.x += ambientNPCs.drunkard.speed;
                ambientNPCs.drunkard.staggerOffset = Math.sin(Date.now() / 150) * 5;
                if (ambientNPCs.drunkard.x < -60) { ambientNPCs.drunkard.active = false; ambientNPCs.drunkard.timer = 180; }
            } else {
                ambientNPCs.drunkard.timer--; if (ambientNPCs.drunkard.timer <= 0) { ambientNPCs.drunkard.active = true; ambientNPCs.drunkard.x = canvas.width + 60; }
            }

            if (ambientNPCs.blackCat.active) {
                ambientNPCs.blackCat.x += ambientNPCs.blackCat.speed;
                if (ambientNPCs.blackCat.x > canvas.width + 60) { ambientNPCs.blackCat.active = false; ambientNPCs.blackCat.timer = 200; }
            } else {
                ambientNPCs.blackCat.timer--; if (ambientNPCs.blackCat.timer <= 0) { ambientNPCs.blackCat.active = true; ambientNPCs.blackCat.x = -50; }
            }

            if (ambientNPCs.rats.active) {
                ambientNPCs.rats.x += ambientNPCs.rats.speed;
                if (ambientNPCs.rats.x < -60) { ambientNPCs.rats.active = false; ambientNPCs.rats.timer = 240; }
            } else {
                ambientNPCs.rats.timer--; if (ambientNPCs.rats.timer <= 0) { ambientNPCs.rats.active = true; ambientNPCs.rats.x = canvas.width + 60; }
            }

            // Controls P1
            if (p1.cooldown > 0) {
                p1.cooldown--; if (p1.cooldown === 0 && p1.state !== 'KO') p1.state = 'IDLE';
            } else {
                if (keys['Space'] || keys['KeyS']) p1.state = 'BLOCK';
                else if (keys['KeyZ'] || keys['KeyJ']) triggerPunch(p1, false);
                else if (keys['KeyC'] || keys['KeyL']) triggerKick(p1);
                else if (keys['KeyX'] || keys['KeyK']) triggerPunch(p1, true);
                else if (keys['ArrowLeft'] || keys['KeyA']) { p1.x = Math.max(street.leftBoundary, p1.x - 3.4); p1.state = 'WALK'; }
                else if (keys['ArrowRight'] || keys['KeyD']) { p1.x = Math.min(street.manholeX + 20, p1.x + 3.4); p1.state = 'WALK'; }
                else p1.state = 'IDLE';
            }

            // CPU AI
            const oppConfig = OPPONENTS[currentStageIndex];
            if (p2.cooldown > 0) {
                p2.cooldown--; if (p2.cooldown === 0 && p2.state !== 'KO') p2.state = 'IDLE';
            } else {
                const distance = Math.abs(p1.x - p2.x);
                if (distance > 55) { p2.x -= oppConfig.speed; p2.state = 'WALK'; }
                else {
                    const aiChoice = Math.random();
                    if (aiChoice < oppConfig.aiAggression) triggerPunch(p2, false);
                    else if (aiChoice < oppConfig.aiAggression + 0.035) triggerKick(p2);
                    else if (aiChoice < oppConfig.aiAggression + 0.065) triggerPunch(p2, true);
                    else if (aiChoice < oppConfig.aiAggression + 0.09) p2.state = 'BLOCK';
                    else p2.state = 'IDLE';
                }
            }

            p1.x = Math.max(street.leftBoundary, Math.min(street.rightBoundary, p1.x));
            p2.x = Math.max(street.leftBoundary, Math.min(street.rightBoundary, p2.x));

            if (street.policeActive) {
                street.policeCarX += 7.5;
                if (street.policeCarX > canvas.width + 100) street.policeActive = false;
            }

            updateHUD();
        }

        function drawVintageTitleScreen() {
            titleFrame++;
            ctx.fillStyle = '#060912'; ctx.fillRect(0, 0, canvas.width, canvas.height);
            ctx.fillStyle = '#0f172a';
            ctx.fillRect(15, 140, 70, 170); ctx.fillRect(95, 100, 90, 210); ctx.fillRect(195, 120, 80, 190); ctx.fillRect(285, 80, 100, 230); ctx.fillRect(395, 130, 80, 180);
            ctx.fillStyle = (titleFrame % 60 < 30) ? '#feca57' : '#54a0ff';
            ctx.fillRect(110, 120, 18, 22); ctx.fillRect(145, 120, 18, 22); ctx.fillRect(305, 100, 22, 28); ctx.fillRect(345, 100, 22, 28);

            const titleGrad = ctx.createLinearGradient(40, 40, 472, 110);
            titleGrad.addColorStop(0, '#ee5253'); titleGrad.addColorStop(1, '#5f27cd');
            ctx.fillStyle = titleGrad; ctx.fillRect(40, 35, 432, 75);
            ctx.strokeStyle = '#feca57'; ctx.lineWidth = 6; ctx.strokeRect(36, 31, 440, 83);

            ctx.fillStyle = '#ffffff'; ctx.font = '24px "Press Start 2P"'; ctx.textAlign = 'center';
            ctx.fillText("8bitCityChamp", canvas.width / 2, 80);
            ctx.font = '10px "Press Start 2P"'; ctx.fillStyle = '#feca57';
            ctx.fillText("16-BIT SNES STREET FIGHTER", canvas.width / 2, 135);

            if (Math.floor(titleFrame / 30) % 2 === 0) {
                ctx.fillStyle = '#00d2d3'; ctx.font = '12px "Press Start 2P"';
                ctx.fillText("PRESS START TO PLAY", canvas.width / 2, 225);
            }
        }

        function drawBackground() {
            ctx.save();
            if (screenShakeTime > 0) { ctx.translate((Math.random() - 0.5) * 8, (Math.random() - 0.5) * 8); }

            const skyGrad = ctx.createLinearGradient(0, 0, 0, 260);
            skyGrad.addColorStop(0, '#070a14'); skyGrad.addColorStop(1, '#18243b');
            ctx.fillStyle = skyGrad; ctx.fillRect(0, 0, canvas.width, canvas.height);

            ctx.fillStyle = '#261730'; ctx.fillRect(0, 40, canvas.width, 220);
            ctx.fillStyle = '#422550'; ctx.fillRect(30, 70, 95, 85); ctx.fillRect(190, 70, 125, 85); ctx.fillRect(375, 70, 105, 85);

            ctx.fillStyle = (titleFrame % 50 < 25) ? '#ffdd59' : '#ff9f43';
            ctx.fillRect(45, 85, 26, 32); ctx.fillRect(82, 85, 26, 32);
            ctx.fillStyle = '#feca57';
            ctx.fillRect(205, 85, 28, 32); ctx.fillRect(242, 85, 28, 32); ctx.fillRect(279, 85, 28, 32);
            ctx.fillStyle = (titleFrame % 40 < 20) ? '#ffdd59' : '#00d2d3';
            ctx.fillRect(390, 85, 26, 32); ctx.fillRect(435, 85, 26, 32);

            ctx.fillStyle = '#ff4757'; ctx.fillRect(20, 50, 115, 18);
            ctx.fillStyle = '#fff'; ctx.font = '10px "Press Start 2P"'; ctx.textAlign = 'left'; ctx.fillText('BAR 16', 45, 64);
            ctx.fillStyle = '#54a0ff'; ctx.fillRect(185, 50, 140, 18);
            ctx.fillStyle = '#fff'; ctx.fillText('CLUB 84', 215, 64);

            ctx.fillStyle = '#576574'; ctx.fillRect(0, 255, canvas.width, 22);
            ctx.fillStyle = '#8395a7'; ctx.fillRect(0, 255, canvas.width, 4);

            if (ambientNPCs.walker.active) drawProstituteNPC(ambientNPCs.walker.x, ambientNPCs.walker.y);
            if (ambientNPCs.drunkard.active) drawDrunkardNPC(ambientNPCs.drunkard.x, ambientNPCs.drunkard.y + ambientNPCs.drunkard.staggerOffset);
            if (ambientNPCs.blackCat.active) drawBlackCatNPC(ambientNPCs.blackCat.x, ambientNPCs.blackCat.y);
            if (ambientNPCs.rats.active) drawStreetRatsNPC(ambientNPCs.rats.x, ambientNPCs.rats.y);

            ctx.fillStyle = '#1e272e'; ctx.fillRect(0, 277, canvas.width, 110);
            ctx.fillStyle = '#0a0e14'; ctx.beginPath(); ctx.ellipse(street.manholeX + 25, 320, 26, 9, 0, 0, Math.PI * 2); ctx.fill();
            ctx.strokeStyle = '#485460'; ctx.lineWidth = 3; ctx.stroke();

            if (street.policeActive) drawPoliceCar(street.policeCarX, 290);
        }

        function drawProstituteNPC(x, y) {
            ctx.save(); ctx.translate(x, y);
            ctx.fillStyle = 'rgba(0,0,0,0.4)'; ctx.beginPath(); ctx.ellipse(14, 44, 14, 5, 0, 0, Math.PI * 2); ctx.fill();
            ctx.fillStyle = '#feca57'; ctx.fillRect(2, -8, 22, 12);
            ctx.fillStyle = '#ff3388'; ctx.fillRect(16, -10, 8, 6);
            ctx.fillStyle = '#ffeaa7'; ctx.fillRect(8, 2, 14, 12);
            ctx.fillStyle = '#ff4757'; ctx.fillRect(18, 9, 4, 3);
            ctx.fillStyle = '#ff007f'; ctx.fillRect(6, 14, 18, 12);
            ctx.fillStyle = '#fa8231'; ctx.fillRect(8, 16, 4, 3); ctx.fillRect(16, 20, 4, 3);
            ctx.fillStyle = '#d63031'; ctx.fillRect(21, 18, 7, 10);
            ctx.fillStyle = '#ffdd59'; ctx.fillRect(23, 16, 3, 3);
            ctx.fillStyle = '#1e272e'; ctx.fillRect(8, 26, 14, 10);
            const legSwing = Math.sin(Date.now() / 70) * 6;
            ctx.fillStyle = '#ffeaa7'; ctx.fillRect(8 + legSwing, 36, 5, 12); ctx.fillRect(15 - legSwing, 36, 5, 12);
            ctx.fillStyle = 'rgba(0,0,0,0.6)'; ctx.fillRect(8 + legSwing, 38, 5, 2); ctx.fillRect(15 - legSwing, 42, 5, 2);
            ctx.fillStyle = '#ff0055'; ctx.fillRect(8 + legSwing, 46, 7, 4); ctx.fillRect(15 - legSwing, 46, 7, 4);
            ctx.restore();
        }

        function drawDrunkardNPC(x, y) {
            ctx.save(); ctx.translate(x, y);
            ctx.fillStyle = 'rgba(0,0,0,0.4)'; ctx.beginPath(); ctx.ellipse(14, 44, 14, 5, 0, 0, Math.PI * 2); ctx.fill();
            ctx.fillStyle = '#576574'; ctx.fillRect(4, -4, 20, 10);
            ctx.fillStyle = '#ffcc99'; ctx.fillRect(6, 4, 16, 12);
            ctx.fillStyle = '#332211'; ctx.fillRect(6, 12, 16, 4);
            ctx.fillStyle = '#ff4757'; ctx.fillRect(14, 8, 6, 5);
            ctx.fillStyle = '#c8d6e5'; ctx.fillRect(6, 16, 18, 16);
            ctx.fillStyle = '#8395a7'; ctx.fillRect(10, 20, 4, 6);
            ctx.fillStyle = '#10ac84'; ctx.fillRect(-4, 22, 7, 12);
            ctx.fillStyle = '#feca57'; ctx.fillRect(-3, 20, 5, 3);
            if (Math.floor(Date.now() / 200) % 2 === 0) { ctx.fillStyle = '#ffffff'; ctx.fillRect(-6, 32, 4, 4); }
            ctx.fillStyle = '#222f3e'; ctx.fillRect(8, 32, 14, 14);
            ctx.restore();
        }

        function drawBlackCatNPC(x, y) {
            ctx.save(); ctx.translate(x, y);
            ctx.fillStyle = '#feca57'; ctx.fillRect(6, 4, 24, 14);
            ctx.fillStyle = '#050508'; ctx.fillRect(8, 6, 20, 10); ctx.fillRect(24, 0, 10, 10); ctx.fillRect(24, -4, 3, 4); ctx.fillRect(31, -4, 3, 4);
            ctx.fillStyle = '#feca57'; ctx.fillRect(28, 3, 3, 3);
            ctx.fillStyle = '#050508'; const tailY = Math.sin(Date.now() / 60) * 3; ctx.fillRect(4, 2 + tailY, 5, 8);
            const legRun = Math.sin(Date.now() / 40) * 5; ctx.fillRect(10 + legRun, 16, 3, 6); ctx.fillRect(22 - legRun, 16, 3, 6);
            ctx.restore();
        }

        function drawStreetRatsNPC(x, y) {
            ctx.save(); ctx.translate(x, y);
            ctx.fillStyle = '#ff7675'; ctx.fillRect(8, 2, 18, 10);
            ctx.fillStyle = '#3a3a3a'; ctx.fillRect(10, 4, 14, 6);
            ctx.fillStyle = '#ff7675'; ctx.fillRect(22, 5, 4, 3);
            ctx.fillStyle = '#74b9ff'; ctx.fillRect(20, 4, 2, 2);
            ctx.fillStyle = '#3a3a3a'; ctx.fillRect(0, 6, 10, 2);
            const ratLeg = Math.sin(Date.now() / 30) * 3; ctx.fillStyle = '#111'; ctx.fillRect(12 + ratLeg, 10, 2, 3); ctx.fillRect(20 - ratLeg, 10, 2, 3);
            ctx.fillStyle = '#3a3a3a'; ctx.fillRect(32, 6, 12, 5); ctx.fillStyle = '#ff7675'; ctx.fillRect(42, 7, 3, 2); ctx.fillStyle = '#3a3a3a'; ctx.fillRect(24, 8, 8, 2);
            ctx.restore();
        }

        function drawPoliceCar(x, y) {
            ctx.fillStyle = '#000'; ctx.fillRect(x, y, 105, 36);
            ctx.fillStyle = '#fff'; ctx.fillRect(x + 22, y, 62, 19);
            ctx.fillStyle = Math.floor(Date.now() / 140) % 2 === 0 ? '#ff4757' : '#00d2d3'; ctx.fillRect(x + 46, y - 9, 14, 9);
            ctx.fillStyle = '#8395a7'; ctx.beginPath(); ctx.arc(x + 22, y + 36, 11, 0, Math.PI * 2); ctx.arc(x + 84, y + 36, 11, 0, Math.PI * 2); ctx.fill();
        }

        function drawFighter(f) {
            ctx.save();
            const breatheY = (f.state === 'IDLE') ? Math.sin(Date.now() / 220) * 1.5 : 0;
            ctx.translate(f.x, f.y + breatheY);
            if (f.hitFlash > 0) ctx.filter = 'brightness(1.6) drop-shadow(0px 0px 10px #ff4757)';

            ctx.fillStyle = 'rgba(0,0,0,0.5)'; ctx.beginPath(); ctx.ellipse(f.width/2, f.height + 4, 27, 7, 0, 0, Math.PI * 2); ctx.fill();
            ctx.fillStyle = f.skinColor; ctx.fillRect(14, 0, 26, 22);

            ctx.fillStyle = '#222';
            if (f.facing === 1) ctx.fillRect(26, 4, 10, 3); else ctx.fillRect(18, 4, 10, 3);
            ctx.fillStyle = f.state === 'HIT' ? '#ff4757' : (f.state === 'KO' ? '#666' : '#000');
            if (f.facing === 1) { ctx.fillRect(28, 8, 5, 5); ctx.fillStyle = '#fff'; ctx.fillRect(29, 9, 2, 2); }
            else { ctx.fillRect(21, 8, 5, 5); ctx.fillStyle = '#fff'; ctx.fillRect(22, 9, 2, 2); }
            ctx.fillStyle = f.state === 'PUNCH_HEAVY' || f.state === 'KICK' || f.state === 'HIT' ? '#ff4757' : '#552211'; ctx.fillRect(22, 16, 10, 3);

            // ALWAYS SOLID SKIN TORSO BASE (NO TRANSPARENT CHEST)
            ctx.fillStyle = f.skinColor; ctx.fillRect(10, 22, 34, 32);

            if (f.type === 'DICTATOR') {
                ctx.fillStyle = '#1c2413'; ctx.fillRect(8, -12, 38, 14); ctx.fillStyle = '#ffdd59'; ctx.fillRect(8, -2, 38, 3); ctx.fillStyle = '#111'; ctx.fillRect(6, 1, 42, 4); ctx.fillStyle = '#ffdd59'; ctx.fillRect(23, -8, 8, 6); ctx.fillRect(21, -6, 12, 3);
                ctx.fillStyle = '#19130c'; ctx.fillRect(16, 13, 22, 5); ctx.fillRect(14, 16, 4, 3); ctx.fillRect(36, 16, 4, 3);
                ctx.fillStyle = f.color; ctx.fillRect(10, 22, 34, 34);
                ctx.fillStyle = '#ff4757'; ctx.fillRect(18, 22, 6, 4); ctx.fillRect(30, 22, 6, 4);
                ctx.fillStyle = '#ffdd59'; ctx.fillRect(4, 20, 11, 8); ctx.fillRect(39, 20, 11, 8); ctx.fillStyle = '#e1b12c'; ctx.fillRect(4, 28, 11, 4); ctx.fillRect(39, 28, 11, 4);
                ctx.fillStyle = '#ff4757'; ctx.fillRect(15, 27, 6, 4); ctx.fillStyle = '#54a0ff'; ctx.fillRect(22, 27, 6, 4); ctx.fillStyle = '#10ac84'; ctx.fillRect(29, 27, 6, 4); ctx.fillStyle = '#feca57'; ctx.fillRect(15, 32, 6, 4); ctx.fillStyle = '#5f27cd'; ctx.fillRect(22, 32, 6, 4);
                ctx.fillStyle = '#ffdd59'; ctx.fillRect(16, 38, 4, 4); ctx.fillRect(34, 38, 4, 4); ctx.fillRect(16, 45, 4, 4); ctx.fillRect(34, 45, 4, 4);
                ctx.fillStyle = '#0f141a'; ctx.fillRect(10, 50, 34, 7); ctx.fillStyle = '#ffdd59'; ctx.fillRect(23, 49, 8, 9);
            } else if (f.type === 'PUNK') {
                ctx.fillStyle = '#ff4757'; ctx.fillRect(20, -12, 14, 6); ctx.fillStyle = '#f1c40f'; ctx.fillRect(22, -6, 10, 8);
                ctx.fillStyle = f.color; ctx.fillRect(10, 22, 34, 32); ctx.fillStyle = '#c8d6e5'; ctx.fillRect(8, 22, 4, 4); ctx.fillRect(42, 22, 4, 4); ctx.fillRect(8, 28, 4, 4); ctx.fillRect(42, 28, 4, 4); ctx.fillStyle = '#222'; ctx.fillRect(10, 50, 34, 6); ctx.fillStyle = '#fff'; ctx.fillRect(24, 49, 6, 7);
            } else if (f.type === 'BRAWLER') {
                ctx.fillStyle = '#ff4757'; ctx.fillRect(12, 2, 30, 5); ctx.fillRect(f.facing === 1 ? 4 : 40, 4, 8, 12);
                ctx.fillStyle = f.color; ctx.fillRect(12, 22, 30, 30); ctx.fillStyle = '#1e272e'; ctx.fillRect(16, 26, 8, 8); ctx.fillRect(28, 34, 8, 8);
            } else if (f.type === 'BOXER') {
                ctx.fillStyle = 'rgba(255,255,255,0.4)'; ctx.fillRect(26, 1, 6, 4); ctx.fillStyle = '#ffdd59'; ctx.fillRect(18, 22, 18, 4);
                ctx.fillStyle = '#222'; ctx.fillRect(16, 32, 22, 2); ctx.fillStyle = f.color; ctx.fillRect(10, 48, 34, 14); ctx.fillStyle = '#ffdd59'; ctx.fillRect(10, 48, 34, 4);
            } else if (f.type === 'NINJA') {
                ctx.fillStyle = '#111'; ctx.fillRect(12, 0, 30, 22); ctx.fillStyle = '#8395a7'; ctx.fillRect(18, 4, 18, 6); ctx.fillStyle = '#000'; ctx.fillRect(24, 6, 6, 2); ctx.fillStyle = f.skinColor; ctx.fillRect(20, 10, 14, 8); ctx.fillStyle = f.color; ctx.fillRect(10, 22, 34, 34); ctx.fillStyle = '#ffdd59'; ctx.fillRect(24, 22, 6, 34);
            } else {
                ctx.fillStyle = f.hairColor; ctx.fillRect(12, -6, 30, 10); ctx.fillStyle = '#a55eea'; ctx.fillRect(20, -6, 8, 4);
                ctx.fillStyle = f.color; ctx.fillRect(10, 22, 34, 32); ctx.fillStyle = '#fff'; ctx.fillRect(22, 22, 10, 18); ctx.fillStyle = '#c8d6e5'; ctx.fillRect(26, 22, 2, 20);
            }

            ctx.fillStyle = f.pantsColor || '#192a56';
            if (f.state === 'KICK') {
                ctx.fillRect(12, 54, 16, 20); ctx.fillStyle = f.skinColor; ctx.fillRect(12, 74, 16, 12);
                ctx.fillStyle = f.pantsColor || '#192a56'; ctx.fillRect(f.facing === 1 ? 26 : -18, 44, 32, 14);
                ctx.fillStyle = '#0b0e14'; ctx.fillRect(f.facing === 1 ? 58 : -28, 42, 14, 18);
            } else {
                ctx.fillRect(12, 54, 30, 26); ctx.fillStyle = 'rgba(255,255,255,0.12)'; ctx.fillRect(16, 60, 8, 10); ctx.fillRect(30, 60, 8, 10);
                ctx.fillStyle = '#0b0e14'; ctx.fillRect(10, 76, 14, 12); ctx.fillRect(30, 76, 14, 12); ctx.fillStyle = '#8395a7'; ctx.fillRect(16, 78, 2, 6); ctx.fillRect(36, 78, 2, 6);
            }

            ctx.fillStyle = f.skinColor;
            if (f.state === 'PUNCH_LIGHT') { ctx.fillRect(f.facing === 1 ? 36 : -18, 24, 28, 14); ctx.fillStyle = '#222'; ctx.fillRect(f.facing === 1 ? 54 : -18, 24, 10, 14); }
            else if (f.state === 'PUNCH_HEAVY') { ctx.fillRect(f.facing === 1 ? 36 : -24, 22, 34, 16); ctx.fillStyle = '#222'; ctx.fillRect(f.facing === 1 ? 58 : -24, 22, 12, 16); if (f.type === 'DICTATOR') { ctx.fillStyle = '#ffdd59'; ctx.fillRect(f.facing === 1 ? 64 : -28, 18, 8, 24); } }
            else if (f.state === 'KICK') { ctx.fillRect(4, 22, 14, 14); ctx.fillRect(34, 22, 14, 14); }
            else if (f.state === 'BLOCK') { ctx.fillRect(16, 14, 22, 20); ctx.fillStyle = 'rgba(84, 160, 255, 0.4)'; ctx.fillRect(12, 10, 30, 30); }
            else if (f.state === 'HIT') { ctx.rotate((f.facing * -15 * Math.PI) / 180); ctx.fillRect(6, 26, 16, 16); }
            else { ctx.fillRect(4, 26, 14, 16); ctx.fillRect(36, 26, 14, 16); ctx.fillStyle = '#222'; ctx.fillRect(4, 34, 14, 8); ctx.fillRect(36, 34, 14, 8); }

            if (f.state === 'KO') ctx.translate(0, 34);
            ctx.restore();
        }

        function renderGame1() {
            if (gameState === 'TITLE') {
                drawVintageTitleScreen();
                document.getElementById('hudBar').style.display = 'none';
            } else {
                document.getElementById('hudBar').style.display = 'flex';
                drawBackground();
                drawFighter(p1);
                drawFighter(p2);
                for (let p of hitParticles) { ctx.fillStyle = p.color; ctx.fillRect(p.x, p.y, p.size, p.size); }
                ctx.font = '10px "Press Start 2P"'; ctx.shadowColor = '#000'; ctx.shadowOffsetX = 2; ctx.shadowOffsetY = 2;
                for (let dt of damageTexts) { ctx.fillStyle = `rgba(255, 71, 87, ${dt.alpha})`; ctx.fillText(dt.text, dt.x, dt.y); }
                ctx.restore();
            }
        }

        // ----------------------------------------------------
        // GAME 2 ENGINE: PAPER MARIO PERSIAN MARKET SNAKE WHACK
        // ----------------------------------------------------
        const snakeCanvas = document.getElementById('snakeCanvas');
        const sCtx = snakeCanvas.getContext('2d');

        let snakeScore = 0;
        let snakeTimer = 45;
        let snakeTimerInt = null;
        let snakeGameState = 'READY';

        const baskets = [
            { id: 0, key: 'KeyA', name: 'A', x: 60, y: 260 },
            { id: 1, key: 'KeyS', name: 'S', x: 155, y: 260 },
            { id: 2, key: 'KeyD', name: 'D', x: 250, y: 260 },
            { id: 3, key: 'KeyF', name: 'F', x: 345, y: 260 },
            { id: 4, key: 'KeyG', name: 'G', x: 440, y: 260 }
        ];

        let currentSnakeBasket = -1;
        let snakeHeight = 0; // 0 to 45
        let snakeState = 'HIDDEN'; // 'RISING', 'UP', 'HIT', 'HIDING', 'HIDDEN'
        let snakeStateTimer = 0;
        let activeClubBasket = -1;
        let clubSwingAnim = 0;

        const starsFX = [];

        // Bind Touch Buttons for Game 2
        baskets.forEach((b, idx) => {
            const btn = document.getElementById(`btnBasket${idx}`);
            if (btn) {
                btn.addEventListener('touchstart', (e) => { e.preventDefault(); audio.init(); whackBasket(idx); });
                btn.addEventListener('click', () => { audio.init(); whackBasket(idx); });
            }
        });

        document.getElementById('btnStartSnake').addEventListener('click', () => {
            audio.init();
            startSnakeGame();
        });

        function handleSnakeKeyPress(code) {
            const idx = baskets.findIndex(b => b.key === code);
            if (idx !== -1) whackBasket(idx);
        }

        function initSnakeGame() {
            snakeScore = 0;
            snakeTimer = 45;
            snakeGameState = 'READY';
            document.getElementById('snakeScore').innerText = '0000';
            document.getElementById('snakeTimer').innerText = '45';
            document.getElementById('snakeOverlay').innerHTML = `PAPER SNAKE BAZAAR<br><span style="font-size:0.65rem; color:#fff;">PRESS A-S-D-F-G OR TAP BASKETS!</span>`;
            document.getElementById('snakeOverlay').style.display = 'block';
        }

        function startSnakeGame() {
            audio.playStart();
            snakeScore = 0;
            snakeTimer = 45;
            snakeGameState = 'PLAYING';
            document.getElementById('snakeScore').innerText = '0000';
            document.getElementById('snakeOverlay').style.display = 'none';

            if (snakeTimerInt) clearInterval(snakeTimerInt);
            snakeTimerInt = setInterval(() => {
                if (snakeGameState === 'PLAYING') {
                    snakeTimer--;
                    document.getElementById('snakeTimer').innerText = snakeTimer;
                    if (snakeTimer <= 0) {
                        snakeGameState = 'GAME_OVER';
                        audio.playWin();
                        clearInterval(snakeTimerInt);
                        document.getElementById('snakeOverlay').innerHTML = `TIME UP!<br><span style="font-size:0.8rem; color:#f1c40f;">FINAL SCORE: ${snakeScore}</span><br><span style="font-size:0.6rem; color:#fff;">PRESS START TO RETRY</span>`;
                        document.getElementById('snakeOverlay').style.display = 'block';
                    }
                }
            }, 1000);

            spawnSnakeRandom();
        }

        function spawnSnakeRandom() {
            if (snakeGameState !== 'PLAYING') return;
            currentSnakeBasket = Math.floor(Math.random() * 5);
            snakeHeight = 0;
            snakeState = 'RISING';
            snakeStateTimer = 0;
        }

        function whackBasket(basketIdx) {
            if (snakeGameState !== 'PLAYING') return;
            
            activeClubBasket = basketIdx;
            clubSwingAnim = 10;
            audio.playWhack();

            if (basketIdx === currentSnakeBasket && (snakeState === 'RISING' || snakeState === 'UP')) {
                // HIT SUCCESS!
                snakeState = 'HIT';
                snakeScore += 100;
                document.getElementById('snakeScore').innerText = String(snakeScore).padStart(4, '0');

                // Spawn Paper Mario Stars & Bump FX
                const b = baskets[basketIdx];
                for (let i = 0; i < 8; i++) {
                    starsFX.push({
                        x: b.x,
                        y: b.y - 45,
                        vx: (Math.random() - 0.5) * 6,
                        vy: -Math.random() * 5 - 2,
                        rot: Math.random() * Math.PI,
                        life: 25
                    });
                }

                setTimeout(() => {
                    if (snakeState === 'HIT') spawnSnakeRandom();
                }, 400);
            }
        }

        function updateSnakeGame() {
            if (activeGame !== 2) return;

            if (clubSwingAnim > 0) clubSwingAnim--;

            // Update Star FX
            for (let i = starsFX.length - 1; i >= 0; i--) {
                const st = starsFX[i];
                st.x += st.vx;
                st.y += st.vy;
                st.vy += 0.3;
                st.rot += 0.2;
                st.life--;
                if (st.life <= 0) starsFX.splice(i, 1);
            }

            if (snakeGameState === 'PLAYING') {
                if (snakeState === 'RISING') {
                    snakeHeight += 3.5;
                    if (snakeHeight >= 42) {
                        snakeHeight = 42;
                        snakeState = 'UP';
                        snakeStateTimer = 35; // Frames to stay up
                    }
                } else if (snakeState === 'UP') {
                    snakeStateTimer--;
                    if (snakeStateTimer <= 0) {
                        snakeState = 'HIDING';
                    }
                } else if (snakeState === 'HIDING') {
                    snakeHeight -= 4;
                    if (snakeHeight <= 0) {
                        snakeHeight = 0;
                        snakeState = 'HIDDEN';
                        spawnSnakeRandom();
                    }
                }
            }
        }

        // PAPER MARIO PERSIAN BAZAAR GRAPHICAL RENDER ENGINE
        function renderSnakeGame() {
            if (activeGame !== 2) return;

            // Persian Night Sky & Stars Background
            const skyGrad = sCtx.createLinearGradient(0, 0, 0, 240);
            skyGrad.addColorStop(0, '#0c0714');
            skyGrad.addColorStop(1, '#2c122e');
            sCtx.fillStyle = skyGrad;
            sCtx.fillRect(0, 0, snakeCanvas.width, snakeCanvas.height);

            // Crescent Moon & Stars
            sCtx.fillStyle = '#f1c40f';
            sCtx.beginPath(); sCtx.arc(440, 50, 24, 0, Math.PI * 2); sCtx.fill();
            sCtx.fillStyle = '#0c0714';
            sCtx.beginPath(); sCtx.arc(430, 44, 20, 0, Math.PI * 2); sCtx.fill();

            // Hanging Persian Lanterns
            [80, 200, 320, 440].forEach(lx => {
                sCtx.strokeStyle = '#f39c12'; sCtx.lineWidth = 2;
                sCtx.beginPath(); sCtx.moveTo(lx, 0); sCtx.lineTo(lx, 35); sCtx.stroke();
                sCtx.fillStyle = '#e67e22'; sCtx.fillRect(lx - 10, 35, 20, 22);
                sCtx.fillStyle = '#f1c40f'; sCtx.fillRect(lx - 6, 39, 12, 14); // Glowing light
            });

            // Bazaar Archway & Oriental Carpet Ground
            sCtx.fillStyle = '#4a2311'; sCtx.fillRect(0, 230, snakeCanvas.width, 154);
            // Carpet Pattern
            const carpetGrad = sCtx.createLinearGradient(0, 240, 0, 384);
            carpetGrad.addColorStop(0, '#8e1b1b');
            carpetGrad.addColorStop(1, '#5c0d0d');
            sCtx.fillStyle = carpetGrad;
            sCtx.fillRect(15, 245, 482, 125);
            sCtx.strokeStyle = '#f1c40f'; sCtx.lineWidth = 4;
            sCtx.strokeRect(15, 245, 482, 125);

            // DRAW PAPER MARIO STYLE SNAKE & BASKETS
            baskets.forEach((b, idx) => {
                sCtx.save();
                sCtx.translate(b.x, b.y);

                // Basket Shadow
                sCtx.fillStyle = 'rgba(0,0,0,0.4)';
                sCtx.beginPath(); sCtx.ellipse(0, 36, 32, 10, 0, 0, Math.PI * 2); sCtx.fill();

                // Draw Snake rising from Basket
                if (idx === currentSnakeBasket && snakeHeight > 0) {
                    sCtx.save();
                    sCtx.translate(0, -snakeHeight);

                    // Paper Cutout Shadow Offset
                    sCtx.fillStyle = 'rgba(0,0,0,0.3)';
                    sCtx.fillRect(-12, -28, 28, snakeHeight + 20);

                    // White Paper Border Outline
                    sCtx.fillStyle = '#ffffff';
                    sCtx.fillRect(-18, -34, 36, 38);

                    // Cobra Snake Body (Green Papercraft with Diamond Texture)
                    sCtx.fillStyle = '#2ecc71';
                    sCtx.fillRect(-15, -31, 30, 34);
                    sCtx.fillStyle = '#27ae60';
                    sCtx.fillRect(-10, -20, 20, 20);

                    // Cobra Hood Wings
                    sCtx.fillStyle = '#2ecc71';
                    sCtx.beginPath(); sCtx.ellipse(0, -15, 22, 12, 0, 0, Math.PI * 2); sCtx.fill();
                    sCtx.fillStyle = '#f1c40f';
                    sCtx.fillRect(-8, -18, 16, 8);

                    // Snake Head & Expression
                    sCtx.fillStyle = '#2ecc71';
                    sCtx.fillRect(-14, -36, 28, 18);

                    if (snakeState === 'HIT') {
                        // HIT STATE: X_X Eyes, Tongue Out, and Big Red Lump / Bump (Chichón!)
                        sCtx.fillStyle = '#111';
                        sCtx.font = '12px sans-serif';
                        sCtx.fillText('X', -10, -26);
                        sCtx.fillText('X', 2, -26);

                        // Red Lump / Bump (Chichón)
                        sCtx.fillStyle = '#ff4757';
                        sCtx.beginPath(); sCtx.arc(0, -42, 10, 0, Math.PI * 2); sCtx.fill();
                        sCtx.strokeStyle = '#fff'; sCtx.lineWidth = 2; sCtx.stroke();
                    } else {
                        // Cheeky Normal Eyes & Snake Tongue
                        sCtx.fillStyle = '#fff';
                        sCtx.fillRect(-10, -32, 7, 7); sCtx.fillRect(3, -32, 7, 7);
                        sCtx.fillStyle = '#000';
                        sCtx.fillRect(-8, -30, 3, 3); sCtx.fillRect(5, -30, 3, 3);
                        // Forked Red Tongue
                        sCtx.fillStyle = '#e74c3c';
                        sCtx.fillRect(-2, -18, 4, 8); ctx.fillRect(-4, -10, 8, 2);
                    }

                    sCtx.restore();
                }

                // PAPER MARIO WOVEN BASKET (Canasto de Mimbre)
                // White Paper Border Outline
                sCtx.fillStyle = '#ffffff';
                sCtx.fillRect(-34, -4, 68, 44);

                // Woven Golden Basket Body
                sCtx.fillStyle = '#d35400';
                sCtx.fillRect(-31, -1, 62, 38);

                // Basket Weave Texture Stripes
                sCtx.fillStyle = '#f39c12';
                sCtx.fillRect(-31, 6, 62, 5);
                sCtx.fillRect(-31, 18, 62, 5);
                sCtx.fillRect(-31, 30, 62, 5);
                sCtx.fillRect(-16, -1, 6, 38);
                sCtx.fillRect(10, -1, 6, 38);

                // Basket Rim Top Opening
                sCtx.fillStyle = '#e67e22';
                sCtx.beginPath(); sCtx.ellipse(0, -1, 31, 8, 0, 0, Math.PI * 2); sCtx.fill();
                sCtx.fillStyle = '#2c1a0e'; // Inner dark hole
                sCtx.beginPath(); sCtx.ellipse(0, -1, 25, 5, 0, 0, Math.PI * 2); sCtx.fill();

                // Key Label Badge [A] [S] [D] [F] [G]
                sCtx.fillStyle = '#f1c40f';
                sCtx.fillRect(-12, 14, 24, 16);
                sCtx.fillStyle = '#000';
                sCtx.font = '10px "Press Start 2P"';
                sCtx.textAlign = 'center';
                sCtx.fillText(b.name, 0, 27);

                // DRAW WOODEN CLUB / MALLET SWING ANIMATION (Garrote de Madera)
                if (activeClubBasket === idx && clubSwingAnim > 0) {
                    sCtx.save();
                    sCtx.translate(0, -45);
                    sCtx.rotate(-Math.PI / 4 * (clubSwingAnim / 10));

                    // Wooden Mallet Handle
                    sCtx.fillStyle = '#8e44ad';
                    sCtx.fillStyle = '#5c3818';
                    sCtx.fillRect(-4, -45, 8, 45);

                    // Heavy Wooden Mallet Head
                    sCtx.fillStyle = '#8c531d';
                    sCtx.fillRect(-22, -65, 44, 22);
                    sCtx.fillStyle = '#f1c40f'; // Metal bands
                    sCtx.fillRect(-22, -65, 6, 22); sCtx.fillRect(16, -65, 6, 22);

                    sCtx.restore();
                }

                sCtx.restore();
            });

            // DRAW SPINNING STARS FX ON HIT
            for (let st of starsFX) {
                sCtx.save();
                sCtx.translate(st.x, st.y);
                sCtx.rotate(st.rot);
                sCtx.fillStyle = '#f1c40f';
                sCtx.font = '14px sans-serif';
                sCtx.fillText('⭐', 0, 0);
                sCtx.restore();
            }
        }

        // MAIN COMBINED GAME LOOP
        function mainLoop() {
            if (activeGame === 1) {
                updateGame();
                renderGame1();
            } else if (activeGame === 2) {
                updateSnakeGame();
                renderSnakeGame();
            }
            requestAnimationFrame(mainLoop);
        }

        mainLoop();
    </script>
</body>
</html>
EOF

# Wipe any default Nginx index files
rm -f /var/www/html/index.nginx-debian.html

# Ensure default Nginx site configuration points cleanly to index.html
cat << 'NGINX_CONF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }
}
NGINX_CONF

# Ensure proper permissions and ownership
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Enable and restart Nginx
systemctl enable nginx
systemctl restart nginx

echo "=== 8bit Arcade Hub Startup Script Completed Successfully at $(date) ==="

