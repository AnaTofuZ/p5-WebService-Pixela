requires 'perl', '5.008001';
requires 'IO::Socket::SSL';
requires 'Class::Accessor::Lite';
requires 'Furl';
requires 'JSON';
requires 'URI';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
};
