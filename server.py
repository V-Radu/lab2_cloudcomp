import multiprocessing
import socket
import os
from flask import Flask
app = Flask(__name__)



# Tels python which URI to trigger this function
@app.route('/hello')
def hello_world():
	return 'Hello Radu'

@app.route('/status')
def get_status():
	host_name = socket.gethostname()
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	s.connect(("8.8.8.8", 80))
	my_ip = s.getsockname()[0]
	s.close()
	mem_bytes = os.sysconf('SC_PAGE_SIZE') *os.sysconf('SC_PHYS_PAGES')
	my_memory = str(mem_bytes/(1024.**3))
	nr_cpus =str(multiprocessing.cpu_count())
	text = "Host Name: %s <br>PublicIP: %s<br>Number of CPUs: %s<br>Memory: %s Gbs<br>" %(host_name, my_ip, nr_cpus, my_memory)
	return text
