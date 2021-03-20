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
            'instant': form.getvalue('instant'),
            'id': form.getvalue('id'),
            'description': form.getvalue('description'),
            'severity': form.getvalue('severity')
        }

    def is_line(self, data, cursor):
        sql_element_is_line = """
                        select exists (
                        select id
                        from line
                        where id = %(id)s
                           );
        """
        cursor.execute(sql_element_is_line, data)
        return cursor.fetchone().exists

    def create_incident(self, data, cursor):
        sql_create_incident = """
                                insert into 
                                    incident (instant, id, description, severity) 
                                values 
                                    (%(instant)s, %(id)s, %(description)s, %(severity)s);
                                """
        cursor.execute(sql_create_incident, data)

    def create_non_line_incident(self, data):
        self.config.connection = psycopg2.connect(self.config.credentials())
        self.config.connection.autocommit = False
        cursor = self.config.connection.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
        if self.is_line(data, cursor):
            error = f'Element must not be a line'
            print(self.error_layout.render(error=error, website_root=self.config.website_root))
        else:
            self.create_incident(data, cursor)
            self.config.connection.commit()
            url = f'{self.config.website_root}/non_line_incident/index.cgi'
            print(self.redirect_layout.render(url=url))

    def process(self):
        try:
            data = self.get_parameters()
            self.create_non_line_incident(data)
        except Exception as error:
            if self.config.connection is not None:
                self.config.connection.rollback()
            print(self.error_layout.render(error=error, website_root=self.config.website_root))
        finally:
            if self.config.connection is not None:
                self.config.connection.close()


Create().process()
