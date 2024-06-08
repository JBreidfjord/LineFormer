FROM continuumio/miniconda3

# Set the default shell to bash so we can activate conda later
SHELL ["/bin/bash", "--login", "-c"]

RUN mkdir /data

RUN apt-get update && apt-get install gcc g++ ffmpeg libsm6 libxext6 python3-pybind11  -y

WORKDIR /LineFormer

RUN conda init bash && . ~/.bashrc
RUN conda create -n LineFormer python=3.8 -y
RUN conda activate LineFormer

RUN conda run -n LineFormer pip install openmim chardet --no-cache-dir
RUN conda run -n LineFormer conda install -y pytorch==1.13.1 torchvision pytorch-cuda=11.7 -c pytorch -c nvidia
RUN conda run -n LineFormer pip install runpod scikit-image matplotlib opencv-python pillow scipy==1.9.3 bresenham tqdm --no-cache-dir
RUN conda run -n LineFormer conda install pybind11 -y
RUN conda run -n LineFormer pip install mmcv-full==1.7.2 -f https://download.openmmlab.com/mmcv/dist/cu117/torch1.13/index.html --no-cache-dir

# RUN conda run -n LineFormer mim install mmdet==2.28.2
COPY mmdetection /LineFormer/mmdetection
RUN conda run -n LineFormer pip install -e mmdetection

# Clean up
RUN conda clean --yes --index-cache --tarballs --tempfiles --logfiles

COPY iter_3000.pth /LineFormer/iter_3000.pth
COPY *.py /LineFormer/
CMD ["conda", "run", "-n", "LineFormer", "python", "server.py"]