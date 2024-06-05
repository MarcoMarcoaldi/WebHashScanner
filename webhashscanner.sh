#!/bin/bash

# Check if sqlite3 is installed
if ! command -v sqlite3 &> /dev/null; then
    echo "sqlite3 is not installed. Please install sqlite3 and try again."
    exit 1
fi

# Path of the WordPress installation
DOCROOT_PATH="/home/pathtoyourwebsite/htdocs/"

# Name of the SQLite database
DB_NAME="webhashscan.db"

# Date of the scan
SCAN_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Create the database and tables if they do not exist
sqlite3 $DB_NAME <<EOF
CREATE TABLE IF NOT EXISTS files (
    id INTEGER PRIMARY KEY,
    scan_id INTEGER,
    file_path TEXT,
    file_date TEXT,
    file_md5 TEXT,
    scan_date TEXT
);
CREATE TABLE IF NOT EXISTS scans (
    scan_id INTEGER PRIMARY KEY AUTOINCREMENT,
    scan_date TEXT
);
EOF

# Insert a new scan and get the scan ID
SCAN_ID=$(sqlite3 $DB_NAME <<EOF
INSERT INTO scans (scan_date) VALUES ('$SCAN_DATE');
SELECT last_insert_rowid();
EOF
)

# Function to scan files and save data to the database
scan_files() {
    local path=$1
    find "$path" -type f \( -name "*.php" -o -name "*.js" -o -name "*.css" \) | while read -r file; do
        file_date=$(stat -c %y "$file")
        file_md5=$(md5sum "$file" | awk '{ print $1 }')
        sqlite3 $DB_NAME <<EOF
INSERT INTO files (scan_id, file_path, file_date, file_md5, scan_date)
VALUES ($SCAN_ID, '$file', '$file_date', '$file_md5', '$SCAN_DATE');
EOF
    done
}

# Scan files in the WordPress installation
scan_files "$DOCROOT_PATH"

# Compare the current scan with the previous one
compare_scans() {
    # Get the ID of the previous scan
    PREV_SCAN_ID=$(sqlite3 $DB_NAME <<EOF
SELECT scan_id FROM scans WHERE scan_id < $SCAN_ID ORDER BY scan_id DESC LIMIT 1;
EOF
)

    if [ -z "$PREV_SCAN_ID" ]; then
        echo "No previous scan found. This is the first scan."
        exit 0
    fi

    # Compare files between the two scans
    sqlite3 $DB_NAME <<EOF
.headers on
.mode column
SELECT
    f1.file_path AS "File Path",
    f1.file_date AS "Current Date",
    f2.file_date AS "Previous Date",
    f1.file_md5 AS "Current MD5",
    f2.file_md5 AS "Previous MD5"
FROM
    files f1
LEFT JOIN
    files f2
ON
    f1.file_path = f2.file_path
    AND f2.scan_id = $PREV_SCAN_ID
WHERE
    f1.scan_id = $SCAN_ID
    AND (f1.file_md5 != f2.file_md5 OR f2.file_md5 IS NULL);
EOF
}

# Perform the scan comparison
compare_scans

echo "Scan completed. Scan ID: $SCAN_ID"
