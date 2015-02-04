#!/usr/bin/env python
"""
generate dash documentation for prototope
"""

import logging
import os
import pprint
import re
import sqlite3
import sys
import yaml


def read_toc():
    with open('_data/api_docs.yml') as f:
        toc = yaml.load(f.read())
        logging.info(pprint.pformat(toc))
    return toc

def update_db(name, entry_type, path):
    update_string = "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?, ?, ?)"
    db.execute(update_string, (name, entry_type, path))


def parse_md(filename):
    with open(filename) as f:
        return yaml.load(f.read().split('---')[1])

def yaml_for_doc(title):
    doc_path = '_docs/%s.md' % title
    doc_yaml = parse_md(doc_path)
    return doc_yaml

def yaml_for_method(method, section_slug):
    method_path = '_methods/%s/%s.md' % (section_slug, method)
    method_yaml = parse_md(method_path)
    return method_yaml


def parse_header(section):
    title = section['title']
    logging.info("would now parse this class: %s" % title)
    header_yaml = yaml_for_doc(title)
    header_type = header_yaml.get('doctype', 'struct')
    header_type = header_type if type(header_type) == str else header_type[0]

    update_db(header_yaml.get('title'), header_type, 'api_docs/%s/index.html#head' % title)

def parse_methods(section):
    section_name = section.get('title')
    section_methods = section.get('docs')
    logging.info("would now parse methods in this class: %s" % section_name)

    if section_methods:
        for doc in section_methods:
            parse_method(doc, section_name)

def parse_method(method_doc, header):
    logging.info("would now parse methods for %s " % method_doc)
    header_yaml = yaml_for_doc(header)
    method_yaml = yaml_for_method(method_doc, header_yaml.get('slug'))

    header_title = header_yaml.get('title')
    method_title = filter_name(method_yaml.get('title')) if method_yaml.get('title') else ""
    if method_title == "" and not method_yaml.get('variables'):
        logging.warning("hmm... no method title for: %s" % method_yaml)
    slug = method_yaml.get('slug')
    doctype = method_yaml.get('doctype')

    if method_yaml.get('variables'):
        default_type = 'Variable' if 'variable' in doctype else 'Function'
        for i, v in enumerate(method_yaml.get('variables'), start=1):
            var_type = v.get('type', default_type)
            var_name = filter_name(v.get('name'))
            update_db(var_name, var_type, 'api_docs/%s/index.html#%s-%s' % (header_title, slug, i))

    elif not doctype and method_yaml.get('layout') == 'section':
        update_db(method_title, 'Section', 'api_docs/%s/index.html#%s' % (header_title, slug))
    elif 'method' in doctype:
        update_db(method_title, 'Method', 'api_docs/%s/index.html#%s' % (header_title, slug))
    elif 'variable' in doctype:
        update_db(method_title, 'Variable', 'api_docs/%s/index.html#%s' % (header_title, slug))
    elif 'typealias' in doctype:
        update_db(method_title, 'Type', 'api_docs/%s/index.html#%s' % (header_title, slug))
    elif 'enum' in doctype:
        update_db(method_title, 'Enum', 'api_docs/%s/index.html#%s' % (header_title, slug))
    else:
        logging.error("%s:  WTFWTF#######$$$$$$$$$$$$$$", slug)

def filter_name(name):
    """takes a string like public func foo() -> """
    name = name.split("->")[0]
    name = re.sub(r'\n', '', name)
    name = re.sub(r'\bpublic\b', '', name)
    name = re.sub(r'\bclass\b', '', name)
    name = re.sub(r'\bstatic\b', '', name)
    name = re.sub(r'\bfunc\b', '', name)
    name = re.sub(r'\bvar\b', '', name)
    name = re.sub(r'\blet\b', '', name)
    name = re.sub(r'\btypealias\b', '', name)
    name = re.sub(r'\benum\b', '', name)
    name = re.sub(r'\bprivate\(\w+\) ', '', name)
    name = re.sub(r'\bconvenience\b', '', name)
    name = re.sub(r'\bweak\b', '', name)
    name = re.sub(r'\s+', '', name)
    name = name.strip()
    return name


def parse_toc(toc, db):

    for section in toc:
        parse_header(section)
        parse_methods(section)

if __name__ == '__main__':
    logging.basicConfig(level=logging.WARNING)

    db_handle = sqlite3.connect('dash/prototope.docset/Contents/Resources/docSet.dsidx')
    global db
    db = db_handle.cursor()

    try: db.execute('DROP TABLE searchIndex;')
    except: pass
    db.execute('CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);')
    db.execute('CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);')

    toc = read_toc()
    parse_toc(toc, db)

    db_handle.commit()
    db_handle.close()
