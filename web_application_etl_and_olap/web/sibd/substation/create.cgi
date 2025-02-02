#!/usr/bin/python3

import os
import sys
import psycopg2
import psycopg2.extras
from dataclasses import dataclass
from jinja2 import FileSystemLoader, Environment
import cgi

project_root = os.path.expanduser('~/web/sibd')
sys.path.insert(0, project_root)


@dataclass
class Config:
    host = 'db.tecnico.ulisboa.pt'
    port = '5432'
    username = "XXXXXXXXXXX"
    password = "XXXXXXXXXXX"
    database = "XXXXXXXXXXX"

    connection = None
    website_root = 'https://web2.tecnico.ulisboa.pt/ist197241/sibd'

    def credentials(self):
        return f'host={self.host} port={self.port} user={self.username} password={self.password} dbname={self.database}'


@dataclass
class Create:
    config = Config()
    templates = Environment(loader=FileSystemLoader(project_root))
    error_layout = templates.get_template('common/error.jinja2')
    message_layout = templates.get_template('common/message.jinja2')
    redirect_layout = templates.get_template('common/redirect.jinja2')
    layout = templates.get_template('common/layout.jinja2')

    def get_parameters(self):
        form = cgi.FieldStorage()
        return {
            'gpslat': form.getvalue('gpslat'),
            'gpslong': form.getvalue('gpslong'),
            'locality': form.getvalue('locality'),
            'sname': form.getvalue('sname'),
            'saddress': form.getvalue('saddress')
        }

    def create_substation(self, data):
        self.config.connection = psycopg2.connect(self.config.credentials())
        self.config.connection.autocommit = False
        cursor = self.config.connection.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)

        sql_create_substation = """
                insert into 
                    substation (gpslat, gpslong, locality, sname, saddress) 
                values 
                    (%(gpslat)s, %(gpslong)s, %(locality)s, %(sname)s, %(saddress)s);
                """
        cursor.execute(sql_create_substation, data)

        self.config.connection.commit()

    def process(self):
        try:
            data = self.get_parameters()
            self.create_substation(data)
            url = f'{self.config.website_root}/substation/index.cgi'
            print(self.redirect_layout.render(url=url))
        except Exception as error:
            if self.config.connection is not None:
                self.config.connection.rollback()
            print(self.error_layout.render(error=error, website_root=self.config.website_root))
        finally:
            if self.config.connection is not None:
                self.config.connection.close()


Create().process()
