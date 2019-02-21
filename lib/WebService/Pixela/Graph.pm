package WebService::Pixela::Graph;
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

sub id {
    my $self = shift;
    if (@_){
        $self->{id} = shift;
        return $self;
    }
    return $self->{id};
}

sub create {
    my ($self,%args) = @_;
    my $params = {};

    $params->{id} = $args{id} // $self->id();
    croak 'require id' unless $params->{id};

    map { $params->{$_} = $args{$_} // croak "require $_" } (qw/name unit/);

    croak 'require type' unless $args{type};
    map {
            if ( $args{type} =~ /^$_$/i){
                $params->{type} = lc($args{type});
            }
        } (qw/int float/);
    croak 'invalid type' unless $params->{type};

    croak 'require color' unless $args{color};
    $params->{color} = _color_validate($args{color});
    croak 'invalid color' unless $params->{color};

    $params->{timezone} = $args{timezone} if $args{timezone};

    my $path = 'users/'.$self->client->username.'/graphs';
    $self->id($params->{id});
    return $self->client->request_with_xuser_in_header('POST',$path,$params);
}


sub get {
    my $self = shift;
    return $self->client->request_with_xuser_in_header('GET',('users/'.$self->client->username.'/graphs'),{});
}


sub get_svg {
    my ($self, %args) = @_;
    my $id = $args{id} // $self->id;
    croak 'require graph id' unless $id;

    my $query = {};
    $query->{date} = $args{date} if $args{date};
    $query->{mode} = $args{mode} if $args{mode};

    my $path = 'users/'.$self->client->username.'/graphs/'.$id;

    return $self->client->query_request('GET',$path,$query);
}

sub update {
    my ($self,%arg) = @_;
    my $client = $self->client;

    my $id = $arg{id} // $self->id;
    croak 'require graph id' unless $id;

    my $params = {};
    map { $params->{$_} = $arg{$_} if $arg{$_} } (qw/name unit timezone/);
    $params->{color} = _color_validate($arg{color}) if defined $arg{color};
    delete $params->{color} unless $params->{color};


    if ($arg{purge_cache_urls}){
        if (ref($arg{purge_cache_urls}) ne 'ARRAY'){
            croak 'invalid types for purge_cache_urls';
        }
        $params->{purgeCacheURLs} = $arg{purge_cache_urls};
    }

    $params->{selfSufficient} = $arg{self_sufficient} if defined $arg{self_sufficient};

    return $client->request_with_xuser_in_header('PUT',('users/'.$client->username.'/graphs/'.$id),$params);
}

sub delete {
    my ($self,$id) = @_;
    my $client = $self->client;

    $id //= $self->id;
    croak 'require graph id' unless $id;

    return $client->request_with_xuser_in_header('DELETE',('users/'.$client->username.'/graphs/'.$id),{});
}

sub view {
    my ($self,$id) = @_;
    my $client = $self->client;
    $id //= $self->id;
    return $client->base_url . 'v1/users/'.$client->username.'/graphs/'.$id.'.html';
}

sub _color_validate  {
    my $check_color = shift;
    map {
        if ($check_color  =~ /^$_$/i){
            return lc($check_color);
        }
    } (qw/shibafu momiji sora ichou ajisai kuro/);
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

WebService::Pixela::Graph - It's Pixela Graph API client

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

WebService::Pixela::Graph is user API client about L<Pixe.la|https://pixe.la> webservice.

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

