"""
Command to wait for the database to be available

"""
from psycopg2 import OperationalError as Psycopg2Error
from django.core.management.base import BaseCommand
from django.db.utils import OperationalError
import time
# from django.db import connections


class Command(BaseCommand):
    """Django command to wait for database"""

    def handle(self, *args, **options):
        self.stdout.write('Waiting for database...')

        db_up = False
        while db_up is False:
            try:
                self.check(databases=['default'])
                db_up = True
            except (Psycopg2Error, OperationalError):
                self.stdout.write('Database unavailiable wait for 1 sec')
                time.sleep(1)
        self.stdout.write(self.style.SUCCESS('Database availiable'))
