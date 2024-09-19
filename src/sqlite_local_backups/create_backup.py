from pathlib import Path
from subprocess import run

import click


@click.command()
@click.argument("input_path", type=click.Path(exists=True, path_type=Path))
@click.argument(
    "output_dir", type=click.Path(exists=True, file_okay=False, path_type=Path)
)
def create_backup(input_path: Path, output_dir: Path):
    """Create a backup for a given database path."""
    run(
        ["sqlite3", input_path, f"vacuum into '{output_dir}/hue.db'"],
        encoding="utf8",
        text=True,
    )
