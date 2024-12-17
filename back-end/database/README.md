# Database

The main goals of incorporating a database to the ILE deployment are the following:

- Store the timeseries dataset generated by all the nodes of the emulator.
- Store other kind of data (for example te one generated by the script *service_check.hs* for visualization purposes).
- Store the configuration information instead of delegate it into files inside the containers. Note: This has to be evaluated because relying this information on a centralized DB would break the concept of decentralized orchestration. Evaluate the posibility of using a decentralized database to have on node in each container. Anyway, for the purpose of a PoC it's a valid approach.

## TimescaleBD

The database used to achieve this is TimescaleDB, as it's suitable for managing timeseries data. As it's based on PostgreSQL, it's also a good option for managing concurrent access to a certain table. The deployment is made using docker:

```bash
docker run -d --name ile-database -p 5432:5432 --env-file .env-test timescale/timescaledb-ha:pg16
```

### Database interaction

For interacting with the database from an Ubuntu shell script the following packages must be installed

1- postgresql-client-common

```bash
sudo apt-get install postgresql-client-common -y
```

2- postgresql-client-<version>

```bash
sudo apt install postgresql-client-14 -y
```

### Backup

Backup all created databases from your running container in a gz file:

```bash
docker exec -t ile-database pg_dumpall -c -U admin | gzip > dump_id9withgt_`date +%Y-%m-%d"_"%H_%M_%S`.sql.gz
```

Restore databases from backup:

```bash
cat <dump_file.sql> | docker exec -i ile-database psql -U admin -d ile
```

## Service Check

This is a basic script for checking periodically if a service is up and running. It dumps the information in the TimescaleDB database and it's gathered by a Grafana deployment in order to represent it in a custom dashboard.

### Grafana

To deploy the Grafana instance through a docker container execute the following command:

```bash
docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

Finally, execute the python script to start the service availability check:

```bash
python3 service_check.py
```