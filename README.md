[![Build Status](https://travis-ci.com/AnaTofuZ/p5-WebService-Pixela.svg?branch=master)](https://travis-ci.com/AnaTofuZ/p5-WebService-Pixela)
# NAME

WebService::Pixela - It's [https://pixe.la](https://pixe.la) API client for Perl.

# SYNOPSIS

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

# DESCRIPTION

WebService::Pixela is API client about [https://pixe.la](https://pixe.la)

# ORIGINAL API DOCUMENTATION

See also [https://docs.pixe.la/](https://docs.pixe.la/) .

This module corresponds to version 1.

# INTERFACE

## Class Methods

### `WebService::Pixela->new(%args)`

It is WebService::Pixela constructor.

_%args_ might be:

- `username :  Str`

    Pixela service username.

- `token  :  Str`

    Pixela service token.

- `base_url : Str : default => 'https://pixe.la/'`

    Pixela service api root url.
    (It does not include version URL.)

#### What does the WebService::Pixela instance contain?

WebService::Pixela instance have four representative instance methods.
Each representative instance methods is an instance of the same class 'WebService::Pixela::' name.

## Instance Methods (It does not call other WebService::Pixela::.\* instances.)

### `$pixela->username  : Str`

Output and set the user name of the instance.

### `$pixela->token  : Str`

Output and set the token of the instance.

### `$pixela->base_url : Str`

Output and set the base url of the instance.

## Instance Methods 

It conforms to the official API document.
See aloso [https://docs.pixe.la/](https://docs.pixe.la/) .

### `$pixela->user`

This instance method uses  a [WebService::Pixela::User](https://metacpan.org/pod/WebService::Pixela::User) instance.

#### `$pixela->user->create(%opts)`

It is Pixe.la user create.

_%opts_ might be:

- `agree_terms_of_service :  [yes|no]  (default : "yes" )`

    Specify yes or no whether you agree to the terms of service.
    If there is no input, it defaults to yes. (For this module.)

- `not_minor :  [yes|no]  (default : "yes")`

    Specify yes or no as to whether you are not a minor or if you are a minor and you have the parental consent of using this (Pixela) service.
    If there is no input, it defaults to yes. (For this module.)

See also [https://docs.pixe.la/#/post-user](https://docs.pixe.la/#/post-user)

#### `$pixela->user->update($newtoken)`

Updates the authentication token for the specified user.

_$newtoken_ might be:

- `$newtoken :Str`

    It is a new authentication token.

See also [https://docs.pixe.la/#/update-user](https://docs.pixe.la/#/update-user)

#### `$pixela->user->delete()`

Deletes the specified registered user.

See also [https://docs.pixe.la/#/delete-user](https://docs.pixe.la/#/delete-user)

# LICENSE

Copyright (C) Takahiro SHIMIZU.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takahiro SHIMIZU <anatofuz@gmail.com>
