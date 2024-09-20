from datetime import datetime
from pathlib import Path
from subprocess import run

import click


def _create_hard_link(file_path: Path, hardlink_path: Path) -> None:
    try:
        hardlink_path.hardlink_to(file_path)
    except FileExistsError:
        hardlink_path.unlink()
        hardlink_path.hardlink_to(file_path)


@click.command()
@click.argument("input_path", type=click.Path(exists=True, path_type=Path))
@click.argument(
    "output_dir",
    type=click.Path(exists=True, file_okay=False, resolve_path=True, path_type=Path),
)
def create_backup(input_path: Path, output_dir: Path):
    """Create a backup for a given database path."""
    last_dir = output_dir.joinpath("last")
    daily_dir = output_dir.joinpath("daily")
    weekly_dir = output_dir.joinpath("weekly")
    monthly_dir = output_dir.joinpath("monthly")

    backup_time = datetime.now()

    last_file_name = f"{input_path.stem}-{backup_time.strftime("%Y-%m-%dT%H-%M-%S")}.db"
    daily_file_name = f"{input_path.stem}-{backup_time.strftime("%Y-%m-%d")}.db"
    weekly_file_name = f"{input_path.stem}-{backup_time.strftime("%G-%V")}.db"
    monthly_file_name = f"{input_path.stem}-{backup_time.strftime("%Y-%m")}.db"

    last_file_path = last_dir.joinpath(last_file_name)
    daily_file_path = daily_dir.joinpath(daily_file_name)
    weekly_file_path = weekly_dir.joinpath(weekly_file_name)
    monthly_file_path = monthly_dir.joinpath(monthly_file_name)

    click.echo(f"Creating backup of {input_path.name}...")
    run(
        ["sqlite3", input_path, f"vacuum into '{last_file_path}'"],
        encoding="utf8",
        text=True,
    )

    click.echo(f"Replacing daily backup {daily_file_path} file this last backup...")
    _create_hard_link(last_file_path, daily_file_path)

    click.echo(f"Replacing weekly backup {weekly_file_path} file this last backup...")
    _create_hard_link(last_file_path, weekly_file_path)

    click.echo(f"Replacing monthly backup {monthly_file_path} file this last backup...")
    _create_hard_link(last_file_path, monthly_file_path)
