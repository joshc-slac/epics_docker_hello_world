# Docker & EPICS Hello World

Josh finds it useful to build this toy example so he can both better understand how things work & to make developing new software easier.

If you see me shirking any existing tooling in favor of creating something from scratch let me know it is good to not reinvent the wheel.

## To run:
You'll need `docker`, `make` is the recomended interface.

- `make build` will build the docker image
- `make run` will run the docker image in interactive mode and clean it up on termination


## TODOs

## Dev Notes:
If docker loses the ability to do DNS on your machine run: `sudo ip link delete docker0 && sudo systemctl restart docker`