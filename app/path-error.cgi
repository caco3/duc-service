#!/usr/bin/env bash

set -euo pipefail

echo "Content-type: text/html"; echo

cat <<EOF
<!DOCTYPE html>
<head>
  <title>Storage Analyzer</title>
  <meta charset="utf-8" />
  <link rel="stylesheet" type="text/css" href="style.css">
</head>
 <body>
EOF


cat header.htm
cat path-error.htm
cat footer.htm

cat <<EOF
  </body>
</html>
EOF