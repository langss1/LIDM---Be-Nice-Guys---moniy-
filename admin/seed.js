require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error("Missing SUPABASE_URL or SUPABASE_KEY in .env file");
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function seed() {
    console.log("Starting database seed...");

    try {
        // 1. Seed Users
        const { data: users, error: userError } = await supabase.from('users').insert([
            { email: 'admin@moniy.id', name: 'Admin', role: 'admin', level: 99, xp: 9999 },
            { email: 'fanan@moniy.id', name: 'Fanan Agfian Mozart', nickname: 'Mozart', phone: '+62-851-6767-9900', level: 3, xp: 70, total_streak: 12 },
            { email: 'budi@moniy.id', name: 'Budi Kancil', level: 1, xp: 150 }
        ]).select();
        
        if (userError) throw userError;
        console.log("✅ Users seeded");

        // 2. Seed Module Topics
        const { data: topics, error: topicError } = await supabase.from('module_topics').insert([
            { title: 'Budgeting Dasar', icon: 'wallet', color: 'teal' },
            { title: 'Mulai Investasi', icon: 'trendingUp', color: 'blue' },
            { title: 'Risiko Online & Keamanan', icon: 'shield', color: 'red' },
            { title: 'Target Menabung', icon: 'piggyBank', color: 'amber' }
        ]).select();

        if (topicError) throw topicError;
        console.log("✅ Module Topics seeded");

        // 3. Seed Modules
        if (topics && topics.length > 0) {
            const { data: modules, error: modError } = await supabase.from('modules').insert([
                { topic_id: topics[0].id, title: 'Membuka Bisnis Top-Up game', genre: 'Dasar', lessons: 3, duration: '15 Menit', is_new: true },
                { topic_id: topics[1].id, title: 'Investasi Saham Pemula', genre: 'Menengah', lessons: 8, duration: '30 Menit', is_new: false },
                { topic_id: topics[2].id, title: 'Mengenal Asuransi', genre: 'Dasar', lessons: 10, duration: '35 Menit', is_new: true }
            ]).select();

            if (modError) throw modError;
            console.log("✅ Modules seeded");
            
            // 4. Seed Game Scenarios
            if (modules && modules.length > 0) {
                 const { error: gameError } = await supabase.from('game_scenarios').insert([
                     { 
                         module_id: modules[0].id, 
                         story_text: "Kamu melihat iklan diskon diamond yang sangat murah di grup Telegram.",
                         decision_text: "Apa yang akan kamu lakukan?",
                         options: ["Beli sekarang", "Abaikan dan nabung"],
                         correct_option: 1,
                         result_title: "Keputusan Tepat!",
                         result_description: "Kamu terhindar dari penipuan.",
                         warning_text: "Awas penipuan!",
                         balance: "Rp 320.000"
                     }
                 ]);
                 if (gameError) throw gameError;
                 console.log("✅ Game Scenarios seeded");
            }
        }

        // 5. Seed Community Groups
        const { data: groups, error: groupError } = await supabase.from('community_groups').insert([
            { name: 'Pejuang Cuan Cerdas', description: 'Ruang aman untuk diskusi finansial', visibility: 'public' }
        ]).select();
        
        if (groupError) throw groupError;
        console.log("✅ Community Groups seeded");

        // 6. Seed Posts
        if (groups && groups.length > 0 && users && users.length > 1) {
            const { error: postError } = await supabase.from('community_posts').insert([
                { user_id: users[1].id, group_id: groups[0].id, content: 'Jebakan FOMO dalam investasi...', likes: 42, comments: 12 },
                { user_id: users[2].id, group_id: groups[0].id, content: 'Berhasil nabung 1 juta bulan ini!', likes: 156, comments: 24 }
            ]);
            
            if (postError) throw postError;
            console.log("✅ Community Posts seeded");
        }

        // 7. Seed Badges
        const { error: badgeError } = await supabase.from('badges').insert([
            { name: 'Pemula', icon: 'medal', color: 'blue' },
            { name: 'Konsisten 7 Hari', icon: 'flame', color: 'orange' },
            { name: 'Hemat 100K', icon: 'piggyBank', color: 'green' }
        ]);

        if (badgeError) throw badgeError;
        console.log("✅ Badges seeded");
        
        console.log("🎉 Seed completed successfully!");

    } catch (err) {
        console.error("❌ Seeding failed:", err.message);
    }
}

seed();
