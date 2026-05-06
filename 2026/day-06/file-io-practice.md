– 𝗟𝗶𝗻𝘂𝘅 𝗙𝘂𝗻𝗱𝗮𝗺𝗲𝗻𝘁𝗮𝗹𝘀: 𝗙𝗶𝗹𝗲 𝗜/𝗢, 𝗣𝗲𝗿𝗺𝗶𝘀𝘀𝗶𝗼𝗻𝘀 & 𝗙𝗶𝗹𝗲 𝗧𝘆𝗽𝗲𝘀

🚀 Day 06 of #90DaysOfDevOps

Focused on the basics of 𝗿𝗲𝗮𝗱𝗶𝗻𝗴, 𝘄𝗿𝗶𝘁𝗶𝗻𝗴, 𝗮𝗻𝗱 𝘂𝗻𝗱𝗲𝗿𝘀𝘁𝗮𝗻𝗱𝗶𝗻𝗴 𝗳𝗶𝗹𝗲𝘀 𝗶𝗻 𝗟𝗶𝗻𝘂𝘅—a core skill for stepping into DevOps.

🔹 𝗪𝗵𝗮𝘁 𝗜 𝗽𝗿𝗮𝗰𝘁𝗶𝗰𝗲𝗱 :
𝘁𝗼𝘂𝗰𝗵 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Creates a new empty file
𝗲𝗰𝗵𝗼 "𝗙𝗶𝗿𝘀𝘁 𝗹𝗶𝗻𝗲" > 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Writes content to a file
𝗲𝗰𝗵𝗼 "𝗦𝗲𝗰𝗼𝗻𝗱 𝗹𝗶𝗻𝗲" >> 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Appends content without removing existing content
𝗲𝗰𝗵𝗼 "𝗟𝗶𝗻𝘂𝘅" | 𝘁𝗲𝗲 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Writes and displays output at the same time
𝗰𝗮𝘁 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Displays full file content
𝗵𝗲𝗮𝗱 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Shows first 10 lines
𝘁𝗮𝗶𝗹 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Shows last 10 lines

🔹 𝗚𝗼𝗶𝗻𝗴 𝗯𝗲𝘆𝗼𝗻𝗱 𝗯𝗮𝘀𝗶𝗰𝘀:
𝗹𝘀 -𝗹 → Displays detailed file info including permissions and ownership
𝗰𝗵𝗺𝗼𝗱 𝟳𝟱𝟱 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Modifies file permissions
𝗰𝗵𝗼𝘄𝗻 𝘂𝘀𝗲𝗿:𝗴𝗿𝗼𝘂𝗽 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Changes file ownership
𝗳𝗶𝗹𝗲 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Identifies file type
𝗹𝗲𝘀𝘀 𝗳𝗶𝗹𝗲.𝘁𝘅𝘁 → Opens file in scrollable view for large content

💡 𝗞𝗲𝘆 𝗟𝗲𝗮𝗿𝗻𝗶𝗻𝗴𝘀:
  • > overwrites, while >> appends safely
  • 𝘁𝗲𝗲 is extremely useful for logs and debugging
  • File permissions (-𝗿𝘄𝘅 𝗿𝘄- 𝗿--) are critical for security
  • Understanding file types helps in troubleshooting
  • Efficient file reading saves time with large logs




Output 1:

ubuntu@ip-172-31-22-32:~$ touch notes.txt
ubuntu@ip-172-31-22-32:~$ ls
aws  awscliv2.zip  notes.txt
ubuntu@ip-172-31-22-32:~$ echo "This is line 1" > notes.txt
ubuntu@ip-172-31-22-32:~$ echo "This is line 2" >> notes.txt
ubuntu@ip-172-31-22-32:~$ echo "This is line 3" | tee -a notes.txt
This is line 3
ubuntu@ip-172-31-22-32:~$ cat notes.txt
This is line 1
This is line 2
This is line 3
ubuntu@ip-172-31-22-32:~$ head -n 2 notes.txt
This is line 1
This is line 2
ubuntu@ip-172-31-22-32:~$ tail -n 2 notes.txt
This is line 2
This is line 3
ubuntu@ip-172-31-22-32:~$



Output 2: 
ubuntu@ip-172-31-22-32:~$ ls
aws  awscliv2.zip  notes.txt
ubuntu@ip-172-31-22-32:~$  ls -l notes.txt
-rw-rw-r-- 1 ubuntu ubuntu 45 Apr 28 14:41 notes.txt
ubuntu@ip-172-31-22-32:~$ chmod 644 notes.txt
ubuntu@ip-172-31-22-32:~$ ls -l notes.txt
-rw-r--r-- 1 ubuntu ubuntu 45 Apr 28 14:41 notes.txt
ubuntu@ip-172-31-22-32:~$ file notes.txt
notes.txt: ASCII text
ubuntu@ip-172-31-22-32:~$ ls -F
aws/  awscliv2.zip  notes.txt
ubuntu@ip-172-31-22-32:~$
