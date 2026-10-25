# KU – Kurdish United Keyboard for Linux

A phonetic **Kurdish United Keyboard** layout for Linux (XKB) for **zza, kmr, ckb, hac, sdh, luri, lak**,
including the extended letters `ڎ ڕ ڤ ڵ ڼ ۋ ۊ ۆ ۇ ە ێ ې` and `ع غ ح`.

Works on any Linux distribution, on both **X11** and **Wayland**. No root access required.
Tested on **Debian 13 (trixie)** with **XFCE on X11**.

## Features

- Phonetic mapping: each letter sits on the Latin key that sounds like it (`b` → `ب`, `l` → `ل`, …)
- Two variants: `basic` for US QWERTY, `qwertz` for German QWERTZ keyboards
- Per-user install in `~/.config/xkb`, so no `sudo` and no changes to system files
- Shows up as **KU (United Keyboard)** in GNOME and KDE keyboard settings
- On X11: loaded automatically at login, switch layouts with **Alt + Shift**

## Layout

`Shift` gives the second letter shown on a key.

| Key | Normal | Shift |   | Key | Normal | Shift |
|:---:|:------:|:-----:|---|:---:|:------:|:-----:|
| `q` | ق | ظ |   | `g` | گ | غ |
| `w` | و | ۇ |   | `h` | ه | ح |
| `e` | ە | ة |   | `j` | ج | أ |
| `r` | ر | ڕ |   | `k` | ک | ك |
| `t` | ت | ط |   | `l` | ل | ڵ |
| `y` | ی | ێ |   | `z` | ز | ژ |
| `u` | ئ | ع |   | `x` | خ | ض |
| `i` | ې | ی |   | `c` | چ | ص |
| `o` | ۊ | ۆ |   | `v` | ۋ | ڤ |
| `p` | پ | ث |   | `b` | ب | ى |
| `a` | ا | آ |   | `n` | ن | ڼ |
| `s` | س | ش |   | `m` | م | ـ |
| `d` | د | ڎ |   | `,` | ، | , |
| `f` | ف | إ |   | `Space` | space | ZWNJ |

Digits and other punctuation are inherited from the base layout (`us` or `de`).

## Hawrami Alphabet (ئەلفابێتی هۆرامی)

Arabic-script letters with their Latin equivalents. The Latin letters are for reference only;
the keyboard types the Arabic-script letters.

| Letter | Latin |   | Letter | Latin |
|:------:|:-----:|---|:------:|:-----:|
| ئـ | Əə |   | ف | Ff |
| ا | Aa |   | ڤ | Vv |
| ب | Bb |   | ق | Qq |
| پ | Pp |   | ک | Kk |
| ت | Tt |   | ل | Ll |
| ج | Jj |   | ڵ | ľ |
| چ | Çç |   | م | Mm |
| ح | Ħħ |   | ن | Nn |
| خ | Xx |   | ڼ | ŋ |
| د | Dd |   | هـ | Hh |
| ڎ | đ |   | ۋ | Ṿṿ |
| ر | Rr |   | و | w, u |
| ڕ | Ŗŗ |   | ۊ | ü |
| ز | Zz |   | ۇ / وو | ẅ |
| ژ | Jj, Ẑẑ |   | ۆ | o |
| س | Ss |   | ە | e |
| ش | Şş, Ŝŝ |   | ی | y, i |
| ع | Ƹƹ |   | ێ | ê |
| غ | Ġġ |   | ې | ᴉ |

## Requirements

- Any Linux distribution with an X11 or Wayland session
- On **X11** only, `setxkbmap` and `xkbcomp`:

| Distribution           | Command                                        |
|------------------------|------------------------------------------------|
| Debian / Ubuntu / Mint | `sudo apt install x11-xkb-utils`               |
| Fedora                 | `sudo dnf install setxkbmap xkbcomp`           |
| Arch / Manjaro         | `sudo pacman -S xorg-setxkbmap xorg-xkbcomp`   |
| openSUSE               | `sudo zypper install setxkbmap xkbcomp`        |

