from zapv2 import ZAPv2
import time

target = 'http://localhost:9090/ws/rest/IP'
zapURL= 'http://localhost:8080'
apiKey = 'dr3q1eabg227tu7m9hecknkbu2'

zap = ZAPv2(apikey=apiKey, proxies={'http': zapURL, 'https': zapURL})
print('Spidering target {}'.format(target))
zap.spider.scan(target)
time.sleep(2)  # Give the spider a head start

while int(zap.spider.status()) < 100:
    print('Spider progress %: {}'.format(zap.spider.status()))
    time.sleep(2)

print('Spider completed')
print('Scanning target {}'.format(target))
zap.ascan.scan(target)

while int(zap.ascan.status()) < 100:
    print('Scan progress %: {}'.format(zap.ascan.status()))
    time.sleep(5)

print('Scan completed')
print('Hosts: {}'.format(', '.join(zap.core.hosts)))
print('Number of alerts: {}'.format(len(zap.core.alerts())))
