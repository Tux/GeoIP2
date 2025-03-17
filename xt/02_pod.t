#!/usr/bin/perl

use Test::More;

eval "use Test::Pod::Links";
plan skip_all => "Test::Pod::Links required for testing POD Links" if $@;
eval {
    no warnings "redefine";
    no warnings "once";
    *Test::XTFiles::all_files = sub { "geoip"; };
    };
Test::Pod::Links->new (ignore_match => qr{^https://www.maxmind.com})->all_pod_files_ok;