Check your session type with `echo $XDG_SESSION_TYPE`.

## Installation

```bash
git clone https://github.com/Jirlee/kurdish-keyboard.git
cd kurdish-keyboard
./install.sh
```

On every session, the installer:

1. Copies `symbols/ku_custom` to `~/.config/xkb/symbols/`
2. Copies `rules/evdev.xml` to `~/.config/xkb/rules/` so desktop settings can list the layout

### Wayland (GNOME, KDE Plasma, …)

Log out and back in, then add the layout like any other language:

- **GNOME:** Settings → Keyboard → Input Sources → **+** → Kurdish → **KU (United Keyboard)**
- **KDE Plasma:** System Settings → Keyboard → Layouts → Add → **KU (United Keyboard)**

Pick **KU (United Keyboard, QWERTZ)** if your keyboard is German. Switch layouts with the desktop's own shortcut
(GNOME: **Super + Space**).

> If `~/.config/xkb/rules/evdev.xml` already exists, the installer leaves it untouched.
> Copy the `<layout>` block from [`rules/evdev.xml`](rules/evdev.xml) into it by hand.

### X11 (XFCE, MATE, Cinnamon, LXQt, …)

The installer also:

1. Detects your current layout (e.g. `de`) and picks the matching variant (`qwertz` or `basic`)
2. Creates the loader script `~/.local/bin/ku-keyboard`
3. Adds `~/.config/autostart/ku-keyboard.desktop` so the layout is loaded at every login
4. Loads the layout right away

GNOME and KDE on X11 may reset the layout at login. There, add **KU (United Keyboard)** in the keyboard settings instead.

#### Options

Set these environment variables to override the X11 defaults:

```bash
BASE_LAYOUT=us TOGGLE=grp:win_space_toggle ./install.sh
```

| Variable      | Default                 | Description                         |
|---------------|-------------------------|-------------------------------------|
| `BASE_LAYOUT` | your current layout     | Layout to switch back and forth with |
| `TOGGLE`      | `grp:alt_shift_toggle`  | XKB option for switching layouts    |

## Usage

- Press **Alt + Shift** (X11) or your desktop's shortcut (Wayland) to switch to Kurdish
- Press **Shift + Space** to insert a zero-width non-joiner (ZWNJ)
- On X11, if the layout is lost (for example after XFCE resets it), run `ku-keyboard` again

To try it once on X11 without installing anything:

```bash
setxkbmap -layout de,ku_custom -variant ,qwertz -option grp:alt_shift_toggle -print \
    | xkbcomp -I"$PWD" -w 0 - "$DISPLAY"
```

## Uninstall

```bash
./uninstall.sh
```

## How It Works

Linux handles keyboard layouts with **XKB**. A layout is a *symbols* file that maps physical key codes
(`<AD01>` is the key labelled `Q` on QWERTY) to characters:

```xkb
key <AC01> { [ U0627, U0622 ] };   // a : ا  آ
```

Each key has a list of levels: the first entry is typed normally, the second with `Shift`.
Characters are written as Unicode code points (`U0627` = `ا`).

- **Wayland:** the compositor uses `libxkbcommon`, which also searches `~/.config/xkb/`.
  `rules/evdev.xml` registers the layout name so GNOME and KDE list it in their settings.
- **X11:** `setxkbmap -print` builds a full keymap that uses both your base layout and `ku_custom`,
  and `xkbcomp -I~/.config/xkb` compiles it into the running X server.

## Project Structure

```
.
├── symbols/
│   └── ku_custom   # XKB layout definition
├── rules/
│   └── evdev.xml    # Registers the layout for desktop settings
├── install.sh       # Per-user installer
├── uninstall.sh     # Removes everything installed
└── README.md
```

## Author

Made by **[Jirlee Team](https://github.com/Jirlee)**.

🌐 Website: [jirlee.com](https://jirlee.com)
