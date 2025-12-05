FROM python:3.14-slim

RUN pip install --no-cache-dir -I snmpsim

# The emulator needs to be run as a non-root user. The snmpsim variation
# modules (like writecache) are installed off the search path, so copy them
# to where they can be found. It seems like snmpsim gets installed with some
# basic MIBs as well - these are removed from the image since their existence
# appears to interfere with the proper loading and usage of the .snmpwalk files
# that we define for the emulator.
RUN groupadd -r snmp && useradd -m -g snmp snmp \
 && chown -R snmp:snmp /home/snmp

COPY ./start_snmp_emulator.sh /home/snmp/start_snmp_emulator.sh

WORKDIR /home/snmp
USER snmp

EXPOSE 1024/udp

ENTRYPOINT ["./start_snmp_emulator.sh"]
