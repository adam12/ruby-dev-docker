# Ruby development container for Docker

A thick container for the development of Ruby applications. Includes common
dependencies (Postgres client, etc) as well as the Ruby documentation.

## Rationale

Using the offical Ruby images as a base is all well and good, but then for
every project I need to add on postgres (maybe), node (maybe), and other bits.

But using the container for development is somewhat awkward, as there is no
Ruby documentation installed. 

## Benefits

Easily install all necessary tooling with a 2-4 line Dockerfile. Non-root user
pre-created with a UID that translates through to the host reasonably well.

## Drawbacks

Some dependencies are compiled from source. This can be somewhat time consuming
during the first build.

Each build might be different; developers across teams _might_ end up with
differing builds.

## Usage

See `Dockerfile.example` for how this might be used inside your project.

## Building

Just to build:

		docker buildx bake

Build and push to hub.docker.io

		docker buildx bake --push

## License

MIT
