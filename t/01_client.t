use strict;
use warnings;

use Test2::V0 -target => 'WebService::Pixela';

use WebService::Pixela;

subtest 'create_instance_success' => sub {
    ok (my $obj = $CLASS->new(username => 'test', token => 'testtoken'),
        q{ create_instance_success(input username and token) });
    isa_ok( $obj, [$CLASS],"create instance at WebService::Pixela");
};

subtest 'use_methods' => sub {
    can_ok($CLASS,qw/username token base_url user graph pixel webhook _agent/);
};

subtest 'method by each instance' => sub {
    my $obj = $CLASS->new(username => 'test', token => 'testtoken');
    isa_ok( $obj->user, [qw/WebService::Pixela::User/],"create instance at WebService::Pixela");
    isa_ok( $obj->_agent, [qw/HTTP::Tiny/],"_agent is HTTP::Tiny instance");
};

subtest 'Whether the entered value is properly set' => sub {
    my %params = ( username => 'test', token => 'testtoken', base_url => 'http://example.com' );
    my $obj = $CLASS->new(username => $params{username}, token => $params{token}, base_url => $params{base_url});
    for my $key (keys %params){
        is ( [$obj->$key, $obj->{$key}], [($params{$key}) x 2], "$key is properly set.");
    }
};

subtest 'Test of new method call without argument' => sub {
    like( dies { $CLASS->new(); }, qr/require username/, "Not intput username" );
    like( warning { $CLASS->new(username => 'test'); }, qr/not input token/, "No input token");
    is($CLASS->new(username => 'test', token => 'testtoken')->base_url, 'https://pixe.la/', "base_url is pixe.la url");
};


done_testing;
