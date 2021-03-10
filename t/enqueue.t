# -*- mode: perl -*-
use Mojo::Base -strict, -signatures;
use Mojo::File qw(curfile);
use Mojo::Promise;
use Test::More;
use Minion;
use Minion::Job;
use lib 't/lib';

my $minion = Minion->with_roles('Minion::Role::EnqueueDefaults')->new(SQLite => ':memory:');

subtest 'add task' => sub {
  is $minion->add_task(task1 => 'Test::Task1'), $minion, 'chains';
};

subtest 'enqueue with defaults' => sub {
  my $id  = $minion->enqueue(task1 => [3, 9]);
  my $job = $minion->job($id);
  is $job->id, $id, 'correct job';
  is $job->info->{priority}, -100,      'enqueued with correct priority';
  is $job->info->{queue},    'special', 'enqueued with correct queue';
  is $job->info->{lax},      0,         'enqueued with correct lax setting';
  is_deeply $job->args, [3, 9], 'correct';
};

subtest 'enqueue with options' => sub {
  my $id  = $minion->enqueue(task1 => [3, 9], {lax => 1, queue => 'normal', priority => 10});
  my $job = $minion->job($id);
  is $job->id, $id, 'correct job';
  is $job->info->{priority}, 10,       'enqueued with correct priority';
  is $job->info->{queue},    'normal', 'enqueued with correct queue';
  is $job->info->{lax},      1,        'enqueued with correct lax setting';
  is_deeply $job->args, [3, 9], 'correct';
};

done_testing
