#!/usr/bin/python3

import os
import sys
import psycopg2
import psycopg2.extras
from dataclasses import dataclass
from jinja2 import FileSystemLoader, Environment

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
class Index:
    config = Config()
    templates = Environment(loader=FileSystemLoader(project_root))
    error_layout = templates.get_template('common/error.jinja2')
    redirect_layout = templates.get_template('common/redirect.jinja2')
    layout = templates.get_template('common/layout.jinja2')

    def get_non_line_incidents(self):
        self.config.connection = psycopg2.connect(self.config.credentials())
        cursor = self.config.connection.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
        sql = """
                select instant, incident.id, description, severity
                from incident
                left outer join line
                on (incident.id = line.id)
                WHERE line.id is null;
                """
        cursor.execute(sql)
        return cursor.fetchall()

    def process(self):
        try:
            non_line_incidents = self.get_non_line_incidents()
            title = 'List of Non Line Incidents'
            template = self.templates.get_template('non_line_incident/index.jinja2')
            print(template.render(title=title, non_line_incidents=non_line_incidents, website_root=self.config.website_root))
        except Exception as error:
            if self.config.connection is not None:
                self.config.connection.rollback()
            print(self.error_layout.render(error=error, website_root=self.config.website_root))
        finally:
            if self.config.connection is not None:
                self.config.connection.close()


Index().process()
