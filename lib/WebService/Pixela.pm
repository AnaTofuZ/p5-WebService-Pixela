package WebService::Pixela;
use 5.008001;
use strict;
use warnings;
use HTTP::Tiny;
use Carp qw/croak/;
use WebService::Pixela::User;
use URI;
use JSON;
use Class::Accessor::Lite(
    new => 0,
    ro  => [qw/
        user
        graph
        pixel
        webhook
        _agent
    /],
    rw  => [qw/
        username
        token
        base_url
    /],
);

our $VERSION = "0.01";

sub new {
    my ($class,%args) = @_;
    my $self = bless +{}, $class;

    # initalize
    $self->{username} = $args{username} || croak 'require username';
    $self->{token}    = $args{token}    || undef;
    $self->{base_url} = $args{base_url} || "https://pixe.la/";
    $self->{_agent}   = HTTP::Tiny->new();
    $self->{user}     = WebService::Pixela::User->new($self);

    return $self;
}


sub _request {
    my ($self,$method,$path,$params) = @_;

    my $uri = URI->new($self->base_url);
    $uri->path("/v1/".$path);

    return $self->_agent->request($method, $uri->as_string, $params);
}

sub request {
    my ($self,$method,$path,$content) = @_;

    my $params = {
        content => encode_json($content),
    };

    return $self->_request($method,$path,$params);
}

sub request_with_xuser_in_header {
    my ($self,$method,$path,$content) = @_;

    my $params = {
        headers => { 'X-USER-TOKEN' => $self->token },
        content => encode_json($content),
    };

    return $self->_request($method,$path,$params);
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

