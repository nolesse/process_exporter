set GOOS=linux
set GOARCH=amd64

set name=process_exporter

cd ./process-exporter
go build -o %name%
cd ..
set /p a=<config.ini
@echo read config get %a%
set /a aa=%a% +1
>config.ini echo %aa%

cd ..

set tag=%name%:v%aa%
docker build -t %tag% -f Dockerfile .
docker run -d --name process_exporter -p 9256:9256 -p 2345:2345 %tag%
cd ./cmd
tar -czvf "process_exporter.tar.gz" ../config.yml ./process-exporter/process_exporter install.sh