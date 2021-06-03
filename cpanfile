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
recommends "Data::Dumper"             => "2.181";
recommends "Getopt::Long"             => "2.52";
recommends "JSON::PP"                 => "4.06";
recommends "LWP::Simple"              => "6.54";
recommends "Math::Trig"               => "1.23";
recommends "Net::CIDR"                => "0.21";
recommends "Pod::Usage"               => "2.01";
recommends "Socket"                   => "2.032";
recommends "Text::CSV_XS"             => "1.46";

on "configure" => sub {
    requires   "ExtUtils::MakeMaker";
    };

on "build" => sub {
    requires   "Config";
    };

on "test" => sub {
    requires   "Test::More";
    };
