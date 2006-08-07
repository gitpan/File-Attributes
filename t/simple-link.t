#!/usr/bin/perl
# simple-link.t 
# Copyright (c) 2006 Jonathan Rockway <jrockway@cpan.org>

use Test::More tests => 12;
use File::Attributes::Simple;

use Directory::Scratch;
my  $tmp = Directory::Scratch->new;
my $orig = $tmp->touch('file');
$tmp->link('file', 'new');

my $link = $tmp->exists('new');

my $a = File::Attributes::Simple->new;

ok(-e $orig);
ok(-l $link);

$a->set($orig, 'foo', 'bar');
$a->set($orig, 'baz', 'qux');

is($a->get($orig, 'foo'), 'bar');
is($a->get($orig, 'baz'), 'qux');
is($a->get($link, 'foo'), 'bar');
is($a->get($link, 'baz'), 'qux');

$a->set($link, 'link.yay', 'it works');
is($a->get($link, 'link.yay'), 'it works');
is($a->get($orig, 'link.yay'), 'it works');

$tmp->link('new', 'newer');
$tmp->link('newer', 'newest');
my $deep = $tmp->exists('newest');
ok($deep);
is($a->get($deep, 'link.yay'), 'it works');
is($a->get($deep, 'foo'), 'bar');
$a->unset($deep, 'foo');
is($a->get($orig, 'foo'), undef);
