FROM python:3.7

WORKDIR /usr/src/app
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install python3.7-dev nginx vim -y

COPY requirements.txt .
RUN pip install -r requirements.txt && rm requirements.txt

COPY . csuf/

EXPOSE 80
CMD ["sh", "/usr/src/app/csuf/run.sh"]