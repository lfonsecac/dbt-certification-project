FROM python:3.10.13

# Set pythonpath
ENV PYTHONPATH=/opt/develop
ENV WORKDIR=/opt/develop

# install python requirements
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

WORKDIR /opt/develop

# keep our docker container running
CMD ["tail", "-f", "/dev/null"]