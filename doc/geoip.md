# NAME

geoip - a tool to show geographical data based on hostname or IP address(es)

# SYNOPSIS

    geoip --help

    geoip --fetch [--no-update]

    geoip [options] [host|IP ...]

# DESCRIPTION

This tool uses a database to use the (pre-fetched) GeoIP2 data from MaxMind
to show related geographical information for IP addresses. This information
can optionally be extended with information from online WHOIS services and
or derived data, like distance to the location of the server this tool runs
on or a configured local location.

The output is plain text or JSON. JSON may be short or formatted.

## Configuration

The tool allows the use of configuration files. It tests for existence of
the files listed here. All existing files is read (in this order) if it is
only writable by the author (mode `0640` should do).

    $home/geoip.rc
    $home/.geoiprc
    $home/.config/geoip

where `$home` is either of `$HOME`, `$USERPROFILE`, or `$HOMEPATH`.

The format of the file is

    # Comment
    ; Comment
    option : value
    option = value

where the `:` and `=` are equal and whitespace around them is optional
and ignored. The values `False` and `No` (case insensitive) are the same
as `0` and the values `True` and `Yes` are equal to `1`. For readability
you can prefix `use_` to most options (it is ignored). The use of `-` in
option names is allowed and will be translated to `_`.

The recognized options and the command line equivalences are

- fetch

    command line option : `-f` or `--fetch`

    default value       : False

    Fetch new databases from the MaxMind site.

- update

    command line option : `-u` or `--update`

    default value       : True

    Only in effect when used with `--fetch`: when new data files from MaxMind
    have successfully been fetched and any of these is newer that what the
    database contains, update the database with the new data.

