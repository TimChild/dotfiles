# Creating Scheduled Task on Windows


1. Open the Task Scheduler from the Start Menu.

2. In the Actions pane, click Create Basic Task....

3. Name the task something descriptive, like "WSL Backup".

4. Choose the Daily trigger.

5. Set the start date, and the time you want the backup to occur.

6. For action, choose Start a program.

7. In the program/script box, enter powershell.exe.

8. In the add arguments box, enter -File "C:\path\to\script.ps1". 

9. Finish the setup.
