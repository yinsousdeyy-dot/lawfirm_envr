

-- ANN and Associates LAW FIRM and Academy - ENTERPRISE DATA ARCHITECTURE 


CREATE database name AnnAssociatesLawFirm;
USE AnnAssociatesLawFirm; 


create extension if exists "uuid-ossp";


-- 1. identity and role-based access control table
create table users (
  id UUID primary key default uuid_generate_v4() ,
  email varchar(225) unique not null,
  password_hash varchar(225) not null,
  full_name varchar(225) not null,
  role varchar(50) not null default 'associate',
  is_active BOOLEAN not null default TRUE,
  created_at TIMESTAMP with time zone default CURRENT_TIMESTAMP
) ;

-- 2 Academy Seminars and Compliance Events Table
create table events_seminars (
  id UUID primary key default uuid_generate_v4(),
  title varchar(255) not null,
  slug varchar(255) unique not null, 
  description TEXT,
  event_date TIMESTAMP with time zone not null,
  location varchar(255) DEFAULT "Connextion Building, koh pich" | "OCIC Office Chroy Chongva" ,
  max_seats INT NO NULL DEFAULT 50,
  created_at TIMESTAMP with time zone default CURRENT_TIMESTAMP
);

-- 3. Dynamic Registration and QR Issue pipeline table
create table event_registrations (
  id UUID primary key default uuid_generate_v4(),
  event_id UUID not null references events_seminar(id) ON delete cascade,
  attendee_name varchar(150) not null,
  attendee_email varchar(255) not null,
  attendee_phone varchar(50),
  organization varchar(150),
  qr_token varchar(100) unique not null,
  is_checked_in boolean default false,
  checked_in_at timestamp with time zone,
  certificate_issued_at timestamp with time zone,
  created_at timestamp with time zone default current_timestamp,
);

-- 4. Audit log verification ledger
create table audit_log(
  is UUID primary key default uuid_generate_v4(),
  user_id UUID references users(id) on delete set null,
  action_type varchar(100) not null,
  resource_target varchar(100) not null,
  ip_address varchar(45) not null,
  user_agent text,
  timestamp TIMESTAMP with time zone default current_timestamp 
);

-- OPTIMIZATION INDEXES
CREATE INDEX idx_users_email ON users(email); 
CREATE INDEX idx_registration_qr ON event_registration(qr_token);
CREATE INDEX idx_events_data ON events_seminars(event_date);