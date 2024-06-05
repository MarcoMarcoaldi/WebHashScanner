# WebHashScanner.sh
A pure Linux Bash .php, .js, .css  Web Hash Scanner, for detect file change and new file injection, using SQLite for backend and hash storage.

![image](https://github.com/MarcoMarcoaldi/WebHashScanner/assets/113010551/fb436fc0-341d-46b7-bde7-188d39594c9c)


Following a cyber attack or malware infection, it is common to find the presence of backdoors and access vectors that allow the attacker to maintain control over the compromised system. These access vectors can involve the creation or modification of files, often days or weeks after the initial compromise, making it difficult to identify and completely remove the malware.

## Software Features
"Web Hash Scanner" is a software entirely based on Bash Shell and SQLite, designed to provide an effective and automated solution for monitoring file changes in a WordPress installation or other web platforms.

The software performs a comprehensive scan of all .js, .css, and .php files present in the web installation, creating a snapshot of the current state of the system. For each file found, the absolute file path, last modification date, and the MD5 hash of the file content are recorded, ensuring unique identification based on the content itself.

On subsequent runs, the software performs a new scan of the system and compares the results with the previously saved snapshot. The comparison highlights files that have undergone changes (with differences in the MD5 hash or modification date) and identifies any new files created.

A detailed report is generated listing the modified files, and for each file, the absolute path, previous and current modification dates, and previous and current MD5 hashes are reported. New files are highlighted with the absolute path and creation date.

This approach allows operators to focus on the files that have been actually modified or newly created, significantly reducing the time required to identify potential malware or backdoors inserted into the system. The ability to detect incremental changes over time helps to identify subtle and persistent modifications that might escape a superficial analysis.

## Software Usage
After removing an infection or cleaning the system, it is advisable to run the software to create a snapshot of the clean state of the system. During this phase, it is good practice not to install new .php, .js, or .css files, such as updates to WordPress plugins or Prestashop modules, as this could result in many false positive changes reported by the software. Subsequently, it is appropriate to periodically run the software to compare the current state with the saved snapshot, promptly identifying any suspicious changes.

Edit webhashscanner.sh and change DOCROOT_PATH to your Document Root installation (usually public_html, or htdocs or httpdocs), chmod +x the script and run ./webhashscanner.sh

Example (after create a new file) :

![image](https://github.com/MarcoMarcoaldi/WebHashScanner/assets/113010551/b85ac08e-7a5a-4ec3-8137-8911cc812fc1)

Example (after modify wp-config.php) :

![image](https://github.com/MarcoMarcoaldi/WebHashScanner/assets/113010551/79af9720-6af8-496a-8023-3597607d437a)


## Conclusion
"Web Hash Scanner" provides a reliable and automated method for monitoring changes to critical files in a web installation. With its ability to detect modified and newly created files, the software allows for targeted and timely analysis, helping to maintain the security and integrity of the system even in the face of persistent and sophisticated attacks.

