FROM python:3.8.0-slim

RUN apt-get update \
&& apt-get install nano -y \
&& apt-get clean
WORKDIR /app
ADD . /app/
RUN pip install -r requirements.txt

CMD ["python3", "/app/kube-custom-metric-v2.py"]