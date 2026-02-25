# Coffee Shop Narrative Game (Godot 4.x)

This is a Godot 4.x project template for a coffee shop simulation game with emerging narrative elements.

## Features
- **Coffee Preparation**: Drag and drop coffee cups to serve customers.
- **Customers**: Randomized spawn, wait time, tip calculation based on speed.
- **Narrative**: A phone interface to check messages and game progress.
- **Scoring**: Earn money and tips.

## Setup Instructions
1. Open this project in Godot Engine (v4.0 or later).
2. The main scene is `src/scenes/Main.tscn`.
3. The game uses placeholder assets (colored squares). Check `assets/ASSETS_LIST.txt` for the list of art assets you need to create to replace these placeholders.

## Project Structure
- `src/scenes/`: Contains all `.tscn` scene files.
- `src/scripts/`: Contains all `.gd` script files.
- `assets/`: Folder for your images and sounds.

## Customization
- **Dialogue**: Modify `src/scripts/GameManager.gd` to add new narrative events or customer types.
- **Visuals**: Replace the placeholder `ColorRect` nodes in scenes with `Sprite2D` nodes using your own images.
