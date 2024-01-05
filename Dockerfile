FROM python:3.10.13

# Set pythonpath
ENV PYTHONPATH=/opt/dcp
ENV WORKDIR=/opt/dcp

# install python requirements
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# keep our docker container running
CMD ["tail", "-f", "/dev/null"]