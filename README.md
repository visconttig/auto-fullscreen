# 🖥️ AutoFullScreen Ninja 🥷

_A sneaky little AHK script that toggles fullscreen based on your mouse habits._

## ✨ What is this sorcery?

This AutoHotKey (AHK) script is your productivity buddy that silently watches your mouse movements and _bam!_—throws your favorite apps into fullscreen like a ninja… and pulls them back when you're done. No more fumbling with `F11` like it's a secret handshake.

Designed to work with:

- 🧭 Google Chrome
- 🛠️ Visual Studio Code
- 🛠️ IntelliJ
- 🛠️ PyCharm
- 🛠️ Hyper Terminal
- Postman
- Figma
- Cold Turkey Blocker
- Everything
  > A File Searching tool
- 🧠 Anki
- The Windows 'Settings' panel
- The Windows 'Control Panel' and 'File Explorer'

You chill. It fullscreens.

---

## 🧠 How It Works

Here's what this script does, in plain English:

1. **Keeps an eye** 👁️ on your active window.
2. If you're using Chrome, Code, or Anki (grouped under `programs`), it starts watching your mouse like a hawk.
3. If your mouse stays still for 1 second (`idle = 1000ms`), it fullscreens the app (presses `F11`).
4. If you move your mouse near the top/bottom of the screen (`margin = 10px`) _and_ you're in fullscreen, it pulls you out (again with `F11`).
5. You can manually toggle this whole script on/off with `F11` or `F2`.

Yes, it’s that smooth.

---

## 🚀 How To Use It

### 🔧 Prerequisites

- Install [AutoHotKey](https://www.autohotkey.com/).
- Be on Windows.
- Have the urge to automate your life.

### 📦 Setup

1. Save the script as something like `AutoFullScreen.ahk`.
2. Run it by double-clicking.
3. Want it to start every time you boot? The script takes care of that too!

   ```ahk
   FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%A_ScriptName%.lnk, %A_ScriptDir%
   ```

   That magical line auto-creates a shortcut to your Startup folder. So yes, it launches with Windows. 🎉

---

## 💡 Pro Tips

- 🐭 Don't worry about every little mouse wiggle—there's a `tolerance` value (4 pixels) to ignore minor movements.
- 💾 It checks every `350ms` when the app is active, so it’s responsive without being annoying.
- 🔘 Press `F11` or `F2` to pause/resume the script if you need a break from fullscreen mode mania.

## 🧪 Why This Is Cool

- **Saves you time.** No more fumbling with `F11` manually.
- **Boosts focus.** When your app is fullscreen, you're less likely to tab away.
- **Smooth AF.** Transitions feel natural, intuitive, and responsive.

---

## 🐞 Known Quirks

- Doesn’t play well with _every_ app—just the ones you list in the `GroupAdd`.
- Some apps handle fullscreen differently, so results may vary.
- If your cat walks across your mousepad, it may toggle fullscreen. 🐈

---

## 🙌 Contributions & Kudos

Feel free to fork, modify, suggest cool ideas, or just say hi. This is just a fun automation project for people who love clean screens and smooth workflows.

---

## 🧙‍♂️ License

Do whatever you want with it. Just don’t sell it to wizards without letting me know.
