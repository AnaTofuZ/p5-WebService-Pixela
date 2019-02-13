package WebService::Pixela::User;
use 5.008001;
use strict;
use warnings;
use Carp qw/croak/;
use URI;
use JSON;
use Class::Accessor::Lite(
    rw => [qw/client/],
);

our $VERSION = "0.01";

sub new {
    my ($class,$pixela_client) = @_;
    return bless +{
        client => $pixela_client,
    }, $class;
}

sub create {
    my ($self,%args) = @_;
    my $client = $self->client;

    my $uri = URI->new($client->base_url);

    print $uri->as_string,"\n";
    my $content = {
        token => $client->token,
        username => $client->username,
        agreeTermsOfService => $args{areeTermsOfService} || "No",
        notMinor => $args{notMinor} || "No",
    };
    $uri->path('/v1/users');
    my $res = $client->_agent->request(
        method => 'POST',
        url    => $uri->as_string,
        content => encode_json($content),
    );
}


1;
__END__

=encoding utf-8

=head1 NAME

WebService::Pixela - It's new $module

=head1 SYNOPSIS

    use WebService::Pixela;

=head1 DESCRIPTION

WebService::Pixela is ...

=head1 LICENSE

Copyright (C) Takahiro SHIMIZU.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takahiro SHIMIZU E<lt>anatofuz@gmail.comE<gt>

=cut

