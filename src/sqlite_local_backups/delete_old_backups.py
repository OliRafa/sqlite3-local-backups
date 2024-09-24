from datetime import datetime, timedelta
from os import stat
from pathlib import Path

import click
from dateutil.relativedelta import relativedelta


def _convert_timestamp(timestamp: float) -> datetime:
    return datetime.fromtimestamp(timestamp)


def _delete_old_files(
    folder: Path, current_timestamp: datetime, timedelta: timedelta
) -> None:
    cutoff_timestamp = current_timestamp - timedelta

    files = folder.glob("*.db")
    files_metadata = map(
        lambda x: {"path": x, "created_at": _convert_timestamp(stat(x).st_mtime)}, files
    )

    files_to_remove = list(
        filter(lambda x: x["created_at"] < cutoff_timestamp, files_metadata)
    )

    for file in files_to_remove:
        file["path"].unlink()


@click.command()
@click.argument(
    "backups_folder_path",
    type=click.Path(exists=True, file_okay=False, resolve_path=True, path_type=Path),
)
@click.argument("keep_minutes", type=int, required=True)
@click.argument("keep_days", type=int, required=True)
@click.argument("keep_weeks", type=int, required=True)
@click.argument("keep_months", type=int, required=True)
def delete_old_backups(
    backups_folder_path: Path,
    keep_minutes: int,
    keep_days: int,
    keep_weeks: int,
    keep_months: int,
):
    """Create a backup for a given database path."""
    last_dir = backups_folder_path.joinpath("last")
    daily_dir = backups_folder_path.joinpath("daily")
    weekly_dir = backups_folder_path.joinpath("weekly")
    monthly_dir = backups_folder_path.joinpath("monthly")

    current_timestamp = datetime.now()

    click.echo("Cleaning older files...")
    _delete_old_files(last_dir, current_timestamp, relativedelta(minutes=keep_minutes))
    _delete_old_files(daily_dir, current_timestamp, relativedelta(days=keep_days))
    _delete_old_files(weekly_dir, current_timestamp, relativedelta(weeks=keep_weeks))
    _delete_old_files(monthly_dir, current_timestamp, relativedelta(month=keep_months))
