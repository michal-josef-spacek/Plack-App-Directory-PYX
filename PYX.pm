package Plack::App::Directory::PYX;

use base qw(Plack::App::Directory);
use strict;
use warnings;

use PYX::SGML::Tags;
use Tags::Output::Raw;
use Unicode::UTF8 qw(encode_utf8);

our $VERSION = 0.01;

sub serve_path {
	my ($self, $env, $path_to_file_or_dir) = @_;

	if (-d $path_to_file_or_dir) {
		return [
			200,
			[
				'Content-Type' => 'text/plain',
			],
			['DIR'],
		];
	}

	my $tags = Tags::Output::Raw->new;
	my $pyx = PYX::SGML::Tags->new(
		'tags' => $tags,
	);

	$pyx->parse_file($path_to_file_or_dir);

	return [
		200,
		[
			'Content-Type' => 'text/html',
		],
		[encode_utf8($tags->flush)],
	];
}

1;
