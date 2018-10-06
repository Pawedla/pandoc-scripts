#!/bin/bash
# Einrichten einer Python Umgebung innerhalb des containers

python3.6 -m venv venv

# Aktivieren der Python Umgebung
source venv/bin/activate

# Installation der Requirements
# Hier können Python Pakete eingetragen werden die für Pandoc Filter benötigt werden
pip install -r .pandoc/requirements.txt

bin/clean-all.sh

source bin/base.env

if [[ -e ".env" ]] ; then
source settings.env
fi

# Erstellen von Büchern (siehe README.md)
if [[ ${CREATE_AUTOMATIC_BOOKS} = true ]] ; then
find . -maxdepth ${SEARCH_DEPTH} -name 'book*.sh' -print0 | xargs -0 -I{} -n1 -P${THREADS} /bin/bash -c './bin/make-files.sh --html --source "{}" --outdir '$1
fi

if [[ ${CREATE_MANUAL_BOOKS} = true ]] ; then
find . -maxdepth ${SEARCH_DEPTH} -name 'book*.txt' -print0 | xargs -0 -I{} -n1 -P12 /bin/bash -c './bin/make-files.sh --html --source "{}" --outdir '$1
fi

# Erstellen von PDFs pro Ordner
if [[ ${CREATE_SINGLE_PAGES} = true ]] ; then
find . -maxdepth ${SEARCH_DEPTH} -type f -name "${MARKDOWN_FILENAME}${MARKDOWN_EXTENSION}" -print0 | xargs -0 -I{} -n1 -P12 /bin/bash -c './bin/make-files.sh --html --source "{}" --outdir '$1
fi

