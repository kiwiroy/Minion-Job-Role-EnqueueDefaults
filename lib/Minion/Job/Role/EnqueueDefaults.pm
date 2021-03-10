package Minion::Job::Role::EnqueueDefaults;

use Mojo::Base -role;

our $VERSION = '0.01';

requires qw(enqueue_defaults);

1;

=encoding utf8

=head1 NAME

Minion::Job::Role::EnqueueDefaults - Interface

=head1 SYNOPSIS

  package Task::Multiply;
  
  use Mojo::Base 'Minion::Job';
  use Role::Tiny::With qw(with);
  
  sub enqueue_defaults { +{priority => 42} }
  
  with 'Minion::Job::Role::EnqueueDefaults';
  1
  
=head1 DESCRIPTION

=cut
