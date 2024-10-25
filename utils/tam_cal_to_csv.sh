#!/bin/bash

CURL_OUTPUT_FILE=schedule.json
CURL_OUTPUT_FILE_FILTERED=schedule_filtered.json
SCHEDULE_CSV_FILE=tam_schedule.csv
export START_DAY=2024-11-01
export END_DAY=2025-04-01

# Sports
# 21 Baseball
# 3 Basketball, boys
# 12 Basketball, boys
# 53 Diving
# 30 Field Hockey
# 1 Football
# 23 Lacrosse, boys
# 35 Lacrosse, girls
# 24 Soccer, boys
# 25 Soccer, girls
# 20 Softball
# 18 Swimming & Diving, boys
# 19 Swimming & Diving, girls
# 26 Tennis, boys
# 27 Tennis, girls
# 28 Track and Field, boys
# 29 Track and Field, girls
# 11 Volleyball, boys
# 13 Volleyball, girls
# 31 Water polo, boys
# 32 Water polo, girls
# 15 Wrestling, boys
# 43 Wrestling, girls
SPORT_IDS="21, 3, 12, 30, 1, 23, 35, 24, 25, 20, 18, 19, 26, 27, 28, 29, 11, 13, 31, 32, 15, 43"

curl -q "https://www.cifncshome.org/widget/calendar?filters%5B%5D=year&sport_id=&filters%5B%5D=sport&filters%5B%5D=level&filters%5B%5D=game_type&filters%5B%5D=opponent&filters%5B%5D=facility&view=dayGridMonth&layout=top&school_id=1550&year_id=160&level_id=1&opponent_school_id=&game_type=&facility_id=&event_type_ids%5B%5D=home&ajax=1&start=${START_DAY}T00%3A00%3A00Z&end=${END_DAY}T00%3A00%3A00Z&timeZone=UTC" > $CURL_OUTPUT_FILE

# keys
#cat  $CURL_OUTPUT_FILE | jq .[0] | jq -r "keys_unsorted"

# filtered
cat $CURL_OUTPUT_FILE | jq ".[] | select(.sport_id == ($SPORT_IDS))" > $CURL_OUTPUT_FILE_FILTERED

# csv output
#  .level, .location,
cat $CURL_OUTPUT_FILE_FILTERED | jq -r '. | [.date, .sport, .opponent_schools, .time_from] | @csv' | sed 's/Football (11 person)/Football/g' > $SCHEDULE_CSV_FILE