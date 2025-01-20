#!/bin/bash

# Configuration variables
JENKINS_HOME="/var/lib/jenkins"  # Jenkins home directory (default for many Linux setups)
BACKUP_DIR="/home/ubuntu//JenkinsackupV2/Jen_BackupsV2" 
GIT_REPO_DIR="/home/ubuntu/JenkinsBackupV2"  # Local Git repository directory
REMOTE_GIT_REPO="https://github.com/Rajani0206/JenkinsBackupV2.git"  # Replace with your actual repository URL
BRANCH_NAME="master"               # Git branch (e.g., main or backup)
JOB_NAME="Tomcat_install"         # Replace with the specific job name to backup (optional)

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if a specific job is provided
if [[ -n "$JOB_NAME" ]]; then
  # Backup only the specified job
  JOB_CONFIG_PATH="$JENKINS_HOME/jobs/$JOB_NAME/config.xml"
  JOB_BUILDS_PATH="$JENKINS_HOME/jobs/$JOB_NAME/builds"
  BACKUP_PATH="$BACKUP_DIR/$JOB_NAME"
  mkdir -p "$BACKUP_PATH"
  echo "Backing up Jenkins job '$JOB_NAME'..."
  sudo cp "$JOB_CONFIG_PATH" "$BACKUP_PATH/config.xml"
  sudo cp -r "$JOB_BUILDS_PATH" "$BACKUP_PATH/builds"
else
  # Backup all jobs
  echo "Backing up all Jenkins jobs..."
  find "$JENKINS_HOME/jobs" -type f -name 'config.xml' -execdir cp {} "$BACKUP_DIR/$(dirname {})" \;
  find "$JENKINS_HOME/jobs" -type d -name 'builds' -execdir cp -r {} "$BACKUP_DIR/" \;
fi

# Git operations
cd "$GIT_REPO_DIR"
git add .
git commit -m "Jenkins backup - $(date +%Y-%m-%d_%H-%M-%S)"
git push -u origin master

echo "Jenkins backup completed and pushed to Git repository!"
