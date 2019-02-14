package WebService::Pixela::User;
use 5.008001;
use strict;
use warnings;
use Carp qw/croak/;
use JSON qw/encode_json/;

our $VERSION = "0.01";

sub new {
    my ($class,$pixela_client) = @_;
    return bless +{
        client => $pixela_client,
    }, $class;
}

sub client {
    my $self = shift;
    return $self->{client};
}

sub create {
    my ($self,%args) = @_;
    my $client = $self->client;

    my $params = {
        username            => $client->username,
        token               => $client->token,
        agreeTermsOfService => $args{agreeTermsOfService} || "yes",
        notMinor            => $args{notMinor}            || "yes",
    };
    my $res = $client->request('POST','users/',$params);
}

sub update {
    my ($self,$newtoken) = @_;
    my $client = $self->client;

    my $params = {
        header  => {
            'X-USER-TOKEN' => $client->token,
        },
        content => encode_json({
            newToken    => $newtoken,
        }),
    };
    $client->request('PUT',('users/'.$client->username),$params);
    $self->client->token = $newtoken;
}


1;
__END__

=encoding utf-8

=head1 NAME

WebService::Pixela::User - It's Pixela User API client

=head1 SYNOPSIS

    use WebService::Pixela::User;

=head1 DESCRIPTION

WebService::Pixela::User is ...

=head1 LICENSE

Copyright (C) Takahiro SHIMIZU.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takahiro SHIMIZU E<lt>anatofuz@gmail.comE<gt>

=cut

