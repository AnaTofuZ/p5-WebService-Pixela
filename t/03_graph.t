use strict;
use warnings;

use Test2::V0 -target => 'WebService::Pixela::Graph';

use JSON;
use WebService::Pixela;

my $username = 'testuser';
my $token    = 'thisistoken';

my $pixela = WebService::Pixela->new(username => $username, token => $token);
my $graph  = $pixela->graph;

subtest 'use_methods' => sub {
    can_ok($CLASS,qw/new client id create get get_svg update delete/);
};

subtest 'new' => sub {
    ok( my $obj = $CLASS->new($pixela),'create instance');
    isa_ok($obj->{client}, [qw/'WebService::Pixela/], 'client is WebService::Pixela instance');
};

subtest 'use_methods_by_instance' => sub {
    can_ok($graph ,qw/new client id create get get_svg update delete/);
};

subtest 'client_method' => sub {
    isa_ok($graph->client, [qw/'WebService::Pixela/], 'client is WebService::Pixela instance');
};

subtest 'id_method' => sub {
    my $pixela = WebService::Pixela->new(username => $username, token => $token);
    my $graph  = $pixela->graph;
    my $test_id = 'testid';

    $graph->{id} = $test_id;
    is ($graph->id,$test_id, 'no input argument return id value');
    is ($graph->id(),$test_id, 'no input argument return id value');

    isa_ok($graph->id('update'), [$CLASS], 'The WebService::Pixela::Graph instance returns as a return value');
    like($graph->id('update2'),
         object {
             call  id => 'update2';
             field id => 'update2';
         },
         'id method set id at instance');
    like($graph->id(undef),
         object {
             call  id => undef;
             field id => undef;
         },
         'id method set undef id at instance');
};


subtest 'no_args_create_method_croak' => sub {
    like( dies {$graph->create()}, qr/require id/, "no input id");
    like( dies {$graph->create(id => 'testid')}, qr/require name/, "no input name");
    like( dies {$graph->create(id => 'testid', name => 'testname')}, qr/require unit/, "no input unit");
    like( dies {$graph->create(id => 'testid', name => 'testname', unit => 1, )}, qr/require type/, "no input type");
    like( dies {$graph->create(id => 'testid', name => 'testname', unit => 1, type => 1)}, qr/require color/, "no input color");
    like( dies {$graph->create(id => 'testid', name => 'testname', unit => 1, type => 1, color => 'invalid')}, qr/invalid color/, "invalid color");
};

subtest 'create_method' => sub {
    my $mock = mock 'WebService::Pixela' => (
        override => [request_with_xuser_in_header => sub {shift @_; return [@_]; }],
    );

    my %params = (
        id    => 'testid',
        name  => 'testname',
        unit  => 'testunit',
        type  => 'testtype',
        color => 'ICHOU',
    );

    my $path = 'users/'.$username.'/graphs';

    is(
        $graph->create(%params),
        [   'POST',
            $path,
            \%params,
        ],
        'input params call create method'
    );

};

done_testing;
