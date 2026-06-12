-- ==========================================
-- 1. NextAuth / Auth.js Tables for Supabase
-- ==========================================

create schema if not exists next_auth;

create table if not exists
  next_auth.users (
    id uuid not null primary key default uuid_generate_v4(),
    name text,
    email text,
    "emailVerified" timestamp with time zone,
    image text
  );

create table if not exists
  next_auth.accounts (
    id uuid not null primary key default uuid_generate_v4(),
    "userId" uuid not null references next_auth.users (id) on delete cascade,
    type text not null,
    provider text not null,
    "providerAccountId" text not null,
    refresh_token text,
    access_token text,
    expires_at bigint,
    token_type text,
    scope text,
    id_token text,
    session_state text,
    unique (provider, "providerAccountId")
  );

create table if not exists
  next_auth.sessions (
    id uuid not null primary key default uuid_generate_v4(),
    expires timestamp with time zone not null,
    "sessionToken" text not null unique,
    "userId" uuid not null references next_auth.users (id) on delete cascade
  );

create table if not exists
  next_auth.verification_tokens (
    identifier text,
    token text,
    expires timestamp with time zone not null,
    primary key (identifier, token)
  );

-- ==========================================
-- 2. BotFlow Application Tables (Public)
-- ==========================================

create table if not exists public."Bot" (
    id uuid not null primary key default uuid_generate_v4(),
    "userId" uuid not null references next_auth.users (id) on delete cascade,
    name text not null,
    "clientId" text not null,
    "botToken" text not null,
    "publicKey" text not null,
    "avatarUrl" text,
    status text not null default 'ACTIVE',
    "createdAt" timestamp with time zone not null default now(),
    "updatedAt" timestamp with time zone not null default now()
);

create table if not exists public."Command" (
    id uuid not null primary key default uuid_generate_v4(),
    "botId" uuid not null references public."Bot" (id) on delete cascade,
    name text not null,
    description text not null,
    "responseType" text not null default 'TEXT',
    "responseContent" text not null,
    enabled boolean not null default true,
    "createdAt" timestamp with time zone not null default now(),
    "updatedAt" timestamp with time zone not null default now(),
    unique("botId", name)
);

create table if not exists public."ExecutionLog" (
    id uuid not null primary key default uuid_generate_v4(),
    "botId" uuid not null references public."Bot" (id) on delete cascade,
    "commandName" text not null,
    "guildId" text,
    "channelId" text,
    "userId" text,
    status text not null,
    error text,
    "latencyMs" integer,
    timestamp timestamp with time zone not null default now()
);

-- Note: The @auth/supabase-adapter requires NextAuth objects to be returned as cleanly mapped JSON, so these grants give NextAuth access:
grant usage on schema next_auth to service_role;
grant all on all tables in schema next_auth to service_role;
grant all on all routines in schema next_auth to service_role;
grant all on all sequences in schema next_auth to service_role;
