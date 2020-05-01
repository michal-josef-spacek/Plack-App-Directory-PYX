use strict;
use warnings;

use Error::Pure;
use File::Object;
use Plack::App::Directory::PYX;
use Plack::Test;
use Test::More 'tests' => 9;
use Test::NoWarnings;

# Directories.
my $data_dir = File::Object->new->up->dir('data')->dir('root')->set;

# Test.
my $app = Plack::App::Directory::PYX->new('root' => $data_dir->s);
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

# Test.
$res = $test->request(HTTP::Request->new(GET => '/'));
is($res->content, 'DIR', 'Get content of directory index.');

# Test.
$app = Plack::App::Directory::PYX->new(
	'indent' => 'Tags::Output::Indent',
	'root' => $data_dir->s,
);
$test = Plack::Test->create($app);
$res = $test->request(HTTP::Request->new(GET => '/ex1.pyx'));
my $right_ret = <<'END';
<html>
  <head>
    <title>
      title
    </title>
  </head>
  <body>
    <div>
      Example #1
    </div>
  </body>
</html>
END
chomp $right_ret;
is($res->content,
	$right_ret,
	'Get content of ex1.pyx page in indent mode (version with directory).');

# Test.
$app = Plack::App::Directory::PYX->new(
	'file' => $data_dir->file('ex1.pyx')->s,
	'indent' => 'Tags::Output::Indent',
);
$test = Plack::Test->create($app);
$res = $test->request(HTTP::Request->new(GET => '/'));
$right_ret = <<'END';
<html>
  <head>
    <title>
      title
    </title>
  </head>
  <body>
    <div>
      Example #1
    </div>
  </body>
</html>
END
chomp $right_ret;
is($res->content,
	$right_ret,
	'Get content of ex1.pyx page in indent mode (version with one file).');

# Test.
$app = Plack::App::Directory::PYX->new(
	'file' => $data_dir->file('ex1.pyx')->s,
	'indent' => '__not_exist_module_name_',
);
$test = Plack::Test->create($app);
$res = $test->request(HTTP::Request->new(GET => '/'));
is($res->content, "Cannot load class '__not_exist_module_name_'.\n",
	'Get error in case of not existing class.');


# Test.
$app = Plack::App::Directory::PYX->new(
	'file' => $data_dir->file('ex1.pyx')->s,
	'indent' => 'Error::Pure',
);
$test = Plack::Test->create($app);
$res = $test->request(HTTP::Request->new(GET => '/'));
is($res->content, "Cannot create object for 'Error::Pure' class.\n",
	'Get error in case of not existent constructor of serialization class.');

# Test.
$app = Plack::App::Directory::PYX->new(
	'file' => $data_dir->file('ex1.pyx')->s,
	'indent' => 'Plack::App::Directory::PYX',
);
$test = Plack::Test->create($app);
$res = $test->request(HTTP::Request->new(GET => '/'));
is($res->content, "Bad 'Tags::Output' module to create PYX output.\n",
	'Get error in case of bad indentation class (not Tags::Output).');

