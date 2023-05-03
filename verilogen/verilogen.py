import sys
import click

from random import randint
from jinja2 import Environment, FileSystemLoader


environment = Environment(loader=FileSystemLoader("./"))


@click.command()
@click.option(
    "--output",
    "-o",
    type=click.File("w"),
    default="out.v",
    help="Path to the generated output verilog file",
)
@click.option(
    "--data",
    "-d",
    multiple=True,
    nargs=2,
    type=click.Tuple([str, str])
)
@click.argument("template", type=click.File("r"))
def generate(output, template, data):
    data = {key: value for key, value in data}
    print(output, template, data)
