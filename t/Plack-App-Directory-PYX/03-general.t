use strict;
use warnings;

use File::Object;
use Plack::App::Directory::PYX;
use Plack::Test;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Directories.
my $data_dir = File::Object->new->up->dir('data');

# Test.
my $app = Plack::App::Directory::PYX->new('root' => $data_dir->dir('root')->s);
my $test = Plack::Test->create($app);
my $res = $test->request(HTTP::Request->new(GET => '/ex1.pyx'));
is($res->content,
	'<html><head><title>title</title></head><body><div>Example #1</div></body></html>',
	'Get content of ex1.pyx page.');

# Test.
$res = $test->request(HTTP::Request->new(GET => '/ex2.pyx'));
is($res->content,
	'<html><head><title>title</title></head><body><div>Example #2</div></body></html>',
	'Get content of ex2.pyx page.');