- distance

    command line option : `-d` or `--distance`

    default value       : False

    If both the location of the tool _and_ the location of the requested IP
    are known, calculate the distance between them. The default is to show
    the distance in kilometers. Choosing a configuration of `miles` instead
    of `True`, `Yes`, or `1` will show the distance in miles. There is no
    command line option for miles.

    The location of the tool is either locally stored in your configuration
    (see `--local-location`) or fetched using the result of the urls
    [`iplocation.com`](https://iplocation.com) or
    [`geoiptool`](https://geoiptool.com). This will - of course - not work
    if there is no network connection or outside traffic is not allowed.

- whois

    command line option : `-w` or `--whois`

    default value       : False

    If [Net::Whois::IP](https://metacpan.org/pod/Net%3A%3AWhois%3A%3AIP) is installed, and this option is true, this module
    will be used to retrieve the `whois` information. This will not work if
    there is no network connection or outside traffic is not allowed.

- short

    command line option : `-s` or `--short`

    default value       : False

    This option will disable the output of less-informative information like
    location, EU-membership, satellite and proxy. This option, if True, will
    also implicitly disable the `distance` and `whois` information.

- dsn

    command line option : `-Ddsn` or `--DB=dsn`

    default value       : `$ENV{EOIP_DBI_DSN}` or `dbi:Pg:geoip`

    See ["DATABASE"](#database) for the (documented) list of supported database types.

    If the connection works, the tables used by this tool will be created if
    not yet present.

    The order of usage is:

    1. Command line argument (`--DB=dsn`)
    2. The `GEOIP_DBI_DSN` environment variable
    3. The value for `dsn` in the configuration file(s)
    4. `dbi:Pg:dbname=geoip`

- json

    command line option : `-j` or `--json`

    default value       : False

    The default output for the information is plain text. With this option,
    the output will be in JSON format. The default is not prettified.

- json-pretty

    command line option : `-J` or `--json-pretty`

    default value       : False

    If set from the command-line, this implies the `--json` option.

    With this option, JSON output is done _pretty_ (indented).

- local-location

    command line option : `-l lat/lon` or `--local=lat/lon`

    default value       : Undefined

    Sets the local location coordinates for use with distances.

    When running the tool from a different location than where the IP access is
    to be analyzed for or when the network connection will not report a location
    that would make sense (like working from a cloud or running over one or more
    VPN connections), one can set the location of the base in decimal notation.
    (degree-minute-second-notation is not yet supported).

    This is also useful when there is no outbound connection possible or when you
    do not move location and you want to restrict network requests.

    The notation is decimal (with a `.`, no localization support) where latitude
    and longitude are separated by a `/` or a `,`, like `-l 12.345678/-9.876543`
    or `--local=12,3456,45,6789`.

- maxmind-account

    command line option : none

    default value       : Undefined

    Currently not (yet) used. Documentation only.

- license-id

    command line option : none

    default value       : Undefined

    Currently not (yet) used. Documentation only.

- license-key

    command line option : none

    default value       : Undefined

    As downloads are only allowed/possible using a valid MaxMind account, you need
    to provide a valid license key in your configuration file. If you do not have
    an account, you can sign up [here](https://www.maxmind.com/en/geolite2/signup).

# DATABASE

Currently PostgreSQL and SQLite have been tested, but others may (or may not)
work just as well. YMMV. Note that the database need to know the `CIDR`
field type and is able to put a primary key on it.

MariaDB and MySQL are not supported, as they do not support the concept of
CIDR type fields.

The advantage of PostgreSQL over SQLite is that you can use it with multiple
users at the same time, and that you can share the database with other hosts
on the same network behind a firewall.

The advantage of SQLite over PostgreSQL is that it is a single file that you
can copy or move to your liking. This file will be somewhere around 500 Mb.

# EXAMPLES

## Configuration

    $ cat ~/.config/geoip
    use_distance    : True
    json-pretty     : yes

## Basic use

    $ geoip --short 1.2.3.4

## For automation

    $ geoip --json --no-json-pretty 1.2.3.4

    $ env GEOIP_HOST=1.2.3.4 geoip

## Full report

    $ geoip --dist --whois 1.2.3.4

## Selecting CIDR's for countries

### List all CIDR's for Vatican City

    $ geoip --country=Vatican > vatican-city.cidr

### Statistics

If you enable verbosity, the selected statistics will be presented at the
end of the CIDR-list: number of CIDR's, number of enclosed IP's, name of
the country and the continent. As the country name is just a perl regex,
you can select all countries with `.`, or all countries that start with
a `V`:

    $ geoip --country=^V -v >/dev/null
    Selected CIDR's
    # CIDR       # IP Country               Continent
    ------ ---------- --------------------- ---------------
        21      18176 Vanuatu               Oceania
       321      13056 Vatican City          Europe
       272    6798500 Venezuela             South America
       612   16014080 Vietnam               Asia

# TODO

- IPv6

    The ZIP files also contain IPv6 information, but it is not (yet) converted
    to the database, nor supported in analysis.

- Modularization

    Split up the different parts of the script to modules: fetch, extract,
    check, database, external tools, reporting.

- CPAN

    Turn this into something like App::geoip, complete with Makefile.PL

# SEE ALSO

[DBI](https://metacpan.org/pod/DBI), [Net::CIDR](https://metacpan.org/pod/Net%3A%3ACIDR), [Math::Trig](https://metacpan.org/pod/Math%3A%3ATrig), [LWP::Simple](https://metacpan.org/pod/LWP%3A%3ASimple), [Archive::ZIP](https://metacpan.org/pod/Archive%3A%3AZIP),
[Text::CSV\_XS](https://metacpan.org/pod/Text%3A%3ACSV_XS), [JSON::PP](https://metacpan.org/pod/JSON%3A%3APP), [GIS::Distance](https://metacpan.org/pod/GIS%3A%3ADistance), [Net::Whois::IP](https://metacpan.org/pod/Net%3A%3AWhois%3A%3AIP),
[HTML::TreeBuilder](https://metacpan.org/pod/HTML%3A%3ATreeBuilder), [Data::Dumper](https://metacpan.org/pod/Data%3A%3ADumper), [Data::Peek](https://metacpan.org/pod/Data%3A%3APeek), [Socket](https://metacpan.org/pod/Socket)

[Geo::Coder::HostIP](https://metacpan.org/pod/Geo%3A%3ACoder%3A%3AHostIP), [Geo::IP](https://metacpan.org/pod/Geo%3A%3AIP), [Geo::IP2Location](https://metacpan.org/pod/Geo%3A%3AIP2Location), [Geo::IP2Proxy](https://metacpan.org/pod/Geo%3A%3AIP2Proxy),
[Geo::IP6](https://metacpan.org/pod/Geo%3A%3AIP6), [Geo::IPfree](https://metacpan.org/pod/Geo%3A%3AIPfree), [Geo::IP::RU::IpGeoBase](https://metacpan.org/pod/Geo%3A%3AIP%3A%3ARU%3A%3AIpGeoBase), [IP::Country](https://metacpan.org/pod/IP%3A%3ACountry),
[IP::Country::DB\_File](https://metacpan.org/pod/IP%3A%3ACountry%3A%3ADB_File), [IP::Country::DNSBL](https://metacpan.org/pod/IP%3A%3ACountry%3A%3ADNSBL), [IP::Info](https://metacpan.org/pod/IP%3A%3AInfo), [IP::Location](https://metacpan.org/pod/IP%3A%3ALocation),
[IP::QQWry](https://metacpan.org/pod/IP%3A%3AQQWry), [IP::World](https://metacpan.org/pod/IP%3A%3AWorld), [Metabrik::Lookup::Iplocation](https://metacpan.org/pod/Metabrik%3A%3ALookup%3A%3AIplocation), [Pcore::GeoIP](https://metacpan.org/pod/Pcore%3A%3AGeoIP)

[IP::Geolocation::MMDB](https://metacpan.org/pod/IP%3A%3AGeolocation%3A%3AMMDB)

Check [CPAN](https://metacpan.org/search?q=geoip) for more.

# THANKS

Thanks to cavac for the inspiration

# AUTHOR

H.Merijn Brand `<hmbrand@cpan.org>`, aka Tux.

# COPYRIGHT AND LICENSE

The GeoLite2 end-user license agreement, which incorporates components of the
Creative Commons Attribution-ShareAlike 4.0 International License 1) can be found
[here](https://www.maxmind.com/en/geolite2/eula) 2). The attribution requirement
may be met by including the following in all advertising and documentation
mentioning features of or use of this database.

This tool uses, but does not include, the GeoLite2 data created by MaxMind,
available from \[http://www.maxmind.com\](http://www.maxmind.com).

    Copyright (C) 2018-2023 H.Merijn Brand.  All rights reserved.

This library is free software;  you can redistribute and/or modify it under
the same terms as Perl itself.
See [here](https://opensource.org/licenses/Artistic-2.0) 3).

    1) https://creativecommons.org/licenses/by-sa/4.0/
    2) https://www.maxmind.com/en/geolite2/eula
    3) https://opensource.org/licenses/Artistic-2.0
