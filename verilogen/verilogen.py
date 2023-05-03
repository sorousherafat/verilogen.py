import sys
import click

from random import randint
from jinja2 import Environment, FileSystemLoader


environment = Environment(loader=FileSystemLoader("./"))


@click.command()
@click.option(
    "--output",
    type=click.File("w"),
    default="out.v",
    help="Path to the generated output verilog file",
)
@click.argument("template", type=click.File("r"))
def generate(output, template):
    print(output, template)
