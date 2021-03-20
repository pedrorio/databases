#!/usr/bin/python3

import os
import sys
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
class New:
    config = Config()
    templates = Environment(loader=FileSystemLoader(project_root))
    error_layout = templates.get_template('common/error.jinja2')
    message_layout = templates.get_template('common/message.jinja2')
    redirect_layout = templates.get_template('common/redirect.jinja2')
    layout = templates.get_template('common/layout.jinja2')

    def process(self):
        try:
            title = 'Add a new Non Line Incident'
            template = self.templates.get_template('non_line_incident/new.jinja2')
            print(template.render(title=title, website_root=self.config.website_root))
        except Exception as error:
            print(self.error_layout.render(error=error, website_root=self.config.website_root))


New().process()
