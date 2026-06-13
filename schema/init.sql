-- AI-KungFU SII Stack — Database Schema
-- Source: Engineer's Schematic (Document 5)
-- 15 core tables + audit infrastructure

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone VARCHAR(20) UNIQUE,
    national_id VARCHAR(20),
    name VARCHAR(255),
    county VARCHAR(100),
    language VARCHAR(10) DEFAULT 'sw',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50), -- sme, sacco, ngo, individual
    registration_number VARCHAR(100),
    county VARCHAR(100),
    owner_id UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID REFERENCES users(id),
    org_id UUID REFERENCES organizations(id),
    type VARCHAR(100), -- national_id, business_permit, land_title, etc.
    status VARCHAR(50) DEFAULT 'pending', -- pending, verified, expired
    file_path TEXT,
    expiry_date DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    workflow_id UUID,
    type VARCHAR(100), -- permit_application, tax_filing, etc.
    status VARCHAR(50) DEFAULT 'open',
    priority VARCHAR(20) DEFAULT 'normal',
    due_date DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100), -- business_permit, land_transfer, tax_filing
    n8n_workflow_id VARCHAR(255),
    version INTEGER DEFAULT 1,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS agents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(50), -- research, form, verification, translation, financial, market, escalation
    model_tier VARCHAR(20), -- western, eastern, sovereign
    model_name VARCHAR(100),
    task_id UUID REFERENCES tasks(id),
    status VARCHAR(50) DEFAULT 'idle',
    tokens_used INTEGER DEFAULT 0,
    cost_usd DECIMAL(10,6) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS vendors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    county VARCHAR(100),
    phone VARCHAR(20),
    rating DECIMAL(3,2),
    verified BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    county VARCHAR(100) NOT NULL,
    sub_county VARCHAR(100),
    ward VARCHAR(100),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS prices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    commodity VARCHAR(100) NOT NULL,
    market VARCHAR(100),
    county VARCHAR(100),
    price_kes DECIMAL(12,2),
    unit VARCHAR(50),
    source VARCHAR(100),
    recorded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS laws (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(500) NOT NULL,
    category VARCHAR(100), -- land, tax, labour, health, education
    year INTEGER,
    summary TEXT,
    full_text_path TEXT,
    source_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS forms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100), -- permit, tax, registration, application
    fields JSONB,
    instructions TEXT,
    source_ministry VARCHAR(255),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    type VARCHAR(100), -- mpesa, bank, sacco
    amount_kes DECIMAL(12,2),
    reference VARCHAR(255),
    status VARCHAR(50),
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(255) NOT NULL,
    resource_type VARCHAR(100),
    resource_id UUID,
    agent_id UUID REFERENCES agents(id),
    -- Per Document 5 spec: source, confidence, date, agent_used, human_review_status, next_action
    source VARCHAR(255),
    confidence DECIMAL(5,4),
    human_review_status VARCHAR(50) DEFAULT 'pending',
    next_action TEXT,
    ip_address INET,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    task_id UUID REFERENCES tasks(id),
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    useful BOOLEAN,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_tasks_user ON tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_audit_resource ON audit_logs(resource_type, resource_id);
CREATE INDEX IF NOT EXISTS idx_prices_commodity ON prices(commodity, county);
CREATE INDEX IF NOT EXISTS idx_agents_task ON agents(task_id);

-- DEMO label for all AI-generated content
COMMENT ON TABLE audit_logs IS 'Every AI output must log source, confidence, and human_review_status. DEMO data must set source=DEMO.';
