from datetime import datetime
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
    backup_file_name = (
        f"{input_path.stem}-{datetime.now().strftime("%Y-%m-%dT%H-%M-%S")}.db"
    )
    run(
        ["sqlite3", input_path, f"vacuum into '{output_dir}/{backup_file_name}'"],
        encoding="utf8",
        text=True,
    )
