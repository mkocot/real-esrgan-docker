FROM docker.io/python:3.8 AS BUILD
WORKDIR /build
#RUN apt-get update && apt-get install -y --no-install-recommends \
#	git

RUN git clone --depth=1 https://github.com/xinntao/Real-ESRGAN.git
#COPY . /build/
ENV VIRTUAL_ENV=/build/venv
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
RUN python -m venv ${VIRTUAL_ENV}

#RUN pip3 install -r Real-ESRGAN/requirements.txt
WORKDIR /build/Real-ESRGAN
RUN sed -i 's/opencv-python/&-headless/' requirements.txt
RUN wget --no-verbose https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth -P experiments/pretrained_models
RUN wget --no-verbose https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.3/RealESRGAN_x4plus_netD.pth -P experiments/pretrained_models
RUN wget --no-verbose https://github.com/xinntao/facexlib/releases/download/v0.1.0/detection_Resnet50_Final.pth -P experiments/pretrained_models
RUN pip install -r requirements.txt
RUN python setup.py install
RUN yes | pip uninstall opencv-python
RUN pip install --force-reinstall opencv-python-headless
#RUN cp -a inference_realesrgan.py .. && \
#	inference_realesrgan_video.py ..


FROM docker.io/python:3.8-slim AS APP
WORKDIR /app

ENV VIRTUAL_ENV=/build/venv
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

COPY --from=BUILD /build/venv /build/venv
COPY --from=BUILD /build/Real-ESRGAN/inference*.py /app/
COPY --from=BUILD /build/Real-ESRGAN/experiments/pretrained_models /app/experiments/pretrained_models

ENTRYPOINT ["python", "inference_realesrgan.py", "--fp32", "-i", "input", "-o", "output"]
