# docker-devpi

A pair of containers for running a devpi server

The container images on docker hub are
[thomasf/devpi](https://hub.docker.com/repository/docker/thomasf/devpi/tags)
and
[thomasf/devpi-web](https://hub.docker.com/repository/docker/thomasf/devpi-web/tags)

Both container images will be released together so every tag will exist for both images.

The tags will primarily match with
[devpi-server](https://pypi.org/project/devpi-server/) versions, an hyphenated
version suffix might be added for interim releases that updates any other
depdencies (5.3.1-1).

Never use :latest in production!

# enviromnent variable options

default values and explanation

## devpi


**DEBUG=0**

Set this to anything but 0 and the container start up will dump a more detailed
log of the start up procedure and start the wsgi server in debug mode.

**BASIC_AUTH_USERS_PASSWD** and **BASIC_AUTH_CI_PASSWD**

On the first start up where the devpi server data is created the
file `/devpi/auth/passwd` will be created.

This files is optinally used by the web container when **WEB_AUTH=1** is set
and `/devpi/auth` is mounted in a shared location between the containers.

It enables basic authentication to create a global read only access to the
whole devpi installation.

This enables the use of index urls in the format of
https://users:iDAMePSC@devpi.example.com/root/prod/+simple/ to be used as an
index for pip/pipenv/... if you just want a simple way to control read only
access to the whole server.

Two basic auth users are created **users** and **ci**

If **BASIC_AUTH_USERS_PASSWD** or **BASIC_AUTH_CI_PASSWD** are not set
passwords will be generated and written to the container stdout on the initial
start up when the server data is created.

**DEVPISERVER_ROOT_PASSWD**

The password for the devpi root user, if it's not set it will be generated and
written to the container stdout on the initial start up when the server data is
created.

**DEVPISERVER_.....**

All other environment variables will be passed to devpi server.

The command line option name needs to be changed to uppercase, prefixed with
DEVPISERVER_ and dashes replaced by underscores. For example --restrict-modify
becomes DEVPISERVER_RESTRICT_MODIFY.

At the time of writing this is all of the devpi-server options (will probably
not be kept up to date),

```
optional arguments:
  -h, --help            Show this help message and exit.
  -c CONFIGFILE, --configfile CONFIGFILE
                        Config file to use. [None]
  --role {master,replica,standalone,auto}
                        set role of this instance. The default 'auto' sets 'standalone' by default and 'replica' if the --master-url option is used. To
                        enable the replication protocol you have to explicitly set the 'master' role. [auto]
  --version             show devpi_version (5.3.1) [False]
  --passwd USER         (DEPRECATED, use devpi-passwd command) set password for user USER (interactive) [None]

logging options:
  --debug               run wsgi application with debug logging [False]
  --logger-cfg LOGGER_CFG
                        path to .json or .yaml logger configuration file. [None]

web serving options:
  --host HOST           domain/ip address to listen on. Use --host=0.0.0.0 if you want to accept connections from anywhere. [0.0.0.0]
  --port PORT           port to listen for http requests. [3141]
  --unix-socket UNIX_SOCKET
                        path to unix socket to bind to. [None]
  --unix-socket-perms UNIX_SOCKET_PERMS
                        permissions for the unix socket if used, defaults to '600'. [None]
  --threads THREADS     number of threads to start for serving clients. [50]
  --max-request-body-size MAX_REQUEST_BODY_SIZE
                        maximum number of bytes in request body. This controls the max size of package that can be uploaded. [1073741824]
  --outside-url URL     the outside URL where this server will be reachable. Set this if you proxy devpi-server through a web server and the web server does
                        not set or you want to override the custom X-outside-url header. [None]
  --absolute-urls       use absolute URLs everywhere. This will become the default at some point. [False]
  --profile-requests NUM
                        profile NUM requests and print out cumulative stats. After print profiling is restarted. By default no profiling is performed. [0]

mirroring options:
  --mirror-cache-expiry SECS
                        (experimental) time after which projects in mirror indexes are checked for new releases. [1800]

replica options:
  --master-url MASTER_URL
                        run as a replica of the specified master server [None]
  --replica-max-retries NUM
                        Number of retry attempts for replica connection failures (such as aborted connections to pypi). [0]
  --replica-file-search-path PATH
                        path to existing files to try before downloading from master. These could be from a previous replication attempt or downloaded
                        separately. Expects the structure from inside +files. [None]
  --hard-links          use hard links during export, import or with --replica-file-search-path instead of copying or downloading files. All limitations for
                        hard links on your OS apply. USE AT YOUR OWN RISK [False]
  --replica-cert pem_file
                        when running as a replica, use the given .pem file as the SSL client certificate to authenticate to the server (EXPERIMENTAL) [None]
  --proxy-timeout NUM   Number of seconds to wait before proxied requests from the replica to the master time out (login, uploads etc). [30]

request options:
  --request-timeout NUM
                        Number of seconds before request being terminated (such as connections to pypi, etc.). [5]
  --offline-mode        (experimental) prevents connections to any upstream server (e.g. pypi) and only serves locally cached files through the simple index
                        used by pip. [False]

storage options:
  --serverdir DIR       directory for server data. [/devpi/serverdir]
  --storage NAME        the storage backend to use. "sqlite": SQLite backend with files on the filesystem, "sqlite_db_files": SQLite backend with files in
                        DB for testing only [None]
  --keyfs-cache-size NUM
                        size of keyfs cache. If your devpi-server installation gets a lot of writes, then increasing this might improve performance. Each
                        entry uses 1kb of memory on average. So by default about 10MB are used. [10000]

initialization options:
  --init                (DEPRECATED, use devpi-init command) initialize devpi-server state in an empty directory (also see --serverdir) [False]
  --no-root-pypi        don't create root/pypi on server initialization. [False]
  --root-passwd ROOT_PASSWD
                        initial password for the root user. This option has no effect if the user 'root' already exist. []
  --root-passwd-hash ROOT_PASSWD_HASH
                        initial password hash for the root user. This option has no effect if the user 'root' already exist. [None]

serverstate import options:
  --import PATH         (DEPRECATED, use devpi-import command) import devpi-server database from PATH where PATH is a directory which was created by a
                        'devpi-server --export PATH' operation, using the same or an earlier devpi-server version. Note that you can only import into a
                        fresh server state directory (positional argument to devpi-server). [None]
  --skip-import-type TYPE
                        skip the given index type during import. Used when the corresponding plugin isn't installed anymore. [None]
  --no-events           no events will be run during import, instead they arepostponed to run on server start. This allows much faster start of the server
                        after import, when devpi-web is used. When you start the server after the import, the search index and documentation will gradually
                        update until the server has caught up with all events. [False]

serverstate export options:
  --export PATH         (DEPRECATED, use devpi-passwd command) export devpi-server database state into PATH. This will export all users, indices, release
                        files (except for mirrors), test results and documentation. [None]

deployment options:
  --gen-config          (DEPRECATED, use devpi-gen-config command) generate example config files for nginx/supervisor/crontab/systemd/launchd/windows-
                        service, taking other passed options into account (e.g. port, host, etc.) [False]
  --secretfile path     file containing the server side secret used for user validation. If not specified, a random secret is generated on each start up.
                        [None]
  --requests-only       only start as a worker which handles read/write web requests but does not run an event processing or replication thread. [False]

permission options:
  --restrict-modify SPEC
                        specify which users/groups may create other users and their indices. Multiple users and groups are separated by commas. Groups need
                        to be prefixed with a colon like this: ':group'. By default anonymous users can create users and then create indices themself, but
                        not modify other users and their indices. The root user can do anything. When this option is set, only the specified users/groups
                        can create and modify users and indices. You have to add root explicitely if wanted. [None]

background server (DEPRECATED, see --gen-config to use a process manager from your OS):
  --start               start the background devpi-server [False]
  --stop                stop the background devpi-server [False]
  --status              show status of background devpi-server [False]
  --log                 show logfile content of background server [False]

devpi-web theme options:
  --theme THEME         folder with template and resource overwrites for the web interface [None]

devpi-web doczip options:
  --documentation-path DOCUMENTATION_PATH
                        path for unzipped documentation. By default the --serverdir is used. [None]

devpi-web search indexing:
  --indexer-backend NAME
                        the indexer backend to use [whoosh]
```

## devpi-web

**DEBUG=0**

Set this to anything but 0 and the container start up will dump a more detailed
log of the start up procedure.

**WEB_AUTH=0**

Set this to anything but 0 to add http basic auth from htpasswd file
`/devpi/auth/passwd`

**WEB_SERVER_NAME=localhost**

Set the name the public server name that will be respoded to.

**WEB_CLIENT_MAX_BODY_SIZE=64M**

Sets the maximum allowed size of the client request body.

**WEB_PROXY_TIMEOUT=60**

Defines a timeout in seconds for reading a response from the proxied devpi
server. The timeout is set only between two successive read operations, not for
the transmission of the whole response. If the proxied server does not transmit
anything within this time, the connection is closed.
