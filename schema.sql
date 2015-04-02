
create table "user"(
    user_id uuid primary key,
    name text not null,
    email text not null unique,
    password text not null,
    created_at timestamptz not null default now()
);

create table playlist(
    playlist_id uuid primary key,
    name text not null,
    created_at timestamptz not null default now()
);

create type track_status as enum ('queued', 'played', 'banned');

create table track(
    track_id uuid primary key,
    playlist_id uuid not null references playlist(playlist_id),
    user_id uuid not null references "user"(user_id),
    status track_status not null,
    name text not null,
    length interval not null,
    raw_data jsonb not null,
    played_at timestamptz,
    created_at timestamptz not null default now(),

    constraint played_track_status check (
        (status <> 'played'::track_status and played_at is null) or
        (status = 'played'::track_status and played_at is not null))
);
