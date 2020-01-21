#!/pro/bin/perl

use strict;
use warnings;

use Getopt::Long qw(:config bundling nopermute);
my $check = 0;
my $opt_v = 0;
GetOptions (
    "c|check"		=> \$check,
    "v|verbose:1"	=> \$opt_v,
    ) or die "usage: $0 [--check]\n";

use lib "sandbox";
use genMETA;
my $meta = genMETA->new (
    from    => "lib/App/geoip.pm",
    verbose => $opt_v,
    );

$meta->from_data (<DATA>);
$meta->gen_cpanfile ();

if ($check) {
    $meta->check_encoding ();
    $meta->check_required ();
    $meta->check_minimum ("5.14", [ "geoip" ]);
    $meta->done_testing ();
    }
elsif ($opt_v) {
    $meta->print_yaml ();
    }
else {
    $meta->fix_meta ();
    }

__END__
--- #YAML:1.0
name:                    App-geoip
version:                 VERSION
abstract:                Show geological data based on hostname or IP address(es)
license:                 perl
author:
    - H.Merijn Brand <h.m.brand@xs4all.nl>
generated_by:            Author
distribution_type:       module
provides:
    App::geoip:
        file:            lib/App/geoip.pm
        version:         VERSION
requires:
    perl:                5.014
    Archive::Zip:        0
    Data::Dumper:        0
    DBI:                 0
    Getopt::Long:        0
    JSON::PP:            0
    LWP::Simple:         0
    Math::Trig:          0
    Net::CIDR:           0
    Pod::Usage:          0
    Socket:              0
    Text::CSV_XS:        1.39
recommends:
    Archive::Zip:        1.67
    Data::Dumper:        2.173
    DBI:                 1.642
    Getopt::Long:        2.51
    JSON::PP:            4.04
    LWP::Simple:         6.43
    Math::Trig:          1.23
    Net::CIDR:           0.20
    Pod::Usage:          1.69
    Socket:              2.029
    Text::CSV_XS:        1.40
configure_requires:
    ExtUtils::MakeMaker: 0
build_requires:
    Config:              0
test_requires:
    Test::More:          0
resources:
    license:             http://dev.perl.org/licenses/
    repository:          https://github.com/Tux/GeoIP2
    homepage:            https://metacpan.org/pod/App::geoip
    bugtracker:          https://github.com/Tux/GeoIP2/issues
    IRC:                 irc://irc.perl.org/#csv
meta-spec:
    version:             1.4
    url:                 http://module-build.sourceforge.net/META-spec-v1.4.html
