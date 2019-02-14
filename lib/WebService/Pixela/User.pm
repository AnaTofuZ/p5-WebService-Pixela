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
        agreeTermsOfService => $args{agree_terms_of_service} || "yes",
        notMinor            => $args{not_minor}              || "yes",
    };
    my $res = $client->request('POST','users/',$params);
    return $res;
}

sub update {
    my ($self,$newtoken) = @_;
    my $client = $self->client;

    my $params = {
        newToken    => $newtoken,
    };
    my $res = $client->request_with_xuser_in_header('PUT',('users/'.$client->username),$params);
    $self->client->token = $newtoken;
    return $res;
}

sub delete {
    my $self = shift;
    my $client = $self->client;

    my $res = $client->request_with_xuser_in_header('DELETE',('users/'.$client->username),{});
    return $res;
}


1;
__END__

=encoding utf-8

=head1 NAME

WebService::Pixela::User - It's Pixela User API client

=head1 SYNOPSIS

    use WebService::Pixela::User;

=head1 DESCRIPTION

WebService::Pixela::User is user API client about L<Pixe.la|https://pixe.la> webservice.

=head1 INTERFACE

=head2 instance methods

This instance method require L<WebService::Pixela> instance.
So, Usually use these methods from the C<< WebService::Pixela >> instance.

=head3 C<< $pixela->user->create(%opts) >>

It is Pixe.la user create.


I<%opts> might be:

=over

=item C<< agree_terms_of_service :  [yes|no]  >>

Specify yes or no whether you agree to the terms of service.
If there is no input, it defaults to yes. (For this module.)

=item C<< not_minor :  [yes|no]  >>

Specify yes or no as to whether you are not a minor or if you are a minor and you have the parental consent of using this (Pixela) service.
If there is no input, it defaults to yes. (For this module.)

=back

=head4 See also

L<https://docs.pixe.la/#/post-user>

=head1 LICENSE

Copyright (C) Takahiro SHIMIZU.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takahiro SHIMIZU E<lt>anatofuz@gmail.comE<gt>

=cut

