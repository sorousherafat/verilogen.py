import sys
import click

from random import randint
from jinja2 import Environment, FileSystemLoader

@click.command()
def generate():
    print("let's generate some verilog code")
