# NAME

Minion::Job::Role::EnqueueDefaults - Interface

# SYNOPSIS

    package Task::Multiply;
    
    use Mojo::Base 'Minion::Job';
    use Role::Tiny::With qw(with);
    
    sub enqueue_defaults { +{priority => 42} }
    
    with 'Minion::Job::Role::EnqueueDefaults';
    1
    

# DESCRIPTION
