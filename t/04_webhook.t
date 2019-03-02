use strict;
use warnings;

use Test2::V0 -target => 'WebService::Pixela::Webhook';

use JSON;
use WebService::Pixela;

my $username = 'testuser';
my $token    = 'thisistoken';

subtest 'use_methods' => sub {
    can_ok($CLASS,qw/new client create get invoke delete hash/);
};

subtest 'new_method' => sub {
    my $pixela = WebService::Pixela->new(username => $username, token => $token);
    ok( my $obj = $CLASS->new($pixela), 'create instance');
    isa_ok($obj->{client}, [qw/WebService::Pixela/], 'client is WebService::Pixela');
};

subtest 'client_method' => sub {
    my $pixela = WebService::Pixela->new(username => $username, token => $token);
    isa_ok($pixela->webhook->client,[qw/WebService::Pixela/], 'cient is WebService::Pixela');
};

subtest 'croak_create_method' => sub {
    my $pixela = WebService::Pixela->new(username => $username, token => $token);
    like( dies {$pixela->webhook->create()}, qr/require graph_id/, 'require graph_id');
    like( dies {$pixela->webhook->create(graph_id => 'test')}, qr/require type/, 'require type');
    like( dies {$pixela->webhook->create(graph_id => 'test', type => 'invalid')}, qr/invalid type/, 'invalid type');
};

done_testing;
