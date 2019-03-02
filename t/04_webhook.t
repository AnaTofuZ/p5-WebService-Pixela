use strict;
use warnings;

use Test2::V0 -target => 'WebService::Pixela::Webhook';

use JSON;
use WebService::Pixela;

my $username = 'testuser';
my $token    = 'thisistoken';


subtest 'use_methods' => sub {
    can_ok($CLASS,qw/new client create get invoke delete/);
};

subtest 'new_methods' => sub {
    my $pixela = WebService::Pixela->new(username => $username, token => $token);
    ok( my $obj = $CLASS->new($pixela), 'create instance');
    isa_ok($obj->{client}, [qw/WebService::Pixela/], 'client is WebService::Pixela');
};

done_testing;
