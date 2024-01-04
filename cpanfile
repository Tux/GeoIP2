requires   "Archive::Zip";
requires   "DBI";
requires   "Data::Dumper";
requires   "Getopt::Long";
requires   "JSON::PP";
requires   "LWP::Simple";
requires   "List::Util";
requires   "Math::Trig";
requires   "Net::CIDR";
requires   "Pod::Text";
requires   "Socket";
requires   "Text::CSV_XS"             => "1.39";

recommends "Archive::Zip"             => "1.68";
recommends "DBI"                      => "1.643";
recommends "Data::Dumper"             => "2.188";
recommends "Getopt::Long"             => "2.57";
recommends "JSON::PP"                 => "4.16";
recommends "LWP::Simple"              => "6.72";
recommends "Math::Trig"               => "1.62";
recommends "Net::CIDR"                => "0.21";
recommends "Pod::Usage"               => "2.03";
recommends "Socket"                   => "2.037";
recommends "Text::CSV_XS"             => "1.53";

on "configure" => sub {
    requires   "ExtUtils::MakeMaker";

    recommends "ExtUtils::MakeMaker"      => "7.22";

    suggests   "ExtUtils::MakeMaker"      => "7.70";
    };

on "build" => sub {
    requires   "Config";
    };

on "test" => sub {
    requires   "Test::More";
    };
