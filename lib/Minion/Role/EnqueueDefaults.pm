package Minion::Role::EnqueueDefaults;

use Mojo::Base -role, -signatures;

requires 'class_for_task';

around enqueue => sub ($orig, $self, @args) {
  my ($task, $jobargs, $options) = (shift(@args), shift(@args) // [], shift(@args) // {});
  return $self->$orig(@args) unless my $method = $self->class_for_task($task)->can('enqueue_defaults');
  return $self->$orig($task => $jobargs, {%{$method->() || {}}, %$options});
};

1;

=encoding utf8

=head1 NAME

Minion::Role::EnqueueDefaults - Role to use any enqueue defaults for tasks

=head1 SYNOPSIS

  $minion = Minion->with_roles('+EnqueueDefaults')->new(@args);
  
  # Task::Multiple::enqueue_defaults must exist
  $minion->add_task(product => 'Task::Multiply');
  
  # enqueued using defaults defined in Task::Multiply
  $minion->enqueue(product => [900, 10]);

=head1 DESCRIPTION

Enqueue tasks with the specified options as defined in Task class.

=cut
