-- Creativa Startup Data Integration System
-- Foundation schema v0.1
-- PostgreSQL
-- Design principles:
-- 1) Preserve every imported source record.
-- 2) Keep startup, people, and program participation separate.
-- 3) Store program-specific answers without forcing them into fixed columns.
-- 4) Do not auto-merge startups or people in this foundation schema.

BEGIN;

CREATE TABLE IF NOT EXISTS sources (
    source_id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_name         TEXT NOT NULL,
    source_type         TEXT NOT NULL CHECK (source_type IN
                         ('google_form', 'google_sheet', 'excel', 'csv', 'manual', 'other')),
    source_url          TEXT,
    form_or_sheet_name  TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE
);

-- Immutable-ish landing area: keep original payload and source coordinates.
CREATE TABLE IF NOT EXISTS source_records (
    source_record_id    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_id           BIGINT NOT NULL REFERENCES sources(source_id),
    external_record_key TEXT,
    source_row_number   INTEGER,
    submitted_at        TIMESTAMPTZ,
    ingested_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    raw_payload         JSONB NOT NULL,
    payload_hash        TEXT,
    processing_status  TEXT NOT NULL DEFAULT 'new'
                         CHECK (processing_status IN
                         ('new', 'mapped', 'needs_review', 'processed', 'rejected', 'error')),
    UNIQUE (source_id, external_record_key)
);

CREATE TABLE IF NOT EXISTS startups (
    startup_id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    startup_name        TEXT NOT NULL,
    startup_name_normalized TEXT,
    sector              TEXT,
    stage_raw           TEXT,
    stage_id            TEXT,
    stage_group         TEXT,
    stage_detail        TEXT,
    team_range          TEXT,
    city                TEXT,
    website             TEXT,
    funding_status      TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    record_status       TEXT NOT NULL DEFAULT 'active'
                         CHECK (record_status IN ('active', 'merged', 'inactive')),
    merged_into_startup_id BIGINT REFERENCES startups(startup_id)
);

CREATE TABLE IF NOT EXISTS people (
    person_id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    person_name         TEXT,
    phone               TEXT,
    email               TEXT,
    linkedin            TEXT,
    other_contact       TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- A person may be connected to multiple startups; a startup may have multiple people.
CREATE TABLE IF NOT EXISTS startup_people (
    startup_person_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    startup_id          BIGINT NOT NULL REFERENCES startups(startup_id),
    person_id           BIGINT NOT NULL REFERENCES people(person_id),
    relationship_role   TEXT,
    is_primary_contact  BOOLEAN NOT NULL DEFAULT FALSE,
    founder_confidence  TEXT CHECK (founder_confidence IN
                         ('confirmed', 'likely', 'unknown', 'not_found')),
    contact_source      TEXT,
    valid_from          DATE,
    valid_to            DATE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (startup_id, person_id, relationship_role)
);

CREATE TABLE IF NOT EXISTS programs (
    program_id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    program_name        TEXT NOT NULL,
    program_type        TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (program_name)
);

CREATE TABLE IF NOT EXISTS participations (
    participation_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    startup_id          BIGINT REFERENCES startups(startup_id),
    person_id           BIGINT REFERENCES people(person_id),
    program_id          BIGINT NOT NULL REFERENCES programs(program_id),
    source_record_id    BIGINT REFERENCES source_records(source_record_id),
    participation_date  TIMESTAMPTZ,
    promo_code          TEXT,
    participation_status TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Program-specific questions and answers.
-- question_key should be stable within the source/form version where possible.
CREATE TABLE IF NOT EXISTS participation_responses (
    response_id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    participation_id   BIGINT NOT NULL REFERENCES participations(participation_id)
                         ON DELETE CASCADE,
    question_key        TEXT NOT NULL,
    question_label_raw  TEXT NOT NULL,
    answer_raw          JSONB,
    canonical_field     TEXT,
    answer_text_normalized TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS attachments (
    attachment_id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    startup_id          BIGINT REFERENCES startups(startup_id),
    participation_id   BIGINT REFERENCES participations(participation_id),
    attachment_type     TEXT,
    file_url            TEXT,
    original_label      TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (startup_id IS NOT NULL OR participation_id IS NOT NULL)
);

CREATE TABLE IF NOT EXISTS interactions (
    interaction_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    startup_id          BIGINT NOT NULL REFERENCES startups(startup_id),
    interaction_date    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    interaction_type    TEXT,
    summary             TEXT,
    outcome             TEXT,
    next_action          TEXT,
    created_by           TEXT
);

-- Approved mappings are reusable for future submissions.
CREATE TABLE IF NOT EXISTS field_mappings (
    field_mapping_id    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_id           BIGINT REFERENCES sources(source_id),
    form_or_sheet_name  TEXT,
    source_column_name  TEXT NOT NULL,
    canonical_field     TEXT NOT NULL,
    mapping_method      TEXT NOT NULL DEFAULT 'human_approved'
                         CHECK (mapping_method IN
                         ('exact_rule', 'alias_rule', 'ai_suggestion', 'human_approved')),
    confidence          NUMERIC(5,4),
    approval_status     TEXT NOT NULL DEFAULT 'pending'
                         CHECK (approval_status IN ('pending', 'approved', 'rejected')),
    approved_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS data_quality_issues (
    issue_id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_record_id    BIGINT REFERENCES source_records(source_record_id),
    startup_id          BIGINT REFERENCES startups(startup_id),
    field_name          TEXT,
    issue_type          TEXT NOT NULL,
    severity            TEXT NOT NULL DEFAULT 'medium'
                         CHECK (severity IN ('low', 'medium', 'high')),
    issue_description   TEXT,
    resolution_status  TEXT NOT NULL DEFAULT 'open'
                         CHECK (resolution_status IN ('open', 'resolved', 'ignored')),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at         TIMESTAMPTZ
);

-- Operational fields belong to the team workflow, not to imported form answers.
CREATE TABLE IF NOT EXISTS startup_operations (
    startup_id          BIGINT PRIMARY KEY REFERENCES startups(startup_id),
    priority            TEXT,
    outreach_status     TEXT,
    main_gap_need       TEXT,
    suggested_opportunity TEXT,
    notes               TEXT,
    last_contact        DATE,
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_source_records_source_id
    ON source_records(source_id);
CREATE INDEX IF NOT EXISTS idx_source_records_status
    ON source_records(processing_status);
CREATE INDEX IF NOT EXISTS idx_startups_name_normalized
    ON startups(startup_name_normalized);
CREATE INDEX IF NOT EXISTS idx_people_email
    ON people(email);
CREATE INDEX IF NOT EXISTS idx_people_phone
    ON people(phone);
CREATE INDEX IF NOT EXISTS idx_participations_program
    ON participations(program_id);
CREATE INDEX IF NOT EXISTS idx_responses_canonical_field
    ON participation_responses(canonical_field);

COMMIT;
