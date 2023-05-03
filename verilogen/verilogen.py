import click

from random import randint
from jinja2 import Template


@click.command()
@click.option(
    "--output",
    "-o",
    type=click.File("w"),
    default="out.v",
    help="Path to the generated output verilog file",
)
@click.option("--data", "-d", multiple=True, nargs=2, type=click.Tuple([str, int]))
@click.argument("template", type=click.File("r"))
def generate(output, template, data):
    data = {key: value for key, value in data}
    template = Template(template.read())
    add_filters(template)
    generated_code = template.render(data)
    output.write(generated_code)


def add_filters(template):
    template.environment.filters["randint"] = randint
