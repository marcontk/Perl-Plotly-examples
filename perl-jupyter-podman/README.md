# Perl in Jupyter (IPerl) with Podman

Minimal container to run **JupyterLab** with the **Perl (IPerl)** kernel.

## Build
```bash
podman build -t perl-jupyter .   # or: docker build -t perl-jupyter -f Containerfile .
```

## Run
```bash
podman run --rm -p 8888:8888 -v "$PWD:/work" perl-jupyter
# open http://localhost:8888  (no token)
# New Notebook -> Perl
```

## Optional extras
To have `Chart::Plotly`, `PDL`, or `Imager` available in the container,
uncomment the line in the Containerfile:
```Dockerfile
# RUN cpanm Chart::Plotly PDL Imager
```

## Local install (no container)
Ubuntu/Debian:
```bash
sudo apt update
sudo apt install -y perl build-essential cpanminus libzmq3-dev python3-pip
pip3 install jupyterlab
cpanm --notest Devel::IPerl
iperl lab   # or: iperl notebook
```
