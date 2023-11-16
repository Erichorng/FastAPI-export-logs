FROM python:3.9 
WORKDIR /export
RUN apt-get update && apt-get install -y zip
COPY ./requirements.txt /export/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /export/requirements.txt
COPY ./app /export/app
COPY ./scripts /export/scripts
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]

