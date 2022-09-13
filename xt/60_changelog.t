#!/usr/bin/perl

use 5.014000;
use Test::More;

eval "use Test::CPAN::Changes";
plan skip_all => "Test::CPAN::Changes required for this test" if $@;

changes_file_ok ("ChangeLog");

done_testing;
