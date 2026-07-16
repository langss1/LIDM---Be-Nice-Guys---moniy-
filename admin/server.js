require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { createClient } = require('@supabase/supabase-js');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Supabase client setup
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error("Missing SUPABASE_URL or SUPABASE_KEY in .env file");
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Middleware to inject supabase client into request
app.use((req, res, next) => {
    req.supabase = supabase;
    next();
});

// --- API Routes ---

// Dashboard Stats
app.get('/api/dashboard/stats', async (req, res) => {
    try {
        const [usersResp, modulesResp, groupsResp, postsResp] = await Promise.all([
            req.supabase.from('users').select('*', { count: 'exact', head: true }),
            req.supabase.from('modules').select('*', { count: 'exact', head: true }),
            req.supabase.from('community_groups').select('*', { count: 'exact', head: true }),
            req.supabase.from('community_posts').select('*', { count: 'exact', head: true })
        ]);

        res.json({
            success: true,
            data: {
                totalUsers: usersResp.count || 0,
                totalModules: modulesResp.count || 0,
                totalGroups: groupsResp.count || 0,
                totalPosts: postsResp.count || 0
            }
        });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});

// Users CRUD
app.get('/api/users', async (req, res) => {
    const { data, error } = await req.supabase.from('users').select('*').order('created_at', { ascending: false });
    if (error) return res.status(500).json({ success: false, error: error.message });
    res.json({ success: true, data });
});

// Add more endpoints as needed...

// Catch-all for HTML5 routing
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(port, () => {
    console.log(`Moniy Admin Panel running on http://localhost:${port}`);
});
