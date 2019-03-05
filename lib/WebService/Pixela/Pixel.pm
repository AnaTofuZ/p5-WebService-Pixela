package WebService::Pixela::Pixel;
use 5.010001;
use strict;
use warnings;
use Carp qw/croak/;
use JSON qw/decode_json/;

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

sub post {
    my ($self,%args) = @_;
    my $params = {};

    #check graphID
    my $id = $self->_check_id($args{id});

    #check date
    $params->{date}     = $args{date}     // croak 'require date';

    #check quantity
    $params->{quantity} = $args{quantity} // croak 'require quantity';

    #check optionalData
    $params->{optionalData} = $args{optional_data} if $args{optional_data};

    my $path = $self->_create_path($id);
    return $self->client->request_with_xuser_in_header('POST',$path,$params);
}

sub get {
    my ($self, %args) = @_;

    my $id = $self->_check_id($args{id});

    my $date = $args{date} // croak 'require date';

    my $path = $self->_create_path($id,$date);
    return $self->client->request_with_xuser_in_header('GET',$path);
}

sub update {
    my ($self,%args) = @_;

    my $id = $self->_check_id($args{id});

    #check date
    my $date = $args{date} // croak 'require date';

    my $params = {};

    #check quantity
    $params->{quantity}     = $args{quantity}      if $args{quantity};

    #check optionalData
    $params->{optionalData} = $args{optional_data} if $args{optional_data};

    my $path = $self->_create_path($id,$date);
    return $self->client->request_with_xuser_in_header('PUT',$path,$params);
}

sub increment {
    my ($self,%args) = @_;
    my $client = $self->client;

    my $id = $self->_check_id($args{id});

    my $path = $self->_create_path($id);
    $path = $path . '/increment';

    my $length = $args{length} // 0;

    return $client->request_with_dual_in_header('PUT',$path,$length);
}

sub decrement {
    my ($self,%args) = @_;
    my $client = $self->client;

    my $id = $self->_check_id($args{id});

    my $path = $self->_create_path($id);
    $path = $path . '/decrement';

    my $length = $args{length} // 0;

    return $client->request_with_dual_in_header('PUT',$path,$length);
}

sub delete {
    my ($self,%args) = @_;
    my $client = $self->client;

    my $id = $self->_check_id($args{id});
    my $date = $args{date} // croak 'require date';

    my $path = $self->_create_path($id,$date);

    return $self->client->request_with_xuser_in_header('DELETE',$path);
}

sub _check_id {
    my ($self,$arg_id) = @_;

    my $id = $arg_id ? $arg_id : $self->client->graph->id();
    croak 'require graph_id' unless $id;
    return $id;
}

sub _create_path {
    my ($self,$id,$date) = @_;
    my $path = 'users/'.$self->client->username.'/graphs/'.$id;
    return defined $date ? $path . '/' . $date : $path;
}


1;
__END__

=encoding utf-8

=head1 NAME

WebService::Pixela::Pixel - It's Pixela Webhook API client

=head1 SYNOPSIS

    use strict;
    use warnings;
    use utf8;

    use WebService::Pixela;

    # All WebService::Pixela methods use this token and user name in URI, JSON, etc.
    my $pixela = WebService::Pixela->new(token => "thisissecret", username => "testname");

    # setting graph id
    $pixela->graph->id('graph_id');

    $pixela->webhook->create(type => 'increment');

    print $pixela->webhook->hash() ."\n"; # dump webhookHash

    $pixela->webhook->invoke();

    $pixela->webhook->delete();

=head1 DESCRIPTION

WebService::Pixela::Pixel is user API client about L<Pixe.la|https://pixe.la> webservice.

=head1 INTERFACE

=head2 instance methods

This instance method require L<WebService::Pixela> instance.
So, Usually use these methods from the C<< WebService::Pixela >> instance.

=head3 C<< $pixela->webhook->create(%opts) >>

Create a new Webhook by Pixe.la
This method return webhookHash, this is automatically set instance.

I<%opts> might be:

=over

=item C<< [required] graph_id  :  Str  >>

Specify the target graph as an ID.
If the graph id is set for an instance, it will be automatically used.
(You do not need to enter it as an argument)

=item C<< [required] type : [increment|decrement] >>

Specify the behavior when this Webhook is invoked.
Only C<< increment >> or C<< decrement >> are supported.
(There is no distinction between upper case and lower case letters.)

=back

=head4 See also

L<https://docs.pixe.la/#/post-webhook>


=head1 LICENSE

Copyright (C) Takahiro SHIMIZU.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takahiro SHIMIZU E<lt>anatofuz@gmail.comE<gt>

=cut

