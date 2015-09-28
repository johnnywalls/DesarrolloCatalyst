#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Curso';
all_from 'lib/Curso.pm';

requires 'Catalyst::Runtime' => '5.90092';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats

requires 'Catalyst::View::TT';
requires 'Catalyst::Helper::View::Bootstrap';
requires 'Image::Info';
requires 'MooseX::MethodAttributes';
requires 'Types::Standard';
requires 'Catalyst::Model::DBIC::Schema';
requires 'DBIx::Class::TimeStamp';
requires 'DBIx::Class::ResultClass::HashRefInflator';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Authentication::Store::Minimal';
requires 'Catalyst::Authentication::Credential::Password';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Digest::SHA1';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::ActionRole::ACL';
requires 'Log::Log4perl';
requires 'Catalyst::Plugin::StackTrace';
requires 'Catalyst::Plugin::CustomErrorMessage';
requires 'Catalyst::Controller::HTML::FormFu';
requires 'Number::Format';
requires 'HTML::Scrubber';
requires 'HTML::FormFu::Model::DBIC';
requires 'DBIx::Class::EncodedColumn';
requires 'Template::Plugin::Number::Format';
requires 'Catalyst::Plugin::RapidApp::Dbic';
requires 'Catalyst::Authentication::Store::LDAP';
requires 'Catalyst::Model::Adaptor';
requires 'WWW::Wikipedia';
requires 'REST::Google::Search';

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
