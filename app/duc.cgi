#! /bin/bash

DB_FOLDER="/database"

get_db() {
    # Split the URL, extract "db" parameter and store its valeue in the $DB variable.
    # See https://stackoverflow.com/a/27671738/8369030.
    # If the "db" parameter can not be found or is empty, $DB gets set to "".
    URL=$1
    arr=(${URL//[?=&]/ })

    for i in {1..20}; do
        if [[ "${arr[$i]}" == "db" ]]; then
            let i=i+1
            DB=${arr[$i]}
            break;
        fi
    done
}

get_latest_db() {
    # Scans the database folder and sets the variable $DB with the name of the latest database (based on date/time in filename)
    WD=`pwd`
    for f in `ls -c1 $DB_FOLDER/duc_*.db | sort -r`; do
        DB=$f
        break
    done
    cd $WD
}

get_db "$REQUEST_URI"
if [[ "$DB" == "" ]]; then
    echo "DB parameter is missing or empty, using latest DB!<br>"
    get_latest_db
fi

duc cgi --database=$DB --dpi=120 --size=600 --list --levels 2 --header header.htm --footer footer.htm
