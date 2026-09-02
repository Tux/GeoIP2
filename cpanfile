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
recommends "DBI"                      => "1.652";
recommends "Data::Dumper"             => "2.192";
recommends "Getopt::Long"             => "2.58";
recommends "JSON::PP"                 => "4.18";
recommends "LWP::Simple"              => "6.83";
recommends "Math::Trig"               => "1.63";
recommends "Net::CIDR"                => "0.27";
recommends "Pod::Usage"               => "2.05";
recommends "Socket"                   => "2.043";
recommends "Text::CSV_XS"             => "1.64";

on "configure" => sub {
    requires   "ExtUtils::MakeMaker";

    recommends "ExtUtils::MakeMaker"      => "7.22";

    suggests   "ExtUtils::MakeMaker"      => "7.78";
    };

on "build" => sub {
    requires   "Config";
    };

on "test" => sub {
    requires   "Test::More";
    };
