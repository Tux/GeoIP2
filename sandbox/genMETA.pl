#!/pro/bin/perl

use strict;
use warnings;

use Getopt::Long qw(:config bundling nopermute);
GetOptions (
    "c|check"		=> \ my $check,
    "u|update!"		=> \ my $update,
    "v|verbose:1"	=> \(my $opt_v = 0),
    ) or die "usage: $0 [--check]\n";

use lib "sandbox";
use genMETA;
my $meta = genMETA->new (
    from    => "lib/App/geoip.pm",
    verbose => $opt_v,
    );

$meta->from_data (<DATA>);
$meta->security_md ($update);
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
abstract:                Show geographical data based on hostname or IP address(es)
license:                 perl
author:
    - H.Merijn Brand <hmbrand@cpan.org>
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
    Pod::Text:           0
    List::Util:          0
    Socket:              0
    Text::CSV_XS:        1.39
recommends:
    Archive::Zip:        1.68
    Data::Dumper:        2.189
    DBI:                 1.645
    Getopt::Long:        2.58
    JSON::PP:            4.16
    LWP::Simple:         6.77
    Math::Trig:          1.62
    Net::CIDR:           0.21
    Pod::Usage:          2.03
    Socket:              2.038
    Text::CSV_XS:        1.58
configure_requires:
    ExtUtils::MakeMaker: 0
configure_recommends:
    ExtUtils::MakeMaker: 7.22
configure_suggests:
    ExtUtils::MakeMaker: 7.70
build_requires:
    Config:              0
test_requires:
    Test::More:          0
resources:
    license:             http://dev.perl.org/licenses/
    homepage:            https://metacpan.org/pod/App::geoip
    repository:          https://github.com/Tux/GeoIP2
    bugtracker:          https://github.com/Tux/GeoIP2/issues
    IRC:                 irc://irc.perl.org/#csv
meta-spec:
    version:             1.4
    url:                 http://module-build.sourceforge.net/META-spec-v1.4.html
