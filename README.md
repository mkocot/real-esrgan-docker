# REAL-ESRGAN in docker (for potato powered PC without CUDA)
## info
Build Real-ESRGAN using https://github.com/xinntao/Real-ESRGAN

Image deployed on hub.docker.com: https://hub.docker.com/repository/docker/kociolek/real-esrgan

![Deployment status](https://github.com/mkocot/real-esrgan-docker/actions/workflows/docker-image.yml/badge.svg)

## TL;DR
Create 2 directories: for input (eg. `input`) and output (eg. `output`)
```shell
docker run --rm -v ./input:/app/input -v ./output:/app/output docker.io/kociolek/real-esrgan
```
