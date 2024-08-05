
VENV_DIR = venv
PYTHON = $(VENV_DIR)/Scripts/python
PIP = $(VENV_DIR)/Scripts/pip
BLACK = $(VENV_DIR)/Scripts/black
FLAKE8 = $(VENV_DIR)/Scripts/flake8


install:
	@echo "====================================================================================="
	@echo "Creating virtual environment..."
	@echo "====================================================================================="
	python -m venv $(VENV_DIR)
	@echo "Installing dependencies..."
	$(PIP) install -r requirements.txt
	$(PIP) install -e .[test,lint]

test:
	@echo "====================================================================================="
	@echo "Running tests..."
	@echo "====================================================================================="
	$(PYTHON) -m unittest discover -s tests

lint:
	@echo "====================================================================================="
	@echo "Linting code..."
	@echo "====================================================================================="
	$(FLAKE8) src/ --count --select=E9,F63,F7,F82 --show-source --statistics
	$(FLAKE8) src/ --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

format:
	@echo "====================================================================================="
	@echo "Formatting code..."
	@echo "====================================================================================="
	$(BLACK) src/

prepare: test lint format

build:
	@echo "====================================================================================="
	@echo "Building wheel file..."
	$(PYTHON) -m build
	@echo "====================================================================================="

all: install prepare build
	@echo "====================================================================================="
	@echo "Installing dependencies, running all checks, and building wheel..."
	@echo "====================================================================================="

.PHONY: install test lint format prepare clean build all
