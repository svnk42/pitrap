FROM svnk/rpi-raspbian-base
MAINTAINER Sven Krewitt <svnk@krewitt.org>

# install / update required packages
RUN apt-get update && apt-get install -y python python-dpkt python-pypcap python-pip rsyslog rsyslog-gnutls arpwatch
RUN apt-get clean
RUN pip install -U setuptools

# install pyscanlogd
RUN mkdir -p /opt/pyscanlog
ADD ./pyscanlogd-0.5.1.tar.gz /opt/pyscanlog
RUN cd /opt/pyscanlog/pyscanlogd-0.5.1/ && python ./setup.py install

# configure arpwatch
COPY ./conf/arpwatch /etc/default/

# configure rsyslogd
COPY ./conf/rsyslog.conf /etc/rsyslog.conf
COPY ./conf/80-papertrail.conf /etc/rsyslog.d/
COPY ./papertrail-bundle.pem /etc/rsyslog.d/

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["pyscanlogd"]
