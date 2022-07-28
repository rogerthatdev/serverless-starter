from event_handler import __version__
from event_handler import main

def test_version():
    assert __version__ == '0.1.0'

def test_main():
    assert main.test() == True