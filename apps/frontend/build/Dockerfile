FROM python:alpine3.7
RUN mkdir -p /app/templates
COPY frontend.py /app
COPY requirements.txt /app
COPY index.html /app/templates
WORKDIR /app
RUN pip install -r requirements.txt
CMD python ./frontend.py
