/*
  Creativa Startup Data Integration System
  Foundation Schema v0.1 - Microsoft SQL Server (T-SQL)

  Run this script inside the target database in SQL Server Management Studio (SSMS)
  or Azure Data Studio.

  Notes:
  - Uses SQL Server IDENTITY, NVARCHAR, DATETIME2 and T-SQL syntax.
  - Raw form answers are preserved in source_records.raw_payload as JSON text.
  - No automatic startup/person merging is implemented in this foundation.
*/

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

/* 1. Source systems: Forms, Sheets, Excel files, etc. */
IF OBJECT_ID(N'dbo.sources', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.sources (
        source_id           BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        source_name         NVARCHAR(255) NOT NULL,
        source_type         NVARCHAR(30) NOT NULL,
        source_url          NVARCHAR(2048) NULL,
        form_or_sheet_name  NVARCHAR(255) NULL,
        created_at          DATETIME2(0) NOT NULL CONSTRAINT DF_sources_created_at DEFAULT SYSUTCDATETIME(),
        is_active           BIT NOT NULL CONSTRAINT DF_sources_is_active DEFAULT (1),
        CONSTRAINT CK_sources_source_type CHECK
            (source_type IN (N'google_form', N'google_sheet', N'excel', N'csv', N'manual', N'other'))
    );
END;
GO

/* 2. Raw landing area: retain the original submission and its source location. */
IF OBJECT_ID(N'dbo.source_records', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.source_records (
        source_record_id    BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        source_id           BIGINT NOT NULL,
        external_record_key NVARCHAR(255) NULL,
        source_row_number   INT NULL,
        submitted_at        DATETIME2(0) NULL,
        ingested_at         DATETIME2(0) NOT NULL CONSTRAINT DF_source_records_ingested_at DEFAULT SYSUTCDATETIME(),
        raw_payload         NVARCHAR(MAX) NOT NULL,
        payload_hash        NVARCHAR(128) NULL,
        processing_status   NVARCHAR(30) NOT NULL CONSTRAINT DF_source_records_status DEFAULT N'new',
        CONSTRAINT FK_source_records_sources FOREIGN KEY (source_id) REFERENCES dbo.sources(source_id),
        CONSTRAINT CK_source_records_status CHECK
            (processing_status IN (N'new', N'mapped', N'needs_review', N'processed', N'rejected', N'error')),
        CONSTRAINT CK_source_records_json CHECK (ISJSON(raw_payload) = 1)
    );
END;
GO

/* A filtered unique index allows multiple NULL external_record_key values. */
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'UX_source_records_external_key'
      AND object_id = OBJECT_ID(N'dbo.source_records')
)
    CREATE UNIQUE INDEX UX_source_records_external_key
        ON dbo.source_records(source_id, external_record_key)
        WHERE external_record_key IS NOT NULL;
GO

/* 3. One row per startup identity. */
IF OBJECT_ID(N'dbo.startups', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.startups (
        startup_id              BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        startup_name            NVARCHAR(300) NOT NULL,
        startup_name_normalized NVARCHAR(300) NULL,
        sector                  NVARCHAR(150) NULL,
        stage_raw               NVARCHAR(150) NULL,
        stage_id                NVARCHAR(50) NULL,
        stage_group             NVARCHAR(100) NULL,
        stage_detail            NVARCHAR(150) NULL,
        team_range              NVARCHAR(50) NULL,
        city                    NVARCHAR(150) NULL,
        website                 NVARCHAR(2048) NULL,
        funding_status          NVARCHAR(100) NULL,
        created_at              DATETIME2(0) NOT NULL CONSTRAINT DF_startups_created_at DEFAULT SYSUTCDATETIME(),
        updated_at              DATETIME2(0) NOT NULL CONSTRAINT DF_startups_updated_at DEFAULT SYSUTCDATETIME(),
        record_status           NVARCHAR(20) NOT NULL CONSTRAINT DF_startups_record_status DEFAULT N'active',
        merged_into_startup_id  BIGINT NULL,
        CONSTRAINT FK_startups_merged_into FOREIGN KEY (merged_into_startup_id)
            REFERENCES dbo.startups(startup_id),
        CONSTRAINT CK_startups_record_status CHECK
            (record_status IN (N'active', N'merged', N'inactive'))
    );
END;
GO

/* 4. People are stored separately from startups. */
IF OBJECT_ID(N'dbo.people', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.people (
        person_id       BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        person_name     NVARCHAR(300) NULL,
        phone           NVARCHAR(80) NULL,
        email           NVARCHAR(320) NULL,
        linkedin        NVARCHAR(2048) NULL,
        other_contact   NVARCHAR(2048) NULL,
        created_at      DATETIME2(0) NOT NULL CONSTRAINT DF_people_created_at DEFAULT SYSUTCDATETIME(),
        updated_at      DATETIME2(0) NOT NULL CONSTRAINT DF_people_updated_at DEFAULT SYSUTCDATETIME()
    );
END;
GO

/* 5. Many-to-many relationship between startups and people. */
IF OBJECT_ID(N'dbo.startup_people', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.startup_people (
        startup_person_id   BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        startup_id          BIGINT NOT NULL,
        person_id           BIGINT NOT NULL,
        relationship_role   NVARCHAR(100) NULL,
        is_primary_contact  BIT NOT NULL CONSTRAINT DF_startup_people_primary DEFAULT (0),
        founder_confidence  NVARCHAR(20) NULL,
        contact_source      NVARCHAR(255) NULL,
        valid_from          DATE NULL,
        valid_to            DATE NULL,
        created_at          DATETIME2(0) NOT NULL CONSTRAINT DF_startup_people_created_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_startup_people_startups FOREIGN KEY (startup_id) REFERENCES dbo.startups(startup_id),
        CONSTRAINT FK_startup_people_people FOREIGN KEY (person_id) REFERENCES dbo.people(person_id),
        CONSTRAINT CK_startup_people_founder_confidence CHECK
            (founder_confidence IS NULL OR founder_confidence IN (N'confirmed', N'likely', N'unknown', N'not_found'))
    );
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'UX_startup_people_relationship'
      AND object_id = OBJECT_ID(N'dbo.startup_people')
)
    CREATE UNIQUE INDEX UX_startup_people_relationship
        ON dbo.startup_people(startup_id, person_id, relationship_role)
        WHERE relationship_role IS NOT NULL;
GO

/* 6. Programs and events. */
IF OBJECT_ID(N'dbo.programs', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.programs (
        program_id      BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        program_name    NVARCHAR(255) NOT NULL,
        program_type    NVARCHAR(100) NULL,
        created_at      DATETIME2(0) NOT NULL CONSTRAINT DF_programs_created_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_programs_program_name UNIQUE (program_name)
    );
END;
GO

/* 7. A startup/person can participate in multiple programs. */
IF OBJECT_ID(N'dbo.participations', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.participations (
        participation_id       BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        startup_id              BIGINT NULL,
        person_id               BIGINT NULL,
        program_id              BIGINT NOT NULL,
        source_record_id        BIGINT NULL,
        participation_date      DATETIME2(0) NULL,
        promo_code              NVARCHAR(100) NULL,
        participation_status    NVARCHAR(100) NULL,
        created_at              DATETIME2(0) NOT NULL CONSTRAINT DF_participations_created_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_participations_startups FOREIGN KEY (startup_id) REFERENCES dbo.startups(startup_id),
        CONSTRAINT FK_participations_people FOREIGN KEY (person_id) REFERENCES dbo.people(person_id),
        CONSTRAINT FK_participations_programs FOREIGN KEY (program_id) REFERENCES dbo.programs(program_id),
        CONSTRAINT FK_participations_source_records FOREIGN KEY (source_record_id)
            REFERENCES dbo.source_records(source_record_id)
    );
END;
GO

/* 8. Program-specific questions/answers; keeps differing forms flexible. */
IF OBJECT_ID(N'dbo.participation_responses', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.participation_responses (
        response_id             BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        participation_id        BIGINT NOT NULL,
        question_key            NVARCHAR(255) NOT NULL,
        question_label_raw      NVARCHAR(1000) NOT NULL,
        answer_raw              NVARCHAR(MAX) NULL,
        canonical_field         NVARCHAR(150) NULL,
        answer_text_normalized  NVARCHAR(MAX) NULL,
        created_at              DATETIME2(0) NOT NULL CONSTRAINT DF_participation_responses_created_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_participation_responses_participations FOREIGN KEY (participation_id)
            REFERENCES dbo.participations(participation_id) ON DELETE CASCADE,
        CONSTRAINT CK_participation_responses_answer_json CHECK
            (answer_raw IS NULL OR ISJSON(answer_raw) = 1)
    );
END;
GO

/* 9. Files and links submitted with applications. */
IF OBJECT_ID(N'dbo.attachments', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.attachments (
        attachment_id       BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        startup_id          BIGINT NULL,
        participation_id    BIGINT NULL,
        attachment_type     NVARCHAR(100) NULL,
        file_url            NVARCHAR(2048) NULL,
        original_label      NVARCHAR(500) NULL,
        created_at          DATETIME2(0) NOT NULL CONSTRAINT DF_attachments_created_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_attachments_startups FOREIGN KEY (startup_id) REFERENCES dbo.startups(startup_id),
        CONSTRAINT FK_attachments_participations FOREIGN KEY (participation_id)
            REFERENCES dbo.participations(participation_id),
        CONSTRAINT CK_attachments_parent CHECK (startup_id IS NOT NULL OR participation_id IS NOT NULL)
    );
END;
GO

/* 10. Operational interaction history. */
IF OBJECT_ID(N'dbo.interactions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.interactions (
        interaction_id      BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        startup_id          BIGINT NOT NULL,
        interaction_date    DATETIME2(0) NOT NULL CONSTRAINT DF_interactions_date DEFAULT SYSUTCDATETIME(),
        interaction_type    NVARCHAR(100) NULL,
        summary             NVARCHAR(MAX) NULL,
        outcome             NVARCHAR(500) NULL,
        next_action         NVARCHAR(500) NULL,
        created_by          NVARCHAR(255) NULL,
        CONSTRAINT FK_interactions_startups FOREIGN KEY (startup_id) REFERENCES dbo.startups(startup_id)
    );
END;
GO

/* 11. Approved mappings can be reused for future forms. */
IF OBJECT_ID(N'dbo.field_mappings', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.field_mappings (
        field_mapping_id    BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        source_id           BIGINT NULL,
        form_or_sheet_name  NVARCHAR(255) NULL,
        source_column_name  NVARCHAR(1000) NOT NULL,
        canonical_field     NVARCHAR(150) NOT NULL,
        mapping_method      NVARCHAR(30) NOT NULL CONSTRAINT DF_field_mappings_method DEFAULT N'human_approved',
        confidence          DECIMAL(5,4) NULL,
        approval_status     NVARCHAR(20) NOT NULL CONSTRAINT DF_field_mappings_status DEFAULT N'pending',
        approved_at         DATETIME2(0) NULL,
        created_at          DATETIME2(0) NOT NULL CONSTRAINT DF_field_mappings_created_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_field_mappings_sources FOREIGN KEY (source_id) REFERENCES dbo.sources(source_id),
        CONSTRAINT CK_field_mappings_method CHECK
            (mapping_method IN (N'exact_rule', N'alias_rule', N'ai_suggestion', N'human_approved')),
        CONSTRAINT CK_field_mappings_status CHECK
            (approval_status IN (N'pending', N'approved', N'rejected')),
        CONSTRAINT CK_field_mappings_confidence CHECK
            (confidence IS NULL OR (confidence >= 0 AND confidence <= 1))
    );
END;
GO

/* 12. Track quality problems for review rather than silently discarding data. */
IF OBJECT_ID(N'dbo.data_quality_issues', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.data_quality_issues (
        issue_id            BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        source_record_id    BIGINT NULL,
        startup_id          BIGINT NULL,
        field_name          NVARCHAR(150) NULL,
        issue_type          NVARCHAR(100) NOT NULL,
        severity            NVARCHAR(20) NOT NULL CONSTRAINT DF_data_quality_severity DEFAULT N'medium',
        issue_description   NVARCHAR(MAX) NULL,
        resolution_status   NVARCHAR(20) NOT NULL CONSTRAINT DF_data_quality_status DEFAULT N'open',
        created_at          DATETIME2(0) NOT NULL CONSTRAINT DF_data_quality_created_at DEFAULT SYSUTCDATETIME(),
        resolved_at         DATETIME2(0) NULL,
        CONSTRAINT FK_data_quality_source_records FOREIGN KEY (source_record_id)
            REFERENCES dbo.source_records(source_record_id),
        CONSTRAINT FK_data_quality_startups FOREIGN KEY (startup_id) REFERENCES dbo.startups(startup_id),
        CONSTRAINT CK_data_quality_severity CHECK (severity IN (N'low', N'medium', N'high')),
        CONSTRAINT CK_data_quality_status CHECK (resolution_status IN (N'open', N'resolved', N'ignored'))
    );
END;
GO

/* 13. Team-managed operational fields; not inferred from application forms. */
IF OBJECT_ID(N'dbo.startup_operations', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.startup_operations (
        startup_id              BIGINT NOT NULL PRIMARY KEY,
        priority                NVARCHAR(50) NULL,
        outreach_status         NVARCHAR(100) NULL,
        main_gap_need           NVARCHAR(MAX) NULL,
        suggested_opportunity   NVARCHAR(MAX) NULL,
        notes                   NVARCHAR(MAX) NULL,
        last_contact            DATE NULL,
        updated_at              DATETIME2(0) NOT NULL CONSTRAINT DF_startup_operations_updated_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_startup_operations_startups FOREIGN KEY (startup_id) REFERENCES dbo.startups(startup_id)
    );
END;
GO

/* Helpful indexes for common lookups and review queues. */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_source_records_status' AND object_id = OBJECT_ID(N'dbo.source_records'))
    CREATE INDEX IX_source_records_status ON dbo.source_records(processing_status);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_startups_name_normalized' AND object_id = OBJECT_ID(N'dbo.startups'))
    CREATE INDEX IX_startups_name_normalized ON dbo.startups(startup_name_normalized);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_people_email' AND object_id = OBJECT_ID(N'dbo.people'))
    CREATE INDEX IX_people_email ON dbo.people(email);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_people_phone' AND object_id = OBJECT_ID(N'dbo.people'))
    CREATE INDEX IX_people_phone ON dbo.people(phone);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_participations_program' AND object_id = OBJECT_ID(N'dbo.participations'))
    CREATE INDEX IX_participations_program ON dbo.participations(program_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_responses_canonical_field' AND object_id = OBJECT_ID(N'dbo.participation_responses'))
    CREATE INDEX IX_responses_canonical_field ON dbo.participation_responses(canonical_field);
GO

PRINT N'Creativa Foundation Schema v0.1 created successfully (or existing tables were preserved).';
GO
USE CreativaDB;
GO

SELECT
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;