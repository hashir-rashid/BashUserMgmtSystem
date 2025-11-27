# User Management System Using Bash
This project implements a Linux-based user account management system using Bash scripts. The script automates administrative tasks, including adding, modifying, deleting, and listing system users and groups. It provides a menu-driven, user-friendly interface while ensuring security through proper password handling (i.e. hashing). It was created to simplify routine system administration and provide an extensible foundation for future enhancements.

## Requirements
- Ubuntu (latest version)

## How to run:
### Clone the repo. Must be in a bash terminal to execute:
```bash
git clone https://github.com/hashir-rashid/BashUserMgmtSystem.git@latest
```

### Run the app
```bash
bash main.sh
```

**OR**
```bash
chmod u+x main.sh
./main.sh
```

## Troubleshooting
### If an error mentioning "$\r" appears, do the following (one line at a time):
```bash
sudo apt install dos2unix
dos2unix `file_name_here`
```

