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
SKIP_EXTENSIONS = {".ico", ".svg"}


def convert_images_to_webp(
    directory: str, max_width: int, max_height: int, quality: int
) -> None:
    # Create the 'originals' directory if it doesn't exist
    directory_path = Path(directory)
    originals_dir = directory_path / ORIG_DIR
    originals_dir.mkdir(exist_ok=True)

    # Iterate over all files in the given directory
    for filepath in directory_path.iterdir():
        if filepath.is_dir():
            print("Skipping directory", filepath.name)
            continue
        if filepath.suffix in SKIP_EXTENSIONS:
            print("Skipping file with extension:", filepath.name)
            continue
        print("Processing:", filepath.name)

        try:
            # Open an image file
            with Image.open(filepath) as img:
                # Copy the original file to 'originals' directory
                original_filename = originals_dir / filepath.name
                filepath.rename(original_filename)

                # Resize the image
                img.thumbnail((max_width, max_height))

                # Define the new file name
                new_filename = filepath.with_suffix(".webp")

                # Convert and save the image as webp
                img.save(new_filename, "webp", optimize=True, quality=quality, method=6)

                print(f"Copied and converted: {filepath.name}")

        except Exception as e:
            print(f"Skipping {filepath.name}, error: {e}")


@app.command()
def main(
    directory: str = typer.Argument(".", help="Directory to process images"),
    max_width: int = typer.Option(1920, help="Max width of the converted images"),
    max_height: int = typer.Option(1080, help="Max height of the converted images"),
    quality: int = typer.Option(80, help="Quality of the converted images"),
):
    convert_images_to_webp(directory, max_width, max_height, quality)


if __name__ == "__main__":
    app()
