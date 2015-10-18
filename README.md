# rpidockers/logstash
## Tags
[1.5.4](https://github.com/rpidockers/logstash/blob/1.5.4/Dockerfile)

[latest](https://github.com/rpidockers/logstash/blob/master/Dockerfile)

## How to use this image
Start Logstash with commandline configuration

If you need to run logstash with configuration provided on the commandline, you can use the logstash image as follows:
```
$ docker run -it --rm logstash rpidockers/logstash -e 'input { stdin { } } output { stdout { } }'
```
Start Logstash with configuration directory

If you need to run logstash with a configuration files stored in <local_dir>, you can use the logstash image as follows:
```
$ docker run -d -v <local_dir>:/config-dir rpidockers/logstash logstash -f /config-dir
```
