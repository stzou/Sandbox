FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY view.py ./view.py
COPY templates/index.html ./templates/index.html

CMD ["ddtrace-run", "python", "view.py"]