package WebService::Pixela::Webhook;
use 5.010001;
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

sub hash {
    my $self = shift;
    if (@_){
        $self->{hash} = shift;
        return $self;
    }
    return $self->{hash};
}

sub create {
    my ($self,%args) = @_;
    my $params = {};

    #check graphID
    $params->{graphID} = $args{graph_id} // $self->client->graph->id;
    croak 'require graph_id' unless $params->{graphID};

    #check type
    croak 'require type' unless $args{type};
    map {
            if( $args{type} =~ /^$_$/i){
                $params->{type} = lc($args{type});
            }
    } (qw/increment decrement/);
    croak 'invalid type' unless $params->{type};

    my $path = 'users/'.$self->client->username.'/webhooks';
    my $res  = $self->client->request_with_xuser_in_header('POST',$path,$params);

    my $res_json = $self->client->decode() ? $res : encode_json($res);

    if($res_json->{isuSuccess}){
        $self->hash($res_json->{webhookHash});
    }

    return $res;
}

sub get {
    my $self   = shift;
    my $client = $self->client;

    my $path = 'users/'.$client->username.'/webhooks';
    my $res = $client->request_with_xuser_in_header('GET',$path);

    return $client->decode() ? $res->{webhooks} : $res;
}

sub invoke {
    my ($self,$hash) = @_;
    my $client = $self->client;

    $hash //= $self->hash();

    my $path = 'users/'.$client->username.'/webhooks'.$hash;
    ...
}

sub delete {
    ...
}


1;
__END__

=encoding utf-8

=head1 NAME

WebService::Pixela::Webhook - It's Pixela Webhook API client

=head1 SYNOPSIS

    use strict;
    use warnings;
    use utf8;

    use WebService::Pixela;

    # All WebService::Pixela methods use this token and user name in URI, JSON, etc.
    my $pixela = WebService::Pixela->new(token => "thisissecret", username => "testname");
    print $pixela->username,"\n"; # testname
    print $pixela->token,"\n";    # thisissecret

    $pixela->user->create(); # default agreeTermsOfService and notMinor "yes"
    # or...
    $pixela->user->create(agree_terms_of_service => "yes", not_minor => "no"); # can input agreeTermsOfService and notMinor

    $pixela->user->update("newsecret_token"); # update method require new secret token characters
    print $pixela->token,"\n";

    $pixela->user->delete(); # delete method not require arguments


=head1 DESCRIPTION

WebService::Pixela::Webhook is user API client about L<Pixe.la|https://pixe.la> webservice.

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

=head3 C<< $pixela->user->update($newtoken) >>

Updates the authentication token for the specified user.

I<$newtoken> might be:

=over

=item C<< $newtoken :Str >>

It is a new authentication token.

=back

=head4 See also

L<https://docs.pixe.la/#/update-user>

=head3 C<< $pixela->user->delete() >>

Deletes the specified registered user.

=head4 See also

L<https://docs.pixe.la/#/delete-user>

=head1 LICENSE

Copyright (C) Takahiro SHIMIZU.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takahiro SHIMIZU E<lt>anatofuz@gmail.comE<gt>

=cut

