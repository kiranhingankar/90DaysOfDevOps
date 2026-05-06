🚀 Day 25 of #90DaysOfDevOps | 𝗚𝗶𝘁: 𝗥𝗲𝘀𝗲𝘁 𝘃𝘀 𝗥𝗲𝘃𝗲𝗿𝘁 & 𝗕𝗿𝗮𝗻𝗰𝗵𝗶𝗻𝗴 𝗦𝘁𝗿𝗮𝘁𝗲𝗴𝗶𝗲𝘀

Hands-on exploration of git reset, git revert, and branching strategies used in production.

🔹 𝗚𝗶𝘁 𝗥𝗲𝘀𝗲𝘁 — 𝗥𝗲𝘄𝗿𝗶𝘁𝗶𝗻𝗴 𝗛𝗶𝘀𝘁𝗼𝗿𝘆
👉 𝗴𝗶𝘁 𝗿𝗲𝘀𝗲𝘁 --𝘀𝗼𝗳𝘁 𝗛𝗘𝗔𝗗~𝟭
✔ Moves HEAD back
✔ Keeps changes in staging area
💡 Best for: fixing the last commit message or regrouping changes

👉 𝗴𝗶𝘁 𝗿𝗲𝘀𝗲𝘁 --𝗺𝗶𝘅𝗲𝗱 𝗛𝗘𝗔𝗗~𝟭
✔ Moves HEAD back
✔ Unstages changes (kept in working directory)
💡 Best for: reworking changes before committing again

👉 𝗴𝗶𝘁 𝗿𝗲𝘀𝗲𝘁 --𝗵𝗮𝗿𝗱 𝗛𝗘𝗔𝗗~𝟭 ⚠️
✔ Moves HEAD back
❌ Deletes changes from staging + working directory
💡 Best for: discarding unwanted local changes permanently


🔹 𝗚𝗶𝘁 𝗥𝗲𝘃𝗲𝗿𝘁 — 𝗦𝗮𝗳𝗲 𝗨𝗻𝗱𝗼 (𝗡𝗼 𝗛𝗶𝘀𝘁𝗼𝗿𝘆 𝗥𝗲𝘄𝗿𝗶𝘁𝗲)
👉 𝗴𝗶𝘁 𝗿𝗲𝘃𝗲𝗿𝘁 <𝗰𝗼𝗺𝗺𝗶𝘁>
✔ Creates a new commit that reverses changes
✔ Original commit stays in history
💡 Best for: undoing changes in shared/pushed branches


🔹 𝗥𝗲𝘀𝗲𝘁 𝘃𝘀 𝗥𝗲𝘃𝗲𝗿𝘁
• 𝗴𝗶𝘁 𝗿𝗲𝘀𝗲𝘁 → rewrites history (not safe after push)
• 𝗴𝗶𝘁 𝗿𝗲𝘃𝗲𝗿𝘁 → preserves history (safe for teams)


🔹 𝗦𝗮𝗳𝗲𝘁𝘆 𝗡𝗲𝘁
👉 𝗴𝗶𝘁 𝗿𝗲𝗳𝗹𝗼𝗴
✔ Tracks every HEAD movement
💡 Lifesaver to recover lost commits even after hard reset 🔥


🔹 𝗕𝗿𝗮𝗻𝗰𝗵𝗶𝗻𝗴 𝗦𝘁𝗿𝗮𝘁𝗲𝗴𝗶𝗲𝘀 (𝗛𝗼𝘄 𝗧𝗲𝗮𝗺𝘀 𝗪𝗼𝗿𝗸 𝗮𝘁 𝗦𝗰𝗮𝗹𝗲)

📌 𝗚𝗶𝘁𝗙𝗹𝗼𝘄
• Multiple branches: 𝗺𝗮𝗶𝗻, 𝗱𝗲𝘃𝗲𝗹𝗼𝗽, 𝗳𝗲𝗮𝘁𝘂𝗿𝗲, 𝗿𝗲𝗹𝗲𝗮𝘀𝗲, 𝗵𝗼𝘁𝗳𝗶𝘅
• Best for: large teams with scheduled releases
• 👍 Stable releases
• 👎 Complex workflow

📌 𝗚𝗶𝘁𝗛𝘂𝗯 𝗙𝗹𝗼𝘄
• main + feature branches + pull requests
• Best for: startups & CI/CD environments
• 👍 Simple & fast deployment
• 👎 Less structured for big releases

📌 𝗧𝗿𝘂𝗻𝗸-𝗕𝗮𝘀𝗲𝗱 𝗗𝗲𝘃𝗲𝗹𝗼𝗽𝗺𝗲𝗻𝘁
• Everyone works on main (short-lived branches)
• Best for: high-speed teams (like big tech)
• 👍 Faster integration, fewer conflicts
• 👎 Requires strong testing & discipline


💡 Biggest Takeaways:
✔ Don’t use 𝗴𝗶𝘁 𝗿𝗲𝘀𝗲𝘁 --𝗵𝗮𝗿𝗱 unless you're 100% sure
✔ Prefer 𝗴𝗶𝘁 𝗿𝗲𝘃𝗲𝗿𝘁 for collaboration
✔ Choose branching strategy based on team size & release cycle
