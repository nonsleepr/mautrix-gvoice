# mautrix-gvoice
A Matrix-Google Voice puppeting bridge.

## Documentation
All setup and usage instructions are located on [docs.mau.fi]. Some quick links:

[docs.mau.fi]: https://docs.mau.fi/bridges/go/gvoice/index.html

* [Bridge setup](https://docs.mau.fi/bridges/go/setup.html?bridge=gvoice)
  (or [with Docker](https://docs.mau.fi/bridges/general/docker-setup.html?bridge=gvoice))
* Basic usage: [Authentication](https://docs.mau.fi/bridges/go/gvoice/authentication.html)

## Docker Setup

### Building the Container

Build the optimized Ubuntu-based container:

```bash
docker build -f Dockerfile.ubuntu -t mautrix-gvoice:ubuntu .
```

The container includes:
- Headless Electron support with Xvfb virtual display
- Configurable user permissions via PUID/PGID
- Optimized build layers to avoid rebuilds when scripts change

### Quick Start with Beeper

If you're using [Beeper](https://www.beeper.com/), you can use `bbctl` (Beeper's bridge control tool) for easy setup:

```bash
# 1. Initialize the bridge in Beeper
bbctl run sh-gvoice

# 2. Export the configuration
bbctl config sh-gvoice > data/config.yaml

# 3. Run the bridge
docker run --rm -v $(pwd)/data:/data -e PUID=1000 -e PGID=1000 mautrix-gvoice:ubuntu
```

The bridge will automatically generate the registration file and connect to your Beeper homeserver.

### Manual Setup (Non-Beeper)

For standard Matrix homeservers:

```bash
# 1. Create data directory
mkdir -p data

# 2. Generate initial config
docker run --rm -v $(pwd)/data:/data mautrix-gvoice:ubuntu

# 3. Edit data/config.yaml with your homeserver details
# 4. Generate registration file
docker run --rm -v $(pwd)/data:/data mautrix-gvoice:ubuntu

# 5. Register the bridge with your homeserver (see registration.yaml)
# 6. Run the bridge
docker run -d --name mautrix-gvoice \
  -v $(pwd)/data:/data \
  -e PUID=1000 -e PGID=1000 \
  mautrix-gvoice:ubuntu
```

### Configuration Options

#### Environment Variables

- `PUID` - User ID for file permissions (default: 1000)
- `PGID` - Group ID for file permissions (default: 1000)
- `DISPLAY` - X11 display (automatically set to :99 for headless mode)

#### Volume Mounts

- `/data` - Bridge configuration, database, and logs

#### Example with Custom User

```bash
# Run as user 1001:1001
docker run --rm \
  -v $(pwd)/data:/data \
  -e PUID=1001 -e PGID=1001 \
  mautrix-gvoice:ubuntu
```

### Troubleshooting

#### Permission Issues
The container automatically handles user/group setup. If you encounter permission errors:
- Ensure the data directory is writable by your user
- Check PUID/PGID match your host user: `id -u` and `id -g`

#### Authentication Errors
- For Beeper: Ensure `bbctl run sh-gvoice` completed successfully
- For manual setup: Verify the registration file is installed in your homeserver
- Check the `as_token` in your configuration matches the registration

#### Electron/Display Issues
The container runs in headless mode with Xvfb. If you need to debug:
```bash
# Run with interactive shell
docker run -it --rm -v $(pwd)/data:/data mautrix-gvoice:ubuntu bash
```

### Features & Roadmap
[ROADMAP.md](ROADMAP.md) contains a general overview of what is supported by the bridge.

## Discussion
Matrix room: [#gvoice:maunium.net](https://matrix.to/#/#gvoice:maunium.net)
