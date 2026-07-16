-- Drop existing tables if necessary
DROP TABLE IF EXISTS "user_badges";
DROP TABLE IF EXISTS "badges";
DROP TABLE IF EXISTS "community_posts";
DROP TABLE IF EXISTS "group_members";
DROP TABLE IF EXISTS "community_groups";
DROP TABLE IF EXISTS "user_module_progress";
DROP TABLE IF EXISTS "game_scenarios";
DROP TABLE IF EXISTS "modules";
DROP TABLE IF EXISTS "module_topics";
DROP TABLE IF EXISTS "guardians";
DROP TABLE IF EXISTS "streak_records";
DROP TABLE IF EXISTS "users";

-- 1. Users Table
CREATE TABLE "users" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) UNIQUE NOT NULL,
    "phone" VARCHAR(50),
    "nickname" VARCHAR(255),
    "avatar" TEXT,
    "level" INTEGER DEFAULT 1,
    "xp" INTEGER DEFAULT 0,
    "total_streak" INTEGER DEFAULT 0,
    "role" VARCHAR(50) DEFAULT 'user',
    "is_gambling_block" BOOLEAN DEFAULT FALSE,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Module Topics Table
CREATE TABLE "module_topics" (
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR(255) NOT NULL,
    "icon" VARCHAR(255),
    "color" VARCHAR(50),
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Modules Table
CREATE TABLE "modules" (
    "id" SERIAL PRIMARY KEY,
    "topic_id" INTEGER REFERENCES "module_topics"("id") ON DELETE CASCADE,
    "title" VARCHAR(255) NOT NULL,
    "genre" VARCHAR(100),
    "lessons" INTEGER DEFAULT 0,
    "duration" VARCHAR(100),
    "is_new" BOOLEAN DEFAULT FALSE,
    "image_url" TEXT,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. User Module Progress Table
CREATE TABLE "user_module_progress" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES "users"("id") ON DELETE CASCADE,
    "module_id" INTEGER REFERENCES "modules"("id") ON DELETE CASCADE,
    "progress" FLOAT DEFAULT 0.0,
    "score" INTEGER DEFAULT 0,
    "completed_at" TIMESTAMP WITH TIME ZONE,
    UNIQUE("user_id", "module_id")
);

-- 5. Game Scenarios Table
CREATE TABLE "game_scenarios" (
    "id" SERIAL PRIMARY KEY,
    "module_id" INTEGER REFERENCES "modules"("id") ON DELETE CASCADE,
    "story_text" TEXT NOT NULL,
    "decision_text" TEXT NOT NULL,
    "options" JSONB NOT NULL,
    "correct_option" INTEGER,
    "result_title" VARCHAR(255),
    "result_description" TEXT,
    "warning_text" TEXT,
    "balance" VARCHAR(100),
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Community Groups Table
CREATE TABLE "community_groups" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "visibility" VARCHAR(50) DEFAULT 'public',
    "cover_image" TEXT,
    "rules" JSONB,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. Group Members Table
CREATE TABLE "group_members" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES "users"("id") ON DELETE CASCADE,
    "group_id" INTEGER REFERENCES "community_groups"("id") ON DELETE CASCADE,
    "role" VARCHAR(50) DEFAULT 'member',
    "joined_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE("user_id", "group_id")
);

-- 8. Community Posts Table
CREATE TABLE "community_posts" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES "users"("id") ON DELETE CASCADE,
    "group_id" INTEGER REFERENCES "community_groups"("id") ON DELETE SET NULL,
    "content" TEXT NOT NULL,
    "author_location" VARCHAR(255),
    "likes" INTEGER DEFAULT 0,
    "comments" INTEGER DEFAULT 0,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 9. Guardians Table
CREATE TABLE "guardians" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES "users"("id") ON DELETE CASCADE,
    "name" VARCHAR(255) NOT NULL,
    "relation" VARCHAR(100),
    "telegram_id" VARCHAR(100),
    "connected" BOOLEAN DEFAULT FALSE,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 10. Badges Table
CREATE TABLE "badges" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "icon" VARCHAR(255),
    "color" VARCHAR(50),
    "description" TEXT,
    "required_xp" INTEGER DEFAULT 0,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 11. User Badges Table
CREATE TABLE "user_badges" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES "users"("id") ON DELETE CASCADE,
    "badge_id" INTEGER REFERENCES "badges"("id") ON DELETE CASCADE,
    "earned_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE("user_id", "badge_id")
);

-- 12. Streak Records Table
CREATE TABLE "streak_records" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES "users"("id") ON DELETE CASCADE,
    "date" DATE NOT NULL,
    "completed" BOOLEAN DEFAULT FALSE,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE("user_id", "date")
);

-- Disable Row Level Security (RLS) to simplify phase 1 integration with Express backend
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE module_topics DISABLE ROW LEVEL SECURITY;
ALTER TABLE modules DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_module_progress DISABLE ROW LEVEL SECURITY;
ALTER TABLE game_scenarios DISABLE ROW LEVEL SECURITY;
ALTER TABLE community_groups DISABLE ROW LEVEL SECURITY;
ALTER TABLE group_members DISABLE ROW LEVEL SECURITY;
ALTER TABLE community_posts DISABLE ROW LEVEL SECURITY;
ALTER TABLE guardians DISABLE ROW LEVEL SECURITY;
ALTER TABLE badges DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges DISABLE ROW LEVEL SECURITY;
ALTER TABLE streak_records DISABLE ROW LEVEL SECURITY;
