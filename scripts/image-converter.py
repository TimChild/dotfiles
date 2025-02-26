# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "pillow",
#     "typer",
# ]
# ///

from pathlib import Path
from PIL import Image
import typer

app = typer.Typer()

ORIG_DIR = "originals"
SKIP_EXTENSIONS = {".webp", ".ico", ".svg"}


def convert_images_to_webp(directory: str = "."):
    # Create the 'originals' directory if it doesn't exist
    directory_path = Path(directory)
    originals_dir = directory_path / ORIG_DIR
    originals_dir.mkdir(exist_ok=True)

    # Iterate over all files in the given directory
    for filepath in directory_path.iterdir():
        if filepath.is_dir():
            continue
        if filepath.suffix in SKIP_EXTENSIONS:
            continue

        try:
            # Open an image file
            with Image.open(filepath) as img:
                # Define the new file name
                new_filename = filepath.with_suffix(".webp")

                # Convert and save the image as webp
                img.save(new_filename, "webp")

                # Move the original file to 'originals' directory
                filepath.rename(originals_dir / filepath.name)
                print(f"Converted and moved: {filepath.name}")

        except Exception as e:
            print(f"Skipping {filepath.name}, error: {e}")


@app.command()
def main(directory: str = typer.Argument(".", help="Directory to process images")):
    convert_images_to_webp(directory)


if __name__ == "__main__":
    app()
