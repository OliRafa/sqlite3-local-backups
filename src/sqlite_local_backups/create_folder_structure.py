from pathlib import Path

import click


@click.command()
@click.argument(
    "path",
    type=click.Path(
        exists=True, file_okay=False, writable=True, resolve_path=True, path_type=Path
    ),
)
def create_folder_structure(path: Path):
    """Create folder structure for backups retention policy."""

    if not path.joinpath("last").exists():
        path.joinpath("last").mkdir()

    if not path.joinpath("daily").exists():
        path.joinpath("daily").mkdir()

    if not path.joinpath("weekly").exists():
        path.joinpath("weekly").mkdir()

    if not path.joinpath("monthly").exists():
        path.joinpath("monthly").mkdir()
