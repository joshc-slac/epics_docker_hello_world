# Docker & EPICS Hello World

Josh finds it useful to build this toy example so he can both better understand how things work & to make developing new software easier.

If you see me shirking any existing tooling in favor of creating something from scratch let me know it is good to not reinvent the wheel.

## To run:
You'll need `docker`, `make` is the recomended interface.

- `make build` will build the docker image
- `make run` will run the docker image in interactive mode and clean it up on termination


## TODOs
- make more reflective of our actual stack.
  - how do we source something like caget?
  - should i just bring dot files in.... makes me not stoked
- add convinient ways to test shell scripts (get them loaded into the docker image)
