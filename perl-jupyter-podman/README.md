# Perl in Jupyter (IPerl) with Podman

Minimal container to run **JupyterLab** with the **Perl (IPerl)** kernel.

## Build
```bash
podman build -t perl-jupyter .   # or: docker build -t perl-jupyter -f Containerfile .
```
## run.sh
This project includes a helper script [`run.sh`](./run.sh)  
which builds (if needed) and launches JupyterLab automatically.

```bash
# Default: build and open on port 8888
./run.sh

# Optional environment variables:
export DO_BUILD=0        # skip rebuild if image already exists
export PORT_LOCAL=8890   # change host port
export ENGINE=podman     # force Podman instead of Docker
./run.sh


## Run
```bash
podman run --rm -p 8888:8888 -v "$PWD:/work" perl-jupyter
# open http://localhost:8888  (no token)
# New Notebook -> Perl
```

