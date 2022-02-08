Alpine with OpenVPN and Privoxy to use your NordVPN account.

Based on jeroenslot/nordvpn-proxy with added killswitch and downloading of specific config files due to rate limiting on the all config download page. Also added bugfix to prevent adding of default local network to privoxy when other local networks have been specified using environment variable.


# Features

- Connects to the recommended server for you! Provided by the API.
- Reconnects if the load is to high on a NordVPN server (Depends on setup CRON).
- Reconnects to random servers if specified
- Healthcheck if the connection is not secure.
- Privoxy to use it elsewhere, for private browsing!
- Connect your other containers, so they have a secured connection as well. A cool Docker feature :)
- It will download the ovpn files daily! So you will stay up-to-date with the latest ovpn files.
- Connect to the country that you select! The API will find the fastest server.

# Prerequisite 

You will need a [NordVPN](https://nordvpn.com) account.

## Environment Variables

- `USERNAME` Username of your account
- `PASSWORD` Password of your account
- `LOCAL_NETWORK` - The CIDR mask of the local IP network(s) (e.g. `192.168.1.0/24` or `10.1.1.0/24` or multiple networks `192.168.1.0/24,10.1.1.0/24,172.16.2.0/24`). This is needed to respond to your client.
- `CRON` You can set this variable to change the default check of every 15 minutes. This will be used to check if the LOAD is still OK. This can be changed using the CRON syntax.
- `LOAD` If the load is > 75 on a NordVPN server, OpenVPN will be restarted and connects to the recommended server for you! This check will be done every 15 minutes by CRON.
- `RANDOM_TOP` *Optional*, if set, it will randomly select from the top "x" number of recommended servers. Valid values are integers between 1 and the number of servers that nord has.
- `COUNTRY` *Optional*, you can choose your own country by using the two-letter country codes that are supported by NordVPN.
- `PROTOCOL` *Optional*, default set to `tcp`, you can change it to `udp`.
- `SERVER` *Optional*, if not set, connects to the recommended server for you. If set, connects to the server you specify. Example server name format: `us2484.nordvpn.com`.
- `REFRESH_TIME` *Optional*, defaults to 120 minutes. Will only re-download the NordVPN OVPN files after the set amount of minutes.

## Start container

```Shell
docker run -d \
--cap-add=NET_ADMIN \
--name=vpn \
--dns=103.86.96.100 \
--dns=103.86.99.100 \
--restart=always \
-e "USERNAME=<nordvpn_username>" \
-e "PASSWORD=<nordvpn_password>" \
-e "LOCAL_NETWORK=192.168.1.0/24" \
-v /etc/localtime:/etc/localtime:ro \
-v ovpn-data:/app/ovpn/config \
-p 8118:8118 \
rooteth/nordvpn-proxy:latest 
```

Now you can connect other containers to use this connection:

For example:
```Shell
docker run -d \
--network="container:vpn" \
imagename 
```

For more info on networking, check the Docker [docs](https://docs.docker.com/engine/reference/run/#network-settings)

## Docker-compose

You can use the `docker-compose.yml` example for you own setup. Change the environment variables!

Start the vpn proxy using:

```Shell
docker-compose up -d
```

For more info on networking, check the Docker [docs](https://docs.docker.com/compose/compose-file/#network_mode)


## Use Privoxy in your browser

To connect to the VPN Proxy, set your browser proxy to `ip.where.docker.runs:8118`.

For Chrome you can use: 
- [Chrome Store](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif)
- [GitHub](https://github.com/FelisCatus/SwitchyOmega)

## Picking a random server
To ensure that a new random server is picked during each iteration of CRON, set the following variables.
Note that the higher you set RANDOM_TOP, the more random the pick will be.
```
LOAD=0
RANDOM_TOP=100
```

## Contribution

Feel free to fork and contribute, or submit an issue.
