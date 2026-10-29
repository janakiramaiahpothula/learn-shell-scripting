
#!/bin/bash

awk '
BEGIN {
    FS = "\t"

    printf "+----+----------+------------+----------+------------+\n"
    printf "| %-2s | %-8s | %-10s | %-8s | %-10s |\n",
           "id", "name", "role", "status", "company"
    printf "+----+----------+------------+----------+------------+\n"
}
{
    printf "| %-2s | %-8s | %-10s | %-8s | %-10s |\n",
           $1, $2, $3, $4, $5
    printf "+----+----------+------------+----------+------------+\n"
}
' <<'EOF'
id	name	role	status	company
1	Alice	Developer	ACTIVE	joindevops
2	Bob	Tester	INACTIVE	joindevops
3	Charlie	DevOps	ACTIVE	joindevops
4	Dave	Manager	INACTIVE	joindevops
5	Eve	Architect	ACTIVE	joindevops
6	Frank	Developer	ACTIVE	joindevops
7	Grace	Tester	INACTIVE	joindevops
8	Heidi	Developer	ACTIVE	joindevops
9	Ivan	DevOps	INACTIVE	joindevops
10	Judy	Manager	ACTIVE	joindevops
EOF
