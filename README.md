# Mac Setup Scripts 🏠➡️📦

> *Because nobody has time to manually install 47 different apps every time they get a new Mac.*

Hey there! 👋 So you got a new Mac, or you're about to migrate to one? Cool! This repo is basically your best friend for setting up your development environment without losing your sanity.

## What's this all about? 🤔

This is a collection of scripts that will:
- **Install** all your favorite tools and apps automatically (we call this "settling in" 🏠)
- **Back up** your current setup when you're ready to move (we call this "moving out" 📦)
- Keep everything **organized** and **reproducible**

Think of it as your digital moving truck, but way cooler and with more emojis.

## Quick Start (for the impatient) 🚀

```bash
# Clone this bad boy
git clone <your-repo-url> ~/setup
cd ~/setup

# Make everything executable (trust us, the computer needs this)
chmod +x *.sh

# Install everything and grab some coffee ☕
./settle-in.sh
```

That's it! Seriously. Go make that coffee, this might take a few minutes.

## The Scripts (aka your new toolkit) 🛠️

### `settle-in.sh` - Your new Mac BFF
This is what you run when you want to set up a fresh Mac. It'll:
- Install Homebrew (if you don't have it)
- Install all the tools from your `Brewfile`
- Make you feel like a setup wizard ✨

```bash
./settle-in.sh
```

### `move-out.sh` - The responsible adult script
Run this before you switch computers or when you want to clean up:
- Backs up your current configuration
- Shows you what you have installed
- Can nuke everything if you're feeling destructive 💥

```bash
./move-out.sh
```

### `brew-manager.sh` - The workhorse
This is the engine behind everything. You can use it directly if you want more control:

```bash
./brew-manager.sh install    # Install everything
./brew-manager.sh update     # Update everything  
./brew-manager.sh list       # Show what's installed
./brew-manager.sh backup     # Save current state
./brew-manager.sh uninstall  # Remove everything (careful!)
./brew-manager.sh help       # When you forget stuff
```

## The Brewfile - Your app wishlist �

The `Brewfile` is where the magic happens. It's basically your shopping list of apps and tools. Want to add something? Just edit it:

```bash
# Command line tools
brew "git"
brew "node"
brew "python3"

# GUI Applications  
cask "visual-studio-code"
cask "google-chrome"
cask "slack"

# Fonts (because developers are picky about fonts)
cask "font-fira-code"
```

## Typical Workflow 🔄

### Setting up a new Mac:
1. Clone this repo
2. Run `./settle-in.sh`
3. Customize the `Brewfile` if needed
4. Run `./brew-manager.sh install` again
5. Profit! 💰

### Preparing to move:
1. Run `./move-out.sh`
2. Choose "Backup current configuration"
3. Copy this entire folder to your new Mac
4. On the new Mac, run `./settle-in.sh`
5. Everything should be exactly as you left it

### Regular maintenance:
```bash
./brew-manager.sh update  # Keep everything fresh
```

## What gets installed by default? 📦

The default `Brewfile` includes essentials like:
- **Dev tools**: Git, Node.js, Python, Docker
- **Utilities**: wget, curl, tree, htop
- **Apps**: VS Code, Chrome, iTerm2
- **Fonts**: Fira Code, JetBrains Mono

Don't like something? Comment it out with `#`. Want more? Add it!

## Pro Tips 💡

- **Backup regularly**: Run `./move-out.sh` occasionally to save your config
- **Version control**: Keep this folder in Git so you never lose your setup
- **Customize freely**: The `Brewfile` is yours to modify
- **Share with friends**: They'll think you're a setup genius

## File Structure (for the curious) 📁

```
setup/
├── README.md           # You are here
├── settle-in.sh        # The "move in" script  
├── move-out.sh         # The "move out" script
├── brew-manager.sh     # The main engine
├── utils.sh           # Pretty colors and helper functions
├── Brewfile           # Your app configuration
└── backups/           # Where old configs go to retire
```

## Troubleshooting 🚨

**Script says "Permission denied"?**
```bash
chmod +x *.sh
```

**Homebrew acting weird?**
```bash
brew doctor
```

**Something broke and you're panicking?**
Don't worry! Your backups are in the `backups/` folder. Just restore from there.

**Want to start fresh?**
Delete everything and run `./settle-in.sh` again. It'll create a new default setup.

## Why this is awesome 😎

- **No more forgetting** that one app you always install
- **Reproducible setups** across multiple machines
- **Easy migration** when you get a new computer
- **Backup everything** so you never lose your perfect setup
- **Looks professional** when your colleagues ask how you set up so fast

## Contributing 🤝

Found a bug? Have an idea? Want to add more emoji? Feel free to:
- Open an issue
- Submit a pull request  
- Tell your friends about this repo

---

*Made with ❤️ and probably too much coffee ☕*

*P.S. Yes, we know there are other setup tools out there. This one is ours and we like it.* 🤷‍♂️