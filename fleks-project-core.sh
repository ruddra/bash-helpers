#!/bin/bash

#REPLACE THESE ITEMS WHEN CREATING A NEW PROJECT FROM THIS FILE: 'FLEKS_', 'fleks'

FLEKS_PYTHON_VERSION="3"
FLEKS_REPO_NAME="fleks-backend"
FLEKS_GIT_REPO="git@github.com:ITbtn/$FLEKS_REPO_NAME.git"
FLEKS_PROJECT_NAME="fleks"
FLEKS_CELERY_PROJECT_NAME="fleks"
FLEKS_PROJECT_NAME_UNDERSCORE="fleks"
FLEKS_PROJECT_NAME_CAMEL_CASE="fleks"
FLEKS_LOCAL_PORT="8003"
FLEKS_DJANGO_APP_NAMES="common fleks_email job location notification payment rest user video"
FLEKS_POSTGRES_USER="postgres"
FLEKS_CELERY_FLOWER_HOST="127.0.0.1"
FLEKS_CELERY_FLOWER_PORT="5555"

FLEKS_DJANGO_OPERATIONS="makemigrations migrate"
FLEKS_INIT_REQUIREMENTS_FILE_NAME='requirements.txt'
FLEKS_PROJECT_ROOT_FOLDER="$SYSTEM_ROOT_GIT_REPO_FOLDER/$FLEKS_REPO_NAME"
FLEKS_VIRTUAL_ENVIRONMENT_NAME="${FLEKS_PROJECT_NAME_CAMEL_CASE}Env"
FLEKS_INIT_DB_FILE_NAME="${FLEKS_PROJECT_NAME}-reset-db.sql"
FLEKS_POSTGRES_USER_PASSWORD_RESET_FILE_NAME="${FLEKS_PROJECT_NAME}-postgres-password-reset.sql"
FLEKS_INIT_DATA_LOAD_PYTHON_FILE_NAME="${FLEKS_PROJECT_NAME_UNDERSCORE}_init_data_load.py"
FLEKS_VIRTUAL_ENVIRONMENT_FOLDER="$SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER/$FLEKS_VIRTUAL_ENVIRONMENT_NAME"
FLEKS_INIT_POSTGRES_DB_FILE_PATH="$BASH_TEMP_FOLDER/$FLEKS_INIT_DB_FILE_NAME"
FLEKS_INIT_POSTGRES_DB_USER_PASSWORD_FILE_PATH="$BASH_TEMP_FOLDER/$FLEKS_POSTGRES_USER_PASSWORD_RESET_FILE_NAME"
FLEKS_INIT_DATA_LOAD_PYTHON_FILE_PATH="$FLEKS_PROJECT_ROOT_FOLDER/deployment/$FLEKS_INIT_DATA_LOAD_PYTHON_FILE_NAME"

if [ -f $BASH_TEMP_FOLDER/django-project-core.sh ]; then
    . $BASH_TEMP_FOLDER/django-project-core.sh
fi;

alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_bc="djangoBranchChange $FLEKS_PROJECT_NAME_UNDERSCORE "
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_bc_full_reset="djangoBranchChangeWithFullReset $FLEKS_PROJECT_NAME_UNDERSCORE "
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_bc_full_reset_and_run="djangoBranchChangeWithFullResetAndRun $FLEKS_PROJECT_NAME_UNDERSCORE "
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_bcd="${FLEKS_PROJECT_NAME_UNDERSCORE}_bc develop"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_bcd_full_reset="${FLEKS_PROJECT_NAME_UNDERSCORE}_bc_full_reset develop"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_bcd_full_reset_and_run="${FLEKS_PROJECT_NAME_UNDERSCORE}_bc_full_reset_and_run develop"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_bcd_run="${FLEKS_PROJECT_NAME_UNDERSCORE}_bcd && ${FLEKS_PROJECT_NAME_UNDERSCORE}_run"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_db_shell="${FLEKS_PROJECT_NAME_UNDERSCORE}_ve && ./manage.py shell"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_dir="goToDir \"$FLEKS_PROJECT_ROOT_FOLDER\""
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_frr="${FLEKS_PROJECT_NAME_UNDERSCORE}_full_reset && ${FLEKS_PROJECT_NAME_UNDERSCORE}_run"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_full_reset="djangoFullReset $FLEKS_PROJECT_NAME_UNDERSCORE"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_gf="${FLEKS_PROJECT_NAME_UNDERSCORE}_dir && git_f"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_git_setup="djangoGitSetup $FLEKS_GIT_REPO"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_last_10_commit_hash="${FLEKS_PROJECT_NAME_UNDERSCORE}_dir && git log -10 --pretty=format:\"%h\""
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_loc="cloc \"$FLEKS_PROJECT_ROOT_FOLDER\""
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_reinitiate="djangoReinitiate \"$FLEKS_PROJECT_ROOT_FOLDER\" \"$FLEKS_DJANGO_APP_NAMES\" $FLEKS_INIT_DATA_LOAD_PYTHON_FILE_PATH \"$FLEKS_DJANGO_OPERATIONS\""
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_reinitiate_clean="djangoReinitiateClean \"$FLEKS_PROJECT_ROOT_FOLDER\" \"$FLEKS_DJANGO_OPERATIONS\""
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_postgres_shell="psql -U $FLEKS_POSTGRES_USER"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_postgres_user_password_reset="postgresPasswordReset \"$FLEKS_INIT_POSTGRES_DB_USER_PASSWORD_FILE_PATH\""
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_process_id="lsof -i:${FLEKS_LOCAL_PORT} | awk '{print $2}'"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_psql_reset="djangoPsqlReset $FLEKS_POSTGRES_USER \"$FLEKS_INIT_POSTGRES_DB_FILE_PATH\""
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_reset="djangoReset $FLEKS_PROJECT_NAME_UNDERSCORE"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_rr="${FLEKS_PROJECT_NAME_UNDERSCORE}_reset && ${FLEKS_PROJECT_NAME_UNDERSCORE}_run"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_rt="${FLEKS_PROJECT_NAME_UNDERSCORE}_reset && ${FLEKS_PROJECT_NAME_UNDERSCORE}_test"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_run="djangoRun $FLEKS_PROJECT_NAME_UNDERSCORE $FLEKS_PROJECT_NAME_UNDERSCORE $FLEKS_LOCAL_PORT"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_run_production="djangoProductionRun $FLEKS_PROJECT_NAME_UNDERSCORE $FLEKS_PROJECT_NAME $FLEKS_LOCAL_PORT"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_run_generic_deployment="djangoDeploymentOperations $FLEKS_PROJECT_NAME_UNDERSCORE"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_start_celery="startCeleryWorkers $FLEKS_CELERY_PROJECT_NAME $FLEKS_CELERY_FLOWER_HOST $FLEKS_CELERY_FLOWER_PORT"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_stop_processes="djangoStopProcesses $FLEKS_LOCAL_PORT $FLEKS_CELERY_PROJECT_NAME"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_test="djangoTest $FLEKS_PROJECT_NAME_UNDERSCORE"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_ve="djangoUseVe \"$FLEKS_VIRTUAL_ENVIRONMENT_FOLDER\" $FLEKS_PROJECT_NAME_UNDERSCORE"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_ve_check="checkVirtualPythonEnvironmentFolder \"$FLEKS_VIRTUAL_ENVIRONMENT_FOLDER\" \"$SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER\" $FLEKS_VIRTUAL_ENVIRONMENT_NAME"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_ve_clear="djangoVeClear \"$SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER\" $FLEKS_VIRTUAL_ENVIRONMENT_NAME"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_ve_init="pythonVeVersionDecider \"$FLEKS_VIRTUAL_ENVIRONMENT_FOLDER\" \"$SYSTEM_ROOT_VIRTUAL_PYTHON_ENVIRONMENT_FOLDER\" $FLEKS_VIRTUAL_ENVIRONMENT_NAME $FLEKS_PROJECT_NAME \"$FLEKS_PYTHON_VERSION\""
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_ve_installs="djangoDefaultSetup \"$FLEKS_PROJECT_ROOT_FOLDER\" $FLEKS_INIT_REQUIREMENTS_FILE_NAME $FLEKS_PROJECT_NAME_UNDERSCORE"
alias ${FLEKS_PROJECT_NAME_UNDERSCORE}_installs="${FLEKS_PROJECT_NAME_UNDERSCORE}_ve_init && cd \"$SYSTEM_ROOT_GIT_REPO_FOLDER\" && git clone ${FLEKS_GIT_REPO} && ${FLEKS_PROJECT_NAME_UNDERSCORE}_ve_installs && ${FLEKS_PROJECT_NAME_UNDERSCORE}_dir"
