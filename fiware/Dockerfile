FROM python:3.8

RUN pip install flask

COPY subscriber.py /root
WORKDIR /root
RUN chmod a+x subscriber.py

EXPOSE 5000

ENTRYPOINT ["python", "-m", "subscriber"]