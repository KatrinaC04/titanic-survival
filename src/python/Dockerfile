# Use python 3.12
FROM python:3.12-slim

WORKDIR /app

# copy requirements.txt to the Docker
COPY src/python/requirements.txt ./requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

# copy python script to the Docker
COPY src/python/titanic_model.py ./titanic_model.py

CMD ["python", "titanic_model.py"]
