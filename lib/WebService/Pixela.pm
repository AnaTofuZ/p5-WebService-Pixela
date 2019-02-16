package WebService::Pixela;
use 5.010001;
use strict;
use warnings;
use HTTP::Tiny;
use Carp;
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
        decode
    /],
);

our $VERSION = "0.01";

sub new {
    my ($class,%args) = @_;
    my $self = bless +{}, $class;

    # initalize
    $self->{username} = $args{username} // croak 'require username';
    $self->{token}    = $args{token}    // (carp('not input token'), undef);
    $self->{base_url} = $args{base_url} // "https://pixe.la/";
    $self->{decode}   = $args{decode}   // 1;
    $self->{_agent}   = HTTP::Tiny->new();

    #WebService::Pixela instances
    $self->{user}     = WebService::Pixela::User->new($self);

    return $self;
}

sub _decode_or_simple_return_from_json {
    my ($self,$rev_json) = @_;

    unless ($self->decode){
        return $rev_json;
    }

    return decode_json($rev_json);
}

sub _request {
    my ($self,$method,$path,$params) = @_;

    my $uri = URI->new($self->base_url);
    $uri->path("/v1/".$path);

    my $receive_json = $self->_agent->request($method, $uri->as_string, $params)->{"content"};

    return $self->_decode_or_simple_return_from_json($receive_json);
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
    $pixela->user->create(agreeTermsOfService => "yes", notMinor => "no"); # can input agreeTermsOfService and notMinor


    $pixela->user->delete(); # delete method not require arguments


=head1 DESCRIPTION

WebService::Pixela is API client about L<https://pixe.la>

=head1 ORIGINAL API DOCUMENT

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

=item C<< decode : boolean : default => 1  >>

If I<decode> is true it returns a Perl object, false it returns json as is.


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

=head3 C<< $pixela->decode : boolean   >>

Output and set the decode of the instance.
If I<decode> is true it returns a Perl object, false it returns json as is.

=head2 Instance Methods 

It conforms to the official API document.
See aloso L<https://docs.pixe.la/> .

=head3 C<< $pixela->user >>

This instance method uses  a L<WebService::Pixela::User> instance.

=head4 C<< $pixela->user->create(%opts) >>

It is Pixe.la user create.


I<%opts> might be:

=over

=item C<< agree_terms_of_service :  [yes|no]  (default : "yes" ) >>

Specify yes or no whether you agree to the terms of service.
If there is no input, it defaults to yes. (For this module.)

=item C<< not_minor :  [yes|no]  (default : "yes") >>

Specify yes or no as to whether you are not a minor or if you are a minor and you have the parental consent of using this (Pixela) service.
If there is no input, it defaults to yes. (For this module.)

=back

See also L<https://docs.pixe.la/#/post-user>

=head4 C<< $pixela->user->update($newtoken) >>

Updates the authentication token for the specified user.

I<$newtoken> might be:

=over

=item C<< $newtoken :Str >>

It is a new authentication token.

=back

See also L<https://docs.pixe.la/#/update-user>

=head4 C<< $pixela->user->delete() >>

Deletes the specified registered user.

See also L<https://docs.pixe.la/#/delete-user>

=head1 LICENSE

Copyright (C) Takahiro SHIMIZU.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takahiro SHIMIZU E<lt>anatofuz@gmail.comE<gt>

=cut

