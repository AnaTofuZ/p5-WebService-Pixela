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

WebService::Pixela - It's L<https://pixe.la> API client for Perl.

=head1 SYNOPSIS

    use strict;
    use warnings;

    use WebService::Pixela;

    # All WebService::Pixela methods use this token and user name in URI, JSON, etc.
    my $pixela = WebService::Pixela->new(token => "thisissecret", username => "testname");
    print $pixela->username,"\n"; # testname
    print $pixela->token,"\n";    # thisissecret

    $pixela->user->create(); # default agreeTermsOfService and notMinor "yes"
    # or...
    $pixela->user->create(agreeTermsOfService => "no", notMinor => "no"); # can input agreeTermsOfService and notMinor


    $pixela->user->delete(); # delete method not require arguments


=head1 DESCRIPTION

WebService::Pixela is API client about L<https://pixe.la>

=head1 ORIGINAL API DOCUMENTATION

See also L<https://docs.pixe.la/> .

This module corresponds to version 1.

=head1 INTERFACE

=head2 Class Methods

=head3 C<< WebService::Pixela->new(%args) >>

It is WebService::Pixela constructor.

I<%args> might be:

=over

=item C<< username :  Str >>

Pixela service username.

=item C<< token  :  Str >>

Pixela service token.

=item C<< base_url : Str : default => 'https://pixe.la/' >>

Pixela service api root url.
(It does not include version URL.)

=back

=head4 What does the WebService::Pixela instance contain?

WebService::Pixela instance have four representative instance methods.
Each representative instance methods is an instance of the same class 'WebService::Pixela::' name.

=head2 Instance Methods (It does not call other WebService::Pixela::.* instances.)

=head3 C<< $pixela->username  : Str >>

Output and set the user name of the instance.

=head3 C<< $pixela->token  : Str >>

Output and set the token of the instance.

=head3 C<< $pixela->base_url : Str >>

Output and set the base url of the instance.

=head2 Instance Methods 

=head3 C<< $pixela->user >>

This instance method uses  a C<< WebService::Pixela::User >> instance.

See also L<WebService::Pixela::User> .

=head1 LICENSE

Copyright (C) Takahiro SHIMIZU.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takahiro SHIMIZU E<lt>anatofuz@gmail.comE<gt>

=cut

