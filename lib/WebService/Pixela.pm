package WebService::Pixela;
use 5.008001;
use strict;
use warnings;
use Furl;
use Carp qw/croak/;
use URI;
use JSON;
use WebService::Pixela::User;
use Class::Accessor::Lite(
    ro => [qw/
        user
        graph
        pixel
        webhook
        _agent
    /],
    rw => [qw/
        username
        token
        base_url
    /],
);

our $VERSION = "0.01";

sub new {
    my ($class,%args) = @_;
    my $self = bless +{}, $class;
    $self->{username} =  $args{username} || croak 'require username';
    $self->{token}    =  $args{token}    || undef;
    $self->{base_url} =  $args{base_url} || "https://pixe.la/";
    $self->{_agent} = Furl->new(agent => "$class/$VERSION");
    $self->{user}   = WebService::Pixela::User->new($self);
    return $self;
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

